const std = @import("std");
const common = @import("common.zig");
const terminfo = @import("terminfo.zig");

pub const CommandError = error{
    CapabilityUnsupported,
    IOError,
};

pub const CommandPresence = enum { Present, Absent };

pub fn checkCapability(term: *terminfo.TerminalInfo, index: usize) CommandPresence {
    if (term.strings[index] == null) return .Absent;
    return .Present;
}

pub const Parameter = union(enum) {
    number: i32,
    unsigned: u32,
    char: u8,
    string: []const u8,
};

pub const ParameterError = error{
    InvalidParameters,
    TooFewParameters,
    InvalidFormat,
};

pub fn paramererizedCommand(command: []const u8, params: []const Parameter) !void {
    var buffered = std.io.bufferedWriter(std.io.getStdOut().writer());
    const bw = buffered.writer();

    var curr_index: u32 = 0;

    var i_flag: bool = false;

    var i: u32 = 0;
    while (i < command.len) : (i += 1) {
        const char = command[i];

        if (char == '%') {
            i += 1;

            if (command[i] == '%') {
                try bw.writeByte('%');
                continue;
            }

            switch (command[i]) {
                'c' => {
                    const field: u8 = params[curr_index].char;
                    try bw.writeByte(if (i_flag and curr_index < 2) field + 1 else field);
                },
                's' => {
                    const field: []const u8 = params[curr_index].string;
                    try bw.writeAll(field);
                },
                'd' => {
                    const field: i32 = params[curr_index].number;

                    var buf: [12]u8 = undefined;
                    try bw.writeAll(try std.fmt.bufPrint(&buf, "{d}", .{field}));
                },
                'p' => {
                    i += 1;
                    curr_index = command[i] - '1';
                    if (params.len < curr_index + 1)
                        return ParameterError.TooFewParameters;
                },
                'P' => {},
                'g' => {},
                'G' => {},
                'i' => {
                    i_flag = true;
                },
                '?' => {
                    i += 1;
                    const expr_end = std.mem.indexOfPos(u8, command, i, "%t") orelse return ParameterError.InvalidFormat;
                    _ = expr_end;
                },
                else => {
                    return ParameterError.InvalidFormat;
                },
            }
        } else {
            try bw.writeByte(char);
        }
    }

    try buffered.flush();
}

const clearscr = @import("commands/clear.zig");
pub const clear_screen = clearscr.clear;
pub const clear_down = clearscr.clear_down;
pub const clear_right = clearscr.clear_right;

const printcmd = @import("commands/print.zig");
pub const print = printcmd.print;
pub const print_bold = printcmd.print_bold;

const curscmd = @import("commands/cursor.zig");
pub const hide_cursor = curscmd.hide_cursor;
pub const show_cursor = curscmd.show_cursor;

pub const move_cursor = curscmd.move_cursor;
pub const cursor_home = curscmd.cursor_home;

pub const cursor_left = curscmd.cursor_left;
pub const cursor_right = curscmd.cursor_right;
pub const cursor_up = curscmd.cursor_up;
pub const cursor_down = curscmd.cursor_down;

const textcmd = @import("commands/text.zig");
pub const start_bold = textcmd.start_bold;
pub const end_bold = textcmd.end_bold;
