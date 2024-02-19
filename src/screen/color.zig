const cmd = @import("../screen_command.zig");
const curses = @import("../curses.zig");

pub fn set_background(screen: *curses.Screen, color: curses.Color) void {
    screen.buffer[screen.cursor_y][screen.cursor_x] &= 0xb8ff;
    screen.buffer[screen.cursor_y][screen.cursor_x] |= cmd.set_color;
    screen.buffer[screen.cursor_y][screen.cursor_x] |= @as(u16, @intCast(@intFromEnum(color))) << 8;
    screen.current_bg = color;
}

pub fn set_foreground(screen: *curses.Screen, color: curses.Color) void {
    screen.buffer[screen.cursor_y][screen.cursor_x] &= 0x87ff;
    screen.buffer[screen.cursor_y][screen.cursor_x] |= cmd.set_color;
    screen.buffer[screen.cursor_y][screen.cursor_x] |= @as(u16, @intCast(@intFromEnum(color))) << 11;
    screen.current_fg = color;
}

pub fn set_colors(screen: *curses.Screen, bg: curses.Color, fg: curses.Color) void {
    set_background(screen, bg);
    set_foreground(screen, fg);
}

const std = @import("std");

pub fn color_range(screen: *curses.Screen, length: usize, bg: curses.Color, fg: curses.Color) void {
    const old_x = screen.cursor_x;
    const old_y = screen.cursor_y;

    const old_bg = screen.current_bg;
    const old_fg = screen.current_fg;

    set_colors(screen, bg, fg);

    const left_on_line = screen.columns - screen.cursor_x;
    if (left_on_line > length) {
        screen.cursor_x += length;
    } else if (left_on_line == length) {
        if (screen.cursor_y + 1 >= screen.lines) {
            screen.cursor_x += length;
            std.debug.print("Hello 1, x: {}\n", .{screen.cursor_x});
        } else {
            screen.cursor_x = 0;
            screen.cursor_y += 1;
            std.debug.print("Hello 2\n", .{});
        }
    } else {
        screen.cursor_y += length / screen.columns + 1;
        screen.cursor_x = length - left_on_line;
    }

    std.debug.print("X: {}, y: {}\n", .{ screen.cursor_x, screen.cursor_y });
    set_colors(screen, old_bg, old_fg);
    cmd.move_cursor(screen, old_x, old_y);
}

pub fn color_area(
    screen: *curses.Screen,
    x: usize,
    y: usize,
    width: usize,
    height: usize,
    bg: curses.Color,
    fg: curses.Color,
) void {
    if (x + width > screen.columns) return;
    if (y + height > screen.lines) return;

    const orig_x = screen.cursor_x;
    const orig_y = screen.cursor_y;

    var i: usize = y;
    while (i < y + height) : (i += 1) {
        screen.cursor_y = i;
        screen.cursor_x = x;

        color_range(screen, width, bg, fg);
    }

    screen.cursor_x = orig_x;
    screen.cursor_y = orig_y;
}

pub fn color_line(
    screen: *curses.Screen,
    line: usize,
    bg: curses.Color,
    fg: curses.Color,
) void {
    color_area(screen, 0, line, screen.columns, 1, bg, fg);
}
