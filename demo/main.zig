const std = @import("std");
const curses = @import("curses");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const alloc = gpa.allocator();

    const screen = try curses.init(alloc, null);
    defer curses.deinit(alloc, screen);

    var is_command: bool = false;

    while (true) {
        const char = try curses.input.read_char(screen);

        switch (char) {
            .Colon => {
                if (!is_command) {
                    curses.cmd.color_line(screen, screen.lines - 1, .Magenta, .White);
                    curses.cmd.print_char_at(screen, ':', 0, screen.lines - 1);

                    is_command = true;
                } else {
                    curses.cmd.print_char(screen, @intFromEnum(char));
                }
            },
            .Newline, .Carriage => {
                if (is_command) {
                    const command = try curses.cmd.read_range(screen, alloc, 1, screen.lines - 1, screen.cursor_x - 1);
                    curses.cmd.cursor_home(screen);
                    curses.cmd.clear_line(screen, screen.lines - 1);

                    if (std.mem.eql(u8, command, "q")) break;

                    is_command = false;

                    alloc.free(command);
                } else {
                    curses.cmd.print_char(screen, @intFromEnum(char));
                    curses.cmd.cursor_home(screen);
                }
            },
            .Backspace, .Delete => {
                if (screen.cursor_y == screen.lines - 1) {
                    if (screen.cursor_x != 1) {
                        curses.cmd.cursor_left(screen);
                        curses.cmd.delete_at_cursor(screen);
                    }
                } else {
                    curses.cmd.cursor_left(screen);
                    curses.cmd.delete_at_cursor(screen);
                }
            },
            .ArrowUp => {},
            else => {
                curses.cmd.print_char(screen, @intFromEnum(char));
            },
        }

        try curses.draw_screen(screen);
    }
}
