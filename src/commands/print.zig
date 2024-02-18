const fields = @import("../tinfo-fields.zig");
const command = @import("../command.zig");
const CommandError = command.CommandError;

const curses = @import("../curses.zig");
const std = @import("std");

pub fn print(screen: *curses.Screen, str: []const u8) CommandError!void {
    const stdio = std.io.getStdOut();
    const written = stdio.writer().write(str) catch return error.IOError;
    if (written != str.len) return error.IOError;

    const columns: u32 = @intCast(screen.columns);
    const left_in_column = columns - screen.cursor_x;
    const rows_to_move = written / columns;
    const delta_x = written % columns;

    if (delta_x <= left_in_column) {
        screen.cursor_x += @intCast(delta_x);
        screen.cursor_y += @intCast(rows_to_move);
    } else {
        screen.cursor_x = @intCast(delta_x - left_in_column);
        screen.cursor_y += @intCast(rows_to_move + 1);
    }
}

const textcmd = @import("text.zig");

pub fn print_bold(screen: *curses.Screen, text: []const u8) CommandError!void {
    try textcmd.start_bold(screen);
    try print(screen, text);
    try textcmd.end_bold(screen);
}

pub fn print_blink(screen: *curses.Screen, text: []const u8) CommandError!void {
    try textcmd.start_blink(screen);
    try print(screen, text);
    try textcmd.end_blink(screen);
}

pub fn print_underline(screen: *curses.Screen, text: []const u8) CommandError!void {
    try textcmd.start_underline(screen);
    try print(screen, text);
    try textcmd.end_underline(screen);
}

pub fn print_italic(screen: *curses.Screen, text: []const u8) CommandError!void {
    try textcmd.start_italic(screen);
    try print(screen, text);
    try textcmd.end_italic(screen);
}
