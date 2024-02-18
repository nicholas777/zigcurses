const command = @import("command.zig");
const curses = @import("curses.zig");

const std = @import("std");

pub fn draw_screen(screen: *curses.Screen) command.CommandError!void {
    const orig_x = screen.cursor_x;
    const orig_y = screen.cursor_y;

    try command.cursor_home(screen);

    for (screen.buffer) |row| {
        try command.print(screen, row);
    }

    try command.move_cursor(screen, @intCast(orig_x), @intCast(orig_y));
}
