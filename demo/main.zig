const std = @import("std");
const curses = @import("curses");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const alloc = gpa.allocator();

    const screen = try curses.init(alloc, null);
    defer curses.deinit(alloc, screen);

    while (true) {
        const char = try curses.input.read_char(screen);

        switch (char) {
            'q' => {
                break;
            },
            else => {
                curses.cmd.print_char(screen, char);
            },
        }

        try curses.draw_screen(screen);
    }
}
