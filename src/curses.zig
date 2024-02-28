const std = @import("std");
const terminfo = @import("terminfo.zig");
const common = @import("common.zig");

pub const Color = common.Color;

pub const util = @import("utils.zig");
pub const tinfo_fields = @import("tinfo-fields.zig");

const command = @import("command.zig");

const draw = @import("draw_screen.zig");
pub const draw_screen = draw.draw_screen;
pub const update_cursor = draw.update_cursor;

pub const cmd = @import("screen_command.zig");
pub const input = @import("input.zig");

pub const InitError = error{
    NoTermEnvVar,
    NoTermSizeSpecifier,
};

pub const TerminalInfo = terminfo.TerminalInfo;
pub const Terminal = struct {
    tinfo: *TerminalInfo,
    max_colors: i16 = -1,
    max_color_pairs: i16 = -1,
    color_mode: common.ColorMode = undefined,
    automatic_wrap: bool = false,
    orig_termios: std.os.system.termios,
    curr_termios: std.os.system.termios,
    tty_file: std.fs.File,
};

pub const Screen = struct {
    term: *Terminal,
    buffer: [][]u32 = undefined,
    buffer_allocated: bool = false,

    columns: usize,
    lines: usize,
    cursor_x: usize,
    cursor_y: usize,
    saved_x: usize,
    saved_y: usize,

    text_attribs: [9]u8 = .{0} ** 9,
    current_bg: Color = Color.Black,
    current_fg: Color = Color.White,
};

// man 3 termios
fn prepare_terminal_posix(term: *Terminal) !void {
    term.tty_file = try std.fs.cwd().openFile("/dev/tty", .{ .mode = .read_write });

    var termios = try std.os.tcgetattr(term.tty_file.handle);
    term.orig_termios = termios;

    termios.lflag &= ~@as(
        std.os.system.tcflag_t,
        std.os.system.ECHO | std.os.system.ICANON | std.os.system.ISIG | std.os.system.IEXTEN,
    );

    termios.iflag &= ~@as(
        std.os.system.tcflag_t,
        std.os.system.IXON | std.os.system.INLCR | std.os.system.BRKINT | std.os.system.INPCK | std.os.system.ISTRIP,
    );

    termios.oflag &= ~@as(std.os.system.tcflag_t, std.os.system.OPOST);
    termios.cflag |= std.os.system.CS8;

    termios.cc[std.os.system.V.TIME] = 0;
    termios.cc[std.os.system.V.MIN] = 1;

    // Save the edited termios
    try std.os.tcsetattr(term.tty_file.handle, .FLUSH, termios);

    term.curr_termios = termios;

    if (command.checkCapability(term.tinfo, tinfo_fields.str_save_cursor) == .Absent or
        command.checkCapability(term.tinfo, tinfo_fields.str_enter_ca_mode) == .Absent)
    {
        return error.CapabilityUnsupported;
    }

    try std.io.getStdOut().writeAll(term.tinfo.strings[tinfo_fields.str_save_cursor].?);
    try std.io.getStdOut().writeAll(term.tinfo.strings[tinfo_fields.str_enter_ca_mode].?);
}

const builtin = @import("builtin");

pub fn prepare_terminal(term: *Terminal) !void {
    switch (builtin.os.tag) {
        std.Target.Os.Tag.linux => try prepare_terminal_posix(term),
        else => return,
    }
}

pub fn new_term(alloc: std.mem.Allocator, custom_term: ?[]const u8) !*Terminal {
    var termtype: []const u8 = undefined;
    if (custom_term == null) {
        termtype = std.os.getenv("TERM") orelse return InitError.NoTermEnvVar;
    } else {
        termtype = custom_term.?;
    }

    const file = try terminfo.getTerminfo(alloc, termtype);
    defer file.close();

    const data = try file.readToEndAlloc(alloc, std.math.maxInt(u32));
    const terminal_info = try terminfo.parseTerminfo(alloc, data);
    alloc.free(data);

    var terminal: *Terminal = try alloc.create(Terminal);
    terminal.tinfo = terminal_info;

    // Check the colors
    terminal.max_colors = terminal.tinfo.numbers[tinfo_fields.num_max_colors];
    terminal.max_color_pairs = terminal.tinfo.numbers[tinfo_fields.num_max_pairs];

    // If they are undefined, assume 8
    if (terminal.max_colors == -1) terminal.max_colors = 8;
    if (terminal.max_color_pairs == -1) terminal.max_color_pairs = 8;

    const ansi_colors = command.checkCapability(terminal.tinfo, tinfo_fields.str_set_a_background);
    if (ansi_colors == .Present) {
        terminal.color_mode = .Ansi;
    } else {
        if (command.checkCapability(terminal.tinfo, tinfo_fields.str_set_background) == .Present) {
            terminal.color_mode = .HpExtended;
        } else {
            terminal.color_mode = .Hp;
        }
    }

    return terminal;
}

