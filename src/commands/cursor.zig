const command = @import("../command.zig");
const fields = @import("../tinfo-fields.zig");
const CommandError = command.CommandError;

const curses = @import("../curses.zig");
const std = @import("std");

pub fn hide_cursor(term: *curses.Terminal) CommandError!void {
    if (command.checkCapability(term.tinfo, fields.str_cursor_invisible) == .Absent)
        return error.CapabilityUnsupported;

    _ = std.io.getStdOut().write(term.tinfo.strings[fields.str_cursor_invisible].?) catch return error.IOError;
}

pub fn show_cursor(term: *curses.Terminal) CommandError!void {
    if (command.checkCapability(term.tinfo, fields.str_cursor_normal) == .Absent)
        return error.CapabilityUnsupported;

    _ = std.io.getStdOut().write(term.tinfo.strings[fields.str_cursor_normal].?) catch return error.IOError;
}

pub fn move_cursor(term: *curses.Terminal, new_x: i32, new_y: i32) CommandError!void {
    if (command.checkCapability(term.tinfo, fields.str_cursor_address) == .Absent)
        return error.CapabilityUnsupported;

    command.paramererizedCommand(
        term.tinfo.strings[fields.str_cursor_address].?,
        &.{ .{ .number = new_x }, .{ .number = new_y } },
    ) catch return error.IOError;

    term.cursor_x = @intCast(new_x);
    term.cursor_y = @intCast(new_y);
}

pub fn cursor_home(term: *curses.Terminal) CommandError!void {
    if (command.checkCapability(term.tinfo, fields.str_cursor_home) == .Absent)
        return error.CapabilityUnsupported;

    _ = std.io.getStdOut().write(term.tinfo.strings[fields.str_cursor_home].?) catch return error.IOError;
    term.cursor_y = 0;
    term.cursor_x = 0;
}

pub fn cursor_up(term: *curses.Terminal) CommandError!void {
    if (command.checkCapability(term.tinfo, fields.str_cursor_up) == .Absent)
        return error.CapabilityUnsupported;

    _ = std.io.getStdOut().write(term.tinfo.strings[fields.str_cursor_up].?) catch return error.IOError;
    term.cursor_y -= 1;
}

// For some reason the cursor_down takes us to the first column on some terminals
pub fn cursor_down(term: *curses.Terminal) CommandError!void {
    try move_cursor(term, @intCast(term.cursor_x), @intCast(term.cursor_y + 1));
}

pub fn cursor_left(term: *curses.Terminal) CommandError!void {
    if (command.checkCapability(term.tinfo, fields.str_cursor_left) == .Absent)
        return error.CapabilityUnsupported;

    _ = std.io.getStdOut().write(term.tinfo.strings[fields.str_cursor_left].?) catch return error.IOError;
    term.cursor_x -= 1;
}

pub fn cursor_right(term: *curses.Terminal) CommandError!void {
    if (command.checkCapability(term.tinfo, fields.str_cursor_right) == .Absent)
        return error.CapabilityUnsupported;

    _ = std.io.getStdOut().write(term.tinfo.strings[fields.str_cursor_right].?) catch return error.IOError;
    term.cursor_x += 1;
}
