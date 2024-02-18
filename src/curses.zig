const std = @import("std");
const terminfo = @import("terminfo.zig");
const common = @import("common.zig");

pub const AnsiColor = common.AnsiColor;
pub const HpColor = common.HpColor;
pub const Color = common.Color;

pub const util = @import("utils.zig");
pub const tinfo_fields = @import("tinfo-fields.zig");

const command = @import("command.zig");

const draw = @import("draw_screen.zig");
pub const draw_screen = draw.draw_screen;

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
};

pub const Screen = struct {
    columns: usize,
    lines: usize,
    term: *Terminal,
    buffer: [][]u8 = undefined,
    cursor_x: u32,
    cursor_y: u32,
    text_attribs: [9]u8 = .{0} ** 9,
};

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

pub fn setup_screen(alloc: std.mem.Allocator, terminal: *Terminal) !*Screen {
    const terminal_info = terminal.tinfo;

    var screen: *Screen = try alloc.create(Screen);
    screen.term = terminal;
    screen.cursor_x = 0;
    screen.cursor_y = 0;

    const lines = std.os.getenv("LINES");
    if (lines) |value| {
        screen.lines = try std.fmt.parseInt(u64, value, 10);
    } else {
        const tinfo_lines = terminal_info.numbers[tinfo_fields.num_lines];
        if (tinfo_lines < 0) return InitError.NoTermSizeSpecifier;

        screen.lines = @intCast(tinfo_lines);
    }

    const cols = std.os.getenv("COLUMNS");
    if (cols) |value| {
        screen.columns = try std.fmt.parseInt(u64, value, 10);
    } else {
        const tinfo_cols = terminal_info.numbers[tinfo_fields.num_columns];
        if (tinfo_cols < 0) return InitError.NoTermSizeSpecifier;

        screen.columns = @intCast(tinfo_cols);
    }

    screen.buffer = try alloc.alloc([]u8, screen.lines);
    var i: usize = 0;
    while (i < screen.buffer.len) : (i += 1) {
        screen.buffer[i] = try alloc.alloc(u8, screen.columns);
        @memset(screen.buffer[i], ' ');
    }

    screen.term.automatic_wrap = terminal.tinfo.bools[tinfo_fields.bool_auto_right_margin];

    return screen;
}

/// custom_term: Try to find this term instead of the one in $TERM
pub fn init(alloc: std.mem.Allocator, custom_term: ?[]const u8) !*Screen {
    const terminal = try new_term(alloc, custom_term);
    const screen = try setup_screen(alloc, terminal);

    try draw_screen(screen);

    return screen;
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

pub fn deinit(alloc: std.mem.Allocator, screen: *Screen) void {
    command.clear_screen(screen) catch |err| switch (err) {
        error.CapabilityUnsupported => {
            command.cursor_home(screen) catch {};
            command.clear_down(screen) catch {};
        },
        else => {},
    };

    free_term(alloc, screen.term);
    free_screen(alloc, screen);
}
