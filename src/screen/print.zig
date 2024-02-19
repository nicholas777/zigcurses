const curses = @import("../curses.zig");

fn printchar(screen: *curses.Screen, char: u8) void {
    screen.buffer[screen.cursor_y][screen.cursor_x] &= 0xFF00;
    screen.buffer[screen.cursor_y][screen.cursor_x] |= char;

    screen.cursor_x += 1;
    if (screen.cursor_x >= screen.columns) {
        screen.cursor_x = 0;
        screen.cursor_y += 1;
        if (screen.cursor_y >= screen.lines) {
            screen.cursor_y = 0;
        }
    }
}

pub fn print(screen: *curses.Screen, msg: []const u8) void {
    for (msg) |char| {
        printchar(screen, char);
    }
}

const cmd = @import("../screen_command.zig");

pub fn print_at(screen: *curses.Screen, msg: []const u8, x: u32, y: u32) void {
    cmd.move_cursor(screen, x, y);
    print(screen, msg);
}
