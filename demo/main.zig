const std = @import("std");
const curses = @import("curses");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const alloc = gpa.allocator();

    const screen = try curses.init(alloc, null);
    defer curses.deinit(alloc, screen);

    var is_command: bool = false;
    var orig_x: usize = 0;
    var orig_y: usize = 0;

    var rerender: bool = true;

    while (true) {
        const char = try curses.input.read_char(screen);

        switch (char) {
            .Colon => {
                if (!is_command) {
                    orig_x = screen.cursor_x;
                    orig_y = screen.cursor_y;

                    curses.cmd.color_line(screen, screen.lines - 1, .Magenta, .White);
                    curses.cmd.print_char_at(screen, ':', 0, screen.lines - 1);

                    is_command = true;
                } else {
                    curses.cmd.print_char(screen, @intFromEnum(char));
                }

                rerender = true;
            },
            .Newline, .Carriage => {
                if (is_command) {
                    const command = try curses.cmd.read_range(screen, alloc, 1, screen.lines - 1, screen.cursor_x - 1);
                    curses.cmd.cursor_home(screen);
                    curses.cmd.clear_line(screen, screen.lines - 1);

                    if (std.mem.eql(u8, command, "q")) break;

                    alloc.free(command);

                    is_command = false;
                    curses.cmd.move_cursor(screen, orig_x, orig_y);
                } else {
                    curses.cmd.new_line(screen);
                }

                rerender = true;
            },
            .Backspace, .Delete => {
                if (screen.cursor_x == 0 and screen.cursor_y != 0) {
                    curses.cmd.move_cursor(screen, screen.columns - 1, screen.cursor_y - 1);
                    curses.cmd.delete_at_cursor(screen);
                } else if (screen.cursor_y == screen.lines - 1) {
                    if (screen.cursor_x != 1) {
                        curses.cmd.cursor_left(screen);
                        curses.cmd.delete_at_cursor(screen);
                    }
                } else {
                    curses.cmd.cursor_left(screen);
                    curses.cmd.delete_at_cursor(screen);
                }

                rerender = true;
            },
            .ArrowUp => {
                if (!is_command) curses.cmd.cursor_up(screen);
            },
            .ArrowDown => {
                if (!is_command) curses.cmd.cursor_down(screen);
            },
            .ArrowLeft => {
                if (!is_command) curses.cmd.cursor_left(screen);
            },
            .ArrowRight => {
                if (!is_command) curses.cmd.cursor_right(screen);
            },
            else => {
                rerender = true;
                curses.cmd.print_char(screen, @intFromEnum(char));
            },
        }

        if (rerender) {
            try curses.draw_screen(screen);
        } else {
            curses.update_cursor(screen);
        }

        rerender = false;
    }
}
