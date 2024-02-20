const curses = @import("../curses.zig");

pub fn clear_screen(screen: *curses.Screen) void {
    for (screen.buffer) |row| {
        var i: usize = 0;
        while (i < row.len) : (i += 1) {
            row[i] = ' ';
        }
    }
}

pub fn clear_line(screen: *curses.Screen, line: usize) void {
    if (line + 1 > screen.buffer.len) return;
    var i: usize = 0;
    while (i < screen.buffer[line].len) : (i += 1) {
        screen.buffer[line][i] = ' ';
    }
}

/// Clear from the cursor to the end of the line
pub fn clear_right(screen: *curses.Screen) void {
    if (screen.cursor_y + 1 > screen.buffer.len) return;
    if (screen.cursor_x + 1 > screen.columns) return;

    var i: usize = screen.cursor_x;
    while (i < screen.columns) : (i += 1) {
        screen.buffer[screen.cursor_y][i] = ' ';
    }
}

pub fn clear_left(screen: *curses.Screen) void {
    if (screen.cursor_y + 1 > screen.buffer.len) return;
    if (screen.cursor_x + 1 > screen.columns) return;

    var i: usize = screen.cursor_x;
    while (i != 0) : (i -= 1) {
        screen.buffer[screen.cursor_y][i] = ' ';
    }

    screen.buffer[screen.cursor_y][0] = ' ';
}

pub fn clear_area(screen: *curses.Screen, x: usize, y: usize, width: usize, height: usize) void {
    if (x + width + 1 > screen.columns) return;
    if (y + height + 1 > screen.lines) return;

    var i: usize = y;
    while (i < y + height) : (i += 1) {
        var j: usize = x;
        while (j < x + width) : (j += 1) {
            screen.buffer[i][j] = ' ';
        }
    }
}

pub fn clear_at_cursor(screen: *curses.Screen) void {
    screen.buffer[screen.cursor_y][screen.cursor_x] = ' ';
}

pub fn delete_at_cursor(screen: *curses.Screen) void {
    screen.buffer[screen.cursor_y][screen.cursor_x] &= 0xff00 | ' ';
}
