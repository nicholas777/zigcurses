const command = @import("command.zig");
const curses = @import("curses.zig");
const cmd = curses.cmd;

const std = @import("std");

pub fn draw_screen(screen: *curses.Screen) !void {
    const orig_x = screen.cursor_x;
    const orig_y = screen.cursor_y;

    var buffered = std.io.bufferedWriter(std.io.getStdOut().writer());
    const bw = buffered.writer();

    try command.cursor_home(screen);

    for (screen.buffer) |row| {
        for (row) |char| {
            if (char & 0xFF00 != 0) {
                try buffered.flush();

                if (char & cmd.set_color != 0) {
                    try command.set_colors(screen, @enumFromInt((char >> 8) & 0x7), @enumFromInt((char >> 11) & 0x7));
                }
            }

            try bw.writeByte(@intCast(char & 0xFF));
        }
    }

    try buffered.flush();

    try command.move_cursor(screen, @intCast(orig_x), @intCast(orig_y));
}
