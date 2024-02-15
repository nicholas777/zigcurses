const std = @import("std");
const terminfo = @import("terminfo.zig");

pub const util = @import("utils.zig");
pub const tinfo_fields = @import("tinfo-fields.zig");

pub const InitError = error{
    NoTermEnvVar,
};

pub const TerminalInfo = terminfo.TerminalInfo;

pub var terminal: ?*TerminalInfo = null;

/// custom_term: Try to find this term instead of the one in $TERM
pub fn init(alloc: std.mem.Allocator, custom_term: ?[]const u8) !*TerminalInfo {
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

    terminal = terminal_info;

    return terminal_info;
}

pub fn deinit(alloc: std.mem.Allocator) void {
    if (terminal == null) return;

    alloc.free(terminal.?.bools);
    alloc.free(terminal.?.strings);
    alloc.free(terminal.?.numbers);
    const str_table_size = terminal.?.names.len + terminal.?.str_table.len;
    alloc.free(terminal.?.names.ptr[0..str_table_size]);
}