fn alloc_screen_buffer(alloc: std.mem.Allocator, screen: *Screen) !void {
    if (screen.buffer_allocated) {
        for (screen.buffer) |row| {
            alloc.free(row);
        }

        alloc.free(screen.buffer);
    }

    screen.buffer = try alloc.alloc([]u32, screen.lines);
    var i: usize = 0;
    while (i < screen.buffer.len - 1) : (i += 1) {
        screen.buffer[i] = try alloc.alloc(u32, screen.columns);

        var j: usize = 0;
        while (j < screen.buffer[i].len) : (j += 1) {
            screen.buffer[i][j] = ' ';
        }
    }

    // We allocate one more space so that we can apply modifiers to the last character of the terminal
    screen.buffer[screen.lines - 1] = try alloc.alloc(u32, screen.columns + 1);
    var j: usize = 0;
    while (j < screen.columns + 1) : (j += 1) {
        screen.buffer[screen.lines - 1][j] = ' ';
    }

    screen.buffer_allocated = true;
}

pub fn setup_screen(alloc: std.mem.Allocator, terminal: *Terminal) !*Screen {
    const terminal_info = terminal.tinfo;

    var screen: *Screen = try alloc.create(Screen);
    screen.term = terminal;
    screen.cursor_x = 0;
    screen.cursor_y = 0;
    screen.current_bg = .Black;
    screen.current_fg = .White;
    screen.saved_x = 0;
    screen.saved_y = 0;

    const lines = std.os.getenv("LINES");
    const cols = std.os.getenv("COLUMNS");

    if (lines != null) {
        screen.lines = try std.fmt.parseInt(u64, lines.?, 10);
        screen.columns = try std.fmt.parseInt(u64, cols.?, 10);
    } else {
        var size = std.mem.zeroes(std.os.system.winsize);

        const status = std.os.linux.ioctl(
            std.io.getStdOut().handle,
            std.os.linux.T.IOCGWINSZ,
            @intFromPtr(&size),
        );

        if (status == 0) {
            screen.lines = size.ws_row;
            screen.columns = size.ws_col;
        } else {
            const tinfo_lines = terminal_info.numbers[tinfo_fields.num_lines];
            if (tinfo_lines < 0) return InitError.NoTermSizeSpecifier;

            screen.lines = @intCast(tinfo_lines);

            const tinfo_cols = terminal_info.numbers[tinfo_fields.num_columns];
            if (tinfo_cols < 0) return InitError.NoTermSizeSpecifier;

            screen.columns = @intCast(tinfo_cols);
        }
    }

    try alloc_screen_buffer(alloc, screen);

    screen.term.automatic_wrap = terminal.tinfo.bools[tinfo_fields.bool_auto_right_margin];

    return screen;
}

/// custom_term: Try to find this term instead of the one in $TERM
pub fn init(alloc: std.mem.Allocator, custom_term: ?[]const u8) !*Screen {
    const terminal = try new_term(alloc, custom_term);
    try prepare_terminal(terminal);

    const screen = try setup_screen(alloc, terminal);

    try command.cursor_home(screen);
    try draw_screen(screen);

    return screen;
}

pub fn reset_terminal(term: *Terminal) !void {
    if (command.checkCapability(term.tinfo, tinfo_fields.str_save_cursor) == .Absent or
        command.checkCapability(term.tinfo, tinfo_fields.str_exit_ca_mode) == .Absent)
    {
        return error.CapabilityUnsupported;
    }

    try std.io.getStdOut().writeAll(term.tinfo.strings[tinfo_fields.str_save_cursor].?);
    try std.io.getStdOut().writeAll(term.tinfo.strings[tinfo_fields.str_exit_ca_mode].?);

    try std.os.tcsetattr(term.tty_file.handle, .FLUSH, term.orig_termios);
}

pub fn free_term(alloc: std.mem.Allocator, term: *Terminal) void {
    alloc.free(term.tinfo.bools);
    alloc.free(term.tinfo.strings);
    alloc.free(term.tinfo.numbers);
    const str_table_size = term.tinfo.names.len + term.tinfo.str_table.len;
    alloc.free(term.tinfo.names.ptr[0..str_table_size]);
    alloc.destroy(term.tinfo);

    alloc.destroy(term);
}

pub fn free_screen(alloc: std.mem.Allocator, screen: *Screen) void {
    for (screen.buffer) |row| {
        alloc.free(row);
    }

    alloc.free(screen.buffer);
}

pub fn reset_colors(screen: *Screen) void {
    command.reset_colors(screen) catch return;
}

pub fn deinit(alloc: std.mem.Allocator, screen: *Screen) void {
    reset_terminal(screen.term) catch return;

    free_term(alloc, screen.term);
    free_screen(alloc, screen);
}
