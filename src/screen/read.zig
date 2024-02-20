const curses = @import("../curses.zig");
const std = @import("std");

pub const ReadError = error{
    OutOfBounds,
    OutOfMemory,
};

pub fn read_char(screen: *curses.Screen, x: usize, y: usize) ReadError!u8 {
    if (x + 1 > screen.columns or y + 1 > screen.lines) return ReadError.OutOfBounds;
    return @intCast(screen.buffer[x][y] & 0xff);
}

pub fn read_line(screen: *curses.Screen, alloc: std.mem.Allocator, line: usize) ReadError![]u8 {
    if (line + 1 > screen.liens) return ReadError.OutOfBounds;
    var buf = alloc.alloc(u8, screen.columns) catch return ReadError.OutOfMemory;

    for (buf, 0..) |e, i| {
        _ = e;
        buf[i] = @intCast(screen.buffer[line][i] & 0xff);
    }

    return buf;
}

pub fn read_range(
    screen: *curses.Screen,
    alloc: std.mem.Allocator,
    x: usize,
    y: usize,
    width: usize,
) ReadError![]u8 {
    if (x + width > screen.columns or y + 1 > screen.lines) return ReadError.OutOfBounds;

    var buf = alloc.alloc(u8, width) catch return ReadError.OutOfMemory;
    std.debug.print("X: {}, Y: {}, Width: {}\n", .{ x, y, width });

    for (buf, x..) |e, i| {
        _ = e;
        buf[i - x] = @intCast(screen.buffer[y][i] & 0xff);
    }

    return buf;
}
