const command = @import("../command.zig");
const fields = @import("../tinfo-fields.zig");
const CommandError = command.CommandError;

const curses = @import("../curses.zig");
const std = @import("std");

pub fn hide_cursor(screen: *curses.Screen) CommandError!void {
    const term = screen.term;
    if (command.checkCapability(term.tinfo, fields.str_cursor_invisible) == .Absent)
        return error.CapabilityUnsupported;

    _ = std.io.getStdOut().write(term.tinfo.strings[fields.str_cursor_invisible].?) catch return error.IOError;
}

pub fn show_cursor(screen: *curses.Screen) CommandError!void {
    const term = screen.term;
    if (command.checkCapability(term.tinfo, fields.str_cursor_normal) == .Absent)
        return error.CapabilityUnsupported;

    _ = std.io.getStdOut().write(term.tinfo.strings[fields.str_cursor_normal].?) catch return error.IOError;
}

pub fn save_cursor(screen: *curses.Screen) CommandError!void {
    if (command.checkCapability(screen.term.tinfo, fields.str_save_cursor) == .Absent)
        return error.CapabilityUnsupported;

    _ = std.io.getStdOut().write(screen.term.tinfo.strings[fields.str_save_cursor].?) catch return error.IOError;
}

pub fn load_cursor(screen: *curses.Screen) CommandError!void {
    if (command.checkCapability(screen.term.tinfo, fields.str_restore_cursor) == .Absent)
        return error.CapabilityUnsupported;

    _ = std.io.getStdOut().write(screen.term.tinfo.strings[fields.str_restore_cursor].?) catch return error.IOError;
}

pub fn move_cursor(screen: *curses.Screen, new_x: i32, new_y: i32) CommandError!void {
    const term = screen.term;
    if (command.checkCapability(term.tinfo, fields.str_cursor_address) == .Absent)
        return error.CapabilityUnsupported;

    command.parameterizedCommand(
        term.tinfo.strings[fields.str_cursor_address].?,
        &.{ .{ .number = new_y }, .{ .number = new_x } },
    ) catch return error.IOError;
}

pub fn cursor_home(screen: *curses.Screen) CommandError!void {
    const term = screen.term;
    if (command.checkCapability(term.tinfo, fields.str_cursor_home) == .Absent)
        return error.CapabilityUnsupported;

    _ = std.io.getStdOut().write(term.tinfo.strings[fields.str_cursor_home].?) catch return error.IOError;
}

pub fn cursor_up(screen: *curses.Screen) CommandError!void {
    const term = screen.term;
    if (command.checkCapability(term.tinfo, fields.str_cursor_up) == .Absent)
        return error.CapabilityUnsupported;

    _ = std.io.getStdOut().write(term.tinfo.strings[fields.str_cursor_up].?) catch return error.IOError;
}

// For some reason the cursor_down takes us to the first column on some terminals
pub fn cursor_down(screen: *curses.Screen) CommandError!void {
    const term = screen.term;
    try move_cursor(term, @intCast(term.cursor_x), @intCast(term.cursor_y + 1));
}

pub fn cursor_left(screen: *curses.Screen) CommandError!void {
    const term = screen.term;
    if (command.checkCapability(term.tinfo, fields.str_cursor_left) == .Absent)
        return error.CapabilityUnsupported;

    _ = std.io.getStdOut().write(term.tinfo.strings[fields.str_cursor_left].?) catch return error.IOError;
}

pub fn cursor_right(screen: *curses.Screen) CommandError!void {
    const term = screen.term;
    if (command.checkCapability(term.tinfo, fields.str_cursor_right) == .Absent)
        return error.CapabilityUnsupported;

    _ = std.io.getStdOut().write(term.tinfo.strings[fields.str_cursor_right].?) catch return error.IOError;
}
