const std = @import("std");
const curses = @import("curses");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const alloc = gpa.allocator();

    const screen = try curses.init(alloc, null);
    defer curses.deinit(alloc, screen);

    var is_command: bool = false;
    _ = is_command;
    var orig_x: usize = 0;
    _ = orig_x;
    var orig_y: usize = 0;
    _ = orig_y;

    var rerender: bool = true;
    _ = rerender;

    while (true) {
        const char = try curses.input.read_char(screen);

        switch (char) {
            .key => |key| {
                handle_key(screen, key);
            },
            .ascii => |c| {
                if (c == 'q') break;

                if (c == @intFromEnum(curses.input.AsciiCode.Backspace) or
                    c == @intFromEnum(curses.input.AsciiCode.Delete))
                {
                    curses.cmd.cursor_left(screen);
                    curses.cmd.delete_at_cursor(screen);
                } else {
                    curses.cmd.print_char(screen, c);
                }
            },
            .utf8 => |codepoint| {
                _ = codepoint;
            },
            .escape => |key| {
                curses.cmd.print(screen, "Escape + ");
                curses.cmd.print_char(screen, key);
            },
            .control => |key| {
                curses.cmd.print(screen, "Ctrl + ");
                curses.cmd.print_char(screen, key);
            },
        }

        try curses.draw_screen(screen);
    }
}

fn handle_key(screen: *curses.Screen, key: curses.input.Keycode) void {
    switch (key) {
        .ArrowUp => {
            curses.cmd.cursor_up(screen);
        },
        .ArrowDown => {
            curses.cmd.cursor_down(screen);
        },
        .ArrowLeft => {
            curses.cmd.cursor_left(screen);
        },
        .ArrowRight => {
            curses.cmd.cursor_right(screen);
        },
    }
}
