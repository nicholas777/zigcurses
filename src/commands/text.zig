const command = @import("../command.zig");
const fields = @import("../tinfo-fields.zig");
const CommandError = command.CommandError;

const curses = @import("../curses.zig");
const std = @import("std");

pub const bold_text = 5;
pub const blink_text = 3;
pub const underline_text = 1;

pub fn start_bold(term: *curses.Terminal) CommandError!void {
    if (command.checkCapability(term.tinfo, fields.str_enter_bold_mode) == .Absent)
        return CommandError.CapabilityUnsupported;

    if (command.checkCapability(term.tinfo, fields.str_set_attributes) == .Absent)
        return CommandError.CapabilityUnsupported;

    term.text_attribs[bold_text] = 1;

    var text_attribs: [9]command.Parameter = .{.{ .number = 0 }} ** 9;
    for (term.text_attribs, 0..) |attrib, i| {
        text_attribs[i].number = attrib;
    }

    command.paramererizedCommand(
        term.tinfo.strings[fields.str_set_attributes].?,
        &text_attribs,
    ) catch return error.IOError;
}

pub fn end_bold(term: *curses.Terminal) CommandError!void {
    if (command.checkCapability(term.tinfo, fields.str_enter_bold_mode) == .Absent)
        return CommandError.CapabilityUnsupported;

    term.text_attribs[bold_text] = 0;

    var text_attribs: [9]command.Parameter = .{.{ .number = 0 }} ** 9;
    for (term.text_attribs, 0..) |attrib, i| {
        text_attribs[i].number = attrib;
    }

    command.paramererizedCommand(
        term.tinfo.strings[fields.str_set_attributes].?,
        &text_attribs,
    ) catch return error.IOError;
}

pub fn start_blink(term: *curses.Terminal) CommandError!void {
    if (command.checkCapability(term.tinfo, fields.str_enter_blink_mode) == .Absent)
        return CommandError.CapabilityUnsupported;

    if (command.checkCapability(term.tinfo, fields.str_set_attributes) == .Absent)
        return CommandError.CapabilityUnsupported;

    term.text_attribs[blink_text] = 1;

    var text_attribs: [9]command.Parameter = .{.{ .number = 0 }} ** 9;
    for (term.text_attribs, 0..) |attrib, i| {
        text_attribs[i].number = attrib;
    }

    command.paramererizedCommand(
        term.tinfo.strings[fields.str_set_attributes].?,
        &text_attribs,
    ) catch return error.IOError;
}

pub fn end_blink(term: *curses.Terminal) CommandError!void {
    if (command.checkCapability(term.tinfo, fields.str_enter_blink_mode) == .Absent)
        return CommandError.CapabilityUnsupported;

    term.text_attribs[blink_text] = 0;

    var text_attribs: [9]command.Parameter = .{.{ .number = 0 }} ** 9;
    for (term.text_attribs, 0..) |attrib, i| {
        text_attribs[i].number = attrib;
    }

    command.paramererizedCommand(
        term.tinfo.strings[fields.str_set_attributes].?,
        &text_attribs,
    ) catch return error.IOError;
}

pub fn start_underline(term: *curses.Terminal) CommandError!void {
    if (command.checkCapability(term.tinfo, fields.str_enter_underline_mode) == .Absent)
        return CommandError.CapabilityUnsupported;

    if (command.checkCapability(term.tinfo, fields.str_set_attributes) == .Absent)
        return CommandError.CapabilityUnsupported;

    term.text_attribs[underline_text] = 1;

    var text_attribs: [9]command.Parameter = .{.{ .number = 0 }} ** 9;
    for (term.text_attribs, 0..) |attrib, i| {
        text_attribs[i].number = attrib;
    }

    command.paramererizedCommand(
        term.tinfo.strings[fields.str_set_attributes].?,
        &text_attribs,
    ) catch return error.IOError;
}

pub fn end_underline(term: *curses.Terminal) CommandError!void {
    if (command.checkCapability(term.tinfo, fields.str_enter_underline_mode) == .Absent)
        return CommandError.CapabilityUnsupported;

    term.text_attribs[underline_text] = 0;

    var text_attribs: [9]command.Parameter = .{.{ .number = 0 }} ** 9;
    for (term.text_attribs, 0..) |attrib, i| {
        text_attribs[i].number = attrib;
    }

    command.paramererizedCommand(
        term.tinfo.strings[fields.str_set_attributes].?,
        &text_attribs,
    ) catch return error.IOError;
}

pub fn start_italic(term: *curses.Terminal) CommandError!void {
    if (command.checkCapability(term.tinfo, fields.str_enter_italics_mode) == .Absent)
        return CommandError.CapabilityUnsupported;

    _ = std.io.getStdOut().write(term.tinfo.strings[fields.str_enter_italics_mode].?) catch return error.IOError;
}

pub fn end_italic(term: *curses.Terminal) CommandError!void {
    if (command.checkCapability(term.tinfo, fields.str_exit_italics_mode) == .Absent)
        return CommandError.CapabilityUnsupported;

    _ = std.io.getStdOut().write(term.tinfo.strings[fields.str_exit_italics_mode].?) catch return error.IOError;
}
