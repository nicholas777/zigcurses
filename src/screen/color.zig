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

pub fn color_range(screen: *curses.Screen, length: u32, bg: curses.Color, fg: curses.Color) void {
    const old_x = screen.cursor_x;
    const old_y = screen.cursor_y;

    const old_bg = screen.current_bg;
    const old_fg = screen.current_fg;

    set_colors(screen, bg, fg);

    const left_on_line = screen.columns - screen.cursor_x;
    if (left_on_line >= length) {
        screen.cursor_x += length;
    } else {
        screen.cursor_y += @intCast(length / screen.columns + 1);
        screen.cursor_x = length - @as(u32, @intCast(left_on_line));
    }

    set_colors(screen, old_bg, old_fg);
    cmd.move_cursor(screen, old_x, old_y);
}

pub fn color_area(
    screen: *curses.Screen,
    x: u32,
    y: u32,
    width: u32,
    height: u32,
    bg: curses.Color,
    fg: curses.Color,
) void {
    if (x + width + 1 > screen.columns) return;
    if (y + height + 1 > screen.lines) return;

    const orig_x = screen.cursor_x;
    const orig_y = screen.cursor_y;

    var i: u32 = y;
    while (i < y + height) : (i += 1) {
        screen.cursor_y = i;
        screen.cursor_x = x;

        color_range(screen, width, bg, fg);
    }

    screen.cursor_x = orig_x;
    screen.cursor_y = orig_y;
}
