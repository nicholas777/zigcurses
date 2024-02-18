const common = @import("../common.zig");
const fields = @import("../tinfo-fields.zig");
const command = @import("../command.zig");
const CommandError = command.CommandError;

const curses = @import("../curses.zig");
const std = @import("std");

pub fn set_background(screen: *curses.Screen, bg: u8) CommandError!void {
    const term = screen.term;
    switch (term.color_mode) {
        .Ansi => {
            command.parameterizedCommand(
                term.tinfo.strings[fields.str_set_a_background].?,
                &.{.{ .number = @as(i32, @intCast(@intFromEnum(bg))) }},
            ) catch return error.IOError;
        },
        .HpExtended => {
            command.parameterizedCommand(
                term.tinfo.strings[fields.str_set_background].?,
                &.{.{ .number = @as(i32, @intCast(@intFromEnum(bg))) }},
            ) catch return error.IOError;
        },
        .Hp => {},
    }
}

pub fn set_foreground(screen: *curses.Screen, fg: common.Color) CommandError!void {
    const term = screen.term;
    switch (term.color_mode) {
        .Ansi => {
            command.parameterizedCommand(
                term.tinfo.strings[fields.str_set_a_foreground].?,
                &.{.{ .number = @as(i32, @intCast(@intFromEnum(fg))) }},
            ) catch return error.IOError;
        },
        .HpExtended => {
            command.parameterizedCommand(
                term.tinfo.strings[fields.str_set_foreground].?,
                &.{.{ .number = @as(i32, @intCast(@intFromEnum(fg))) }},
            ) catch return error.IOError;
        },
        .Hp => {},
    }
}

pub fn set_colors(screen: *curses.Screen, bg: common.Color, fg: common.Color) CommandError!void {
    try set_background(screen, bg);
    try set_foreground(screen, fg);
}

pub fn reset_colors(screen: *curses.Screen) CommandError!void {
    const term = screen.term;
    if (command.checkCapability(term.tinfo, fields.str_orig_pair) == .Absent) {
        return error.CapabilityUnsupported;
    }

    std.io.getStdOut().writeAll(term.tinfo.strings[fields.str_orig_pair].?) catch return error.IOError;
}
