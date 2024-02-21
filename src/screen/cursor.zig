const curses = @import("../curses.zig");

pub fn move_cursor(screen: *curses.Screen, x: usize, y: usize) void {
    if (y + 1 > screen.lines or x + 1 > screen.columns) return;

    screen.cursor_x = x;
    screen.cursor_y = y;
}

pub fn cursor_home(screen: *curses.Screen) void {
    screen.cursor_x = 0;
    screen.cursor_y = 0;
}

pub fn cursor_up(screen: *curses.Screen) void {
    if (screen.cursor_y != 0) screen.cursor_y -= 1;
}

pub fn cursor_down(screen: *curses.Screen) void {
    if (screen.cursor_y != screen.lines - 1) screen.cursor_y += 1;
}

pub fn cursor_left(screen: *curses.Screen) void {
    if (screen.cursor_x != 0) screen.cursor_x -= 1;
}

pub fn cursor_right(screen: *curses.Screen) void {
    if (screen.cursor_x != screen.columns - 1) screen.cursor_x += 1;
}

pub fn save_cursor(screen: *curses.Screen) void {
    screen.saved_x = screen.cursor_x;
    screen.saved_y = screen.cursor_y;
}

pub fn load_cursor(screen: *curses.Screen) void {
    screen.cursor_x = screen.saved_x;
    screen.cursor_y = screen.saved_y;
}
