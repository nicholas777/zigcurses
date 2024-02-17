const command = @import("../command.zig");
const fields = @import("../tinfo-fields.zig");
const CommandError = command.CommandError;

const curses = @import("../curses.zig");
const std = @import("std");

pub fn start_bold(term: *curses.Terminal) CommandError!void {
    if (command.checkCapability(term.tinfo, fields.str_enter_bold_mode) == .Absent)
        return CommandError.CapabilityUnsupported;

    if (command.checkCapability(term.tinfo, fields.str_set_attributes) == .Absent)
        return CommandError.CapabilityUnsupported;

    command.paramererizedCommand(
        term.tinfo.strings[fields.str_set_attributes].?,
        term.text_attribs,
    );
}

pub fn end_bold(term: *curses.Terminal) CommandError!void {
    if (command.checkCapability(term.tinfo, fields.str_enter_bold_mode) == .Absent)
        return CommandError.CapabilityUnsupported;

    _ = std.io.getStdOut().write(term.tinfo.strings[fields.str_enter_bold_mode].?) catch return CommandError.IOError;
}
