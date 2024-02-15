const std = @import("std");
const curses = @import("curses");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    _ = stdout;

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const alloc = gpa.allocator();

    try curses.init(alloc);
    defer curses.deinit(alloc);
}
