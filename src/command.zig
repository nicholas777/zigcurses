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

const StackElement = struct {
    is_literal: bool,
    value: usize,
};

pub fn parameterizedCommand(command: []const u8, params: []const Parameter) !void {
    var buffered = std.io.bufferedWriter(std.io.getStdOut().writer());
    const bw = buffered.writer();

    var stack: [20]StackElement = .{.{ .value = 0, .is_literal = false }} ** 20;
    var top: u8 = 0;

    var i_flag: bool = false;
    var if_end: usize = 0;

    var i: usize = 0;
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
                    const index = stack[top - 1].value;
                    top -= 1;

                    var value: u8 = undefined;
                    if (stack[top - 1].is_literal) {
                        value = @intCast(index);
                    } else {
                        value = if (i_flag and stack[top].value < 2) params[index].char + 1 else params[index].char;
                    }

                    try bw.writeByte(value);
                },
                's' => {
                    const index = stack[top - 1].value;
                    top -= 1;

                    try bw.writeAll(params[index].string);
                },
                'd' => {
                    const index = stack[top - 1].value;
                    top -= 1;

                    var value: i32 = undefined;
                    if (stack[top].is_literal) {
                        value = @intCast(index);
                    } else {
                        value = if (i_flag and index < 2) params[index].number + 1 else params[index].number;
                    }

                    var buf: [12]u8 = undefined;
                    try bw.writeAll(try std.fmt.bufPrint(&buf, "{d}", .{value}));
                },
                'p' => {
                    i += 1;
                    stack[top] = .{ .is_literal = false, .value = command[i] - '1' };
                    top += 1;

                    if (params.len < stack[top - 1].value + 1)
                        return ParameterError.TooFewParameters;
                },
                'P' => {},
                'g' => {},
                'G' => {},
                'i' => {
                    i_flag = true;
                },
                '?' => {
                    if_end = std.mem.indexOfPos(u8, command, i + 1, "%;") orelse unreachable; // return error.InvalidFormat;
                },
                't' => {
                    var field: i32 = undefined;
                    if (stack[top - 1].is_literal) {
                        field = @intCast(stack[top - 1].value);
                    } else {
                        field = params[stack[top - 1].value].number;
                    }
                    top -= 1;

                    if (field == 0) {
                        const else_stmt = std.mem.indexOfPos(u8, command, i, "%e");
                        if (else_stmt == null) {
                            i = if_end + 1;
                        } else {
                            i = if (else_stmt.? > if_end) if_end + 1 else else_stmt.? + 1;
                        }
                    }
                },
                'e' => {
                    i = if_end + 1;
                },
                ';' => {},
                '|' => {
                    var field1: i32 = undefined;
                    if (stack[top - 1].is_literal) {
                        field1 = @intCast(stack[top - 1].value);
                    } else {
                        field1 = params[stack[top - 1].value].number;
                    }

                    var field2: i32 = undefined;
                    if (stack[top - 2].is_literal) {
                        field2 = @intCast(stack[top - 2].value);
                    } else {
                        field2 = params[stack[top - 2].value].number;
                    }

                    top -= 2;

                    stack[top] = .{ .is_literal = true, .value = @intCast(field1 | field2) };
                    top += 1;
                },
                '&' => {
                    var field1: i32 = undefined;
                    if (stack[top - 1].is_literal) {
                        field1 = @intCast(stack[top - 1].value);
                    } else {
                        field1 = params[stack[top - 1].value].number;
                    }

                    var field2: i32 = undefined;
                    if (stack[top - 2].is_literal) {
                        field2 = @intCast(stack[top - 2].value);
                    } else {
                        field2 = params[stack[top - 2].value].number;
                    }

                    top -= 2;

                    stack[top] = .{ .is_literal = true, .value = @intCast(field1 & field2) };
                    top += 1;
                },
                '+' => {
                    var field1: i32 = undefined;
                    if (stack[top - 1].is_literal) {
                        field1 = @intCast(stack[top - 1].value);
                    } else {
                        field1 = params[stack[top - 1].value].number;
                    }

                    var field2: i32 = undefined;
                    if (stack[top - 2].is_literal) {
                        field2 = @intCast(stack[top - 2].value);
                    } else {
                        field2 = params[stack[top - 2].value].number;
                    }

                    top -= 2;

                    stack[top] = .{ .is_literal = true, .value = @intCast(field1 + field2) };
                    top += 1;
                },
                '-' => {
                    var field1: i32 = undefined;
                    if (stack[top - 1].is_literal) {
                        field1 = @intCast(stack[top - 1].value);
                    } else {
                        field1 = params[stack[top - 1].value].number;
                    }

                    var field2: i32 = undefined;
                    if (stack[top - 2].is_literal) {
                        field2 = @intCast(stack[top - 2].value);
                    } else {
                        field2 = params[stack[top - 2].value].number;
                    }

                    top -= 2;

                    stack[top] = .{ .is_literal = true, .value = @intCast(field1 - field2) };
                    top += 1;
                },
                '*' => {
                    var field1: i32 = undefined;
                    if (stack[top - 1].is_literal) {
                        field1 = @intCast(stack[top - 1].value);
                    } else {
                        field1 = params[stack[top - 1].value].number;
                    }

                    var field2: i32 = undefined;
                    if (stack[top - 2].is_literal) {
                        field2 = @intCast(stack[top - 2].value);
                    } else {
                        field2 = params[stack[top - 2].value].number;
                    }

                    top -= 2;

                    stack[top] = .{ .is_literal = true, .value = @intCast(field1 * field2) };
                    top += 1;
                },
                '/' => {
                    var field1: i32 = undefined;
                    if (stack[top - 1].is_literal) {
                        field1 = @intCast(stack[top - 1].value);
                    } else {
                        field1 = params[stack[top - 1].value].number;
                    }

                    var field2: i32 = undefined;
                    if (stack[top - 2].is_literal) {
                        field2 = @intCast(stack[top - 2].value);
                    } else {
                        field2 = params[stack[top - 2].value].number;
                    }

                    top -= 2;

                    // Dividing by 0
                    if (field2 == 0) return error.InvalidParameters;
                    stack[top] = .{ .is_literal = true, .value = @intCast(@divFloor(field1, field2)) };
                    top += 1;
                },
                'm' => {
                    var field1: i32 = undefined;
                    if (stack[top - 1].is_literal) {
                        field1 = @intCast(stack[top - 1].value);
                    } else {
                        field1 = params[stack[top - 1].value].number;
                    }

                    var field2: i32 = undefined;
                    if (stack[top - 2].is_literal) {
                        field2 = @intCast(stack[top - 2].value);
                    } else {
                        field2 = params[stack[top - 2].value].number;
                    }

                    top -= 2;

                    if (field2 < 0) return error.InvalidParameters;
                    stack[top] = .{ .is_literal = true, .value = @intCast(@mod(field1, field2)) };
                    top += 1;
                },
                '=' => {
                    var field1: i32 = undefined;
                    if (stack[top - 1].is_literal) {
                        field1 = @intCast(stack[top - 1].value);
                    } else {
                        field1 = params[stack[top - 1].value].number;
                    }

                    var field2: i32 = undefined;
                    if (stack[top - 2].is_literal) {
                        field2 = @intCast(stack[top - 2].value);
                    } else {
                        field2 = params[stack[top - 2].value].number;
                    }

                    top -= 2;

                    stack[top] = .{ .is_literal = true, .value = if (field1 == field2) 1 else 0 };
                    top += 1;
                },
                '<' => {
                    var field1: i32 = undefined;
                    if (stack[top - 1].is_literal) {
                        field1 = @intCast(stack[top - 1].value);
                    } else {
                        field1 = params[stack[top - 1].value].number;
                    }

                    var field2: i32 = undefined;
                    if (stack[top - 2].is_literal) {
                        field2 = @intCast(stack[top - 2].value);
                    } else {
                        field2 = params[stack[top - 2].value].number;
                    }

                    top -= 2;

                    stack[top] = .{ .is_literal = true, .value = if (field1 < field2) 1 else 0 };
                    top += 1;
                },
                '>' => {
                    var field1: i32 = undefined;
                    if (stack[top - 1].is_literal) {
                        field1 = @intCast(stack[top - 1].value);
                    } else {
                        field1 = params[stack[top - 1].value].number;
                    }

                    var field2: i32 = undefined;
                    if (stack[top - 2].is_literal) {
                        field2 = @intCast(stack[top - 2].value);
                    } else {
                        field2 = params[stack[top - 2].value].number;
                    }

                    top -= 2;

                    stack[top] = .{ .is_literal = true, .value = if (field1 > field2) 1 else 0 };
                    top += 1;
                },
                '{' => {
                    const closing_bracket = std.mem.indexOfPos(u8, command, i, "}") orelse return error.InvalidFormat;
                    const literal = std.fmt.parseInt(i32, command[i + 1 .. closing_bracket], 10) catch return error.InvalidFormat;

                    stack[top] = .{ .is_literal = true, .value = @intCast(literal) };
                    top += 1;

                    i += closing_bracket - i;
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
pub const print_blink = printcmd.print_blink;
pub const print_underline = printcmd.print_underline;
pub const print_italic = printcmd.print_italic;

const curscmd = @import("commands/cursor.zig");
pub const hide_cursor = curscmd.hide_cursor;
pub const show_cursor = curscmd.show_cursor;
pub const save_cursor = curscmd.save_cursor;
pub const load_cursor = curscmd.load_cursor;

pub const move_cursor = curscmd.move_cursor;
pub const cursor_home = curscmd.cursor_home;

pub const cursor_left = curscmd.cursor_left;
pub const cursor_right = curscmd.cursor_right;
pub const cursor_up = curscmd.cursor_up;
pub const cursor_down = curscmd.cursor_down;

const textcmd = @import("commands/text.zig");
pub const start_bold = textcmd.start_bold;
pub const end_bold = textcmd.end_bold;

pub const start_blink = textcmd.start_blink;
pub const end_blink = textcmd.end_blink;

pub const start_underline = textcmd.start_underline;
pub const end_underline = textcmd.end_underline;

pub const start_italic = textcmd.start_italic;
pub const end_italic = textcmd.end_italic;

const colorcmd = @import("commands/colors.zig");
pub const set_background = colorcmd.set_background;
pub const set_foreground = colorcmd.set_foreground;
pub const set_colors = colorcmd.set_colors;

pub const reset_colors = colorcmd.reset_colors;
