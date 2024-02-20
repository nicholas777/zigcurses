const curses = @import("../curses.zig");

pub fn print_char(screen: *curses.Screen, char: u8) void {
    screen.buffer[screen.cursor_y][screen.cursor_x] &= 0xFF00;
    screen.buffer[screen.cursor_y][screen.cursor_x] |= char;

    if (char == '\n') {
        screen.cursor_x = 0;
        screen.cursor_y += 1;
        if (screen.cursor_y >= screen.lines) {
            screen.cursor_y = screen.lines - 1;
        }
    }

    screen.cursor_x += 1;
    if (screen.cursor_x >= screen.columns) {
        screen.cursor_x = 0;
        screen.cursor_y += 1;
        if (screen.cursor_y >= screen.lines) {
            screen.cursor_y = screen.lines - 1;
        }
    }
}

pub fn print(screen: *curses.Screen, msg: []const u8) void {
    for (msg) |char| {
        print_char(screen, char);
    }
}

const cmd = @import("../screen_command.zig");

pub fn print_at(screen: *curses.Screen, msg: []const u8, x: usize, y: usize) void {
    cmd.move_cursor(screen, x, y);
    print(screen, msg);
}

pub fn toggle_bold(screen: *curses.Screen) void {
    screen.buffer[screen.cursor_y][screen.cursor_x] &= ~cmd.set_bold;
}

pub fn print_bold(screen: *curses.Screen, msg: []const u8) void {
    toggle_bold(screen);
    print(screen, msg);
    toggle_bold(screen);
}

pub fn print_bold_at(screen: *curses.Screen, msg: []const u8, x: usize, y: usize) void {
    toggle_bold(screen);
    print_at(screen, msg, x, y);
    toggle_bold(screen);
}
