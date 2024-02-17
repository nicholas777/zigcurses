const fields = @import("../tinfo-fields.zig");
const command = @import("../command.zig");
const CommandError = command.CommandError;

const curses = @import("../curses.zig");
const std = @import("std");

pub fn clear(term: *curses.Terminal) CommandError!void {
    if (command.checkCapability(term.tinfo, fields.str_clear_screen) == .Absent) return CommandError.CapabilityUnsupported;
    _ = std.io.getStdOut().write(term.tinfo.strings[fields.str_clear_screen].?) catch return CommandError.IOError;
}

pub fn clear_down(term: *curses.Terminal) CommandError!void {
    if (command.checkCapability(term.tinfo, fields.str_clr_eos) == .Absent)
        return CommandError.CapabilityUnsupported;

    _ = std.io.getStdOut().write(term.tinfo.strings[fields.str_clr_eos].?) catch return CommandError.IOError;
}

pub fn clear_right(term: *curses.Terminal) CommandError!void {
    if (command.checkCapability(term.tinfo, fields.str_clr_eol) == .Absent)
        return CommandError.CapabilityUnsupported;

    _ = std.io.getStdOut().write(term.tinfo.strings[fields.str_clr_eol].?) catch return CommandError.IOError;
}
