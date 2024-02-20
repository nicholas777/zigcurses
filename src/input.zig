const std = @import("std");
const curses = @import("curses.zig");

pub fn read_char(screen: *curses.Screen) !u8 {
    var buf: [1]u8 = .{0};
    _ = try screen.term.tty_file.read(&buf);
    return buf[0];
}
