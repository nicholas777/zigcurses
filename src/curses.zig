const std = @import("std");
const terminfo = @import("terminfo.zig");

pub const util = @import("utils.zig");
pub const tinfo_fields = @import("tinfo-fields.zig");

pub const command = @import("command.zig");

pub const InitError = error{
    NoTermEnvVar,
};

pub const TerminalInfo = terminfo.TerminalInfo;
pub const Terminal = struct {
    tinfo: *TerminalInfo,
    cursor_x: u32,
    cursor_y: u32,
    text_attribs: [9]u8 = .{0} ** 9,
};

pub var terminal: ?Terminal = null;

/// custom_term: Try to find this term instead of the one in $TERM
pub fn init(alloc: std.mem.Allocator, custom_term: ?[]const u8) !*Terminal {
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

    terminal = Terminal{ .cursor_x = 0, .cursor_y = 0, .tinfo = terminal_info };
    try command.clear_screen(&terminal.?);

    return &terminal.?;
}

pub fn deinit(alloc: std.mem.Allocator) void {
    if (terminal) |term| {
        alloc.free(term.tinfo.bools);
        alloc.free(term.tinfo.strings);
        alloc.free(term.tinfo.numbers);
        const str_table_size = term.tinfo.names.len + term.tinfo.str_table.len;
        alloc.free(term.tinfo.names.ptr[0..str_table_size]);
        alloc.destroy(term.tinfo);
    }
}
