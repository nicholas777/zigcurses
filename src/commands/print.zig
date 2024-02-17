const fields = @import("../tinfo-fields.zig");
const command = @import("../command.zig");
const CommandError = command.CommandError;

const curses = @import("../curses.zig");
const std = @import("std");

pub fn print(term: *curses.Terminal, str: []const u8) CommandError!void {
    const stdio = std.io.getStdOut();
    const written = stdio.writer().write(str) catch return error.IOError;
    if (written != str.len) return error.IOError;

    const columns: u32 = @intCast(term.tinfo.numbers[fields.num_columns]);
    const left_in_column = columns - term.cursor_x;
    const rows_to_move = written / columns;
    const delta_x = written % columns;

    if (delta_x <= left_in_column) {
        term.cursor_x += @intCast(delta_x);
        term.cursor_y += @intCast(rows_to_move);
    } else {
        term.cursor_x = @intCast(delta_x - left_in_column);
        term.cursor_y += @intCast(rows_to_move + 1);
    }
}

const textcmd = @import("text.zig");

pub fn print_bold(term: *curses.Terminal, text: []const u8) CommandError!void {
    try textcmd.start_bold(term);
    try print(term, text);
    try textcmd.end_bold(term);
}
