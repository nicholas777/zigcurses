const std = @import("std");
const curses = @import("curses");
const fields = curses.tinfo_fields;

fn dump_terminal(info: *curses.TerminalInfo) !void {
    const stdout = std.io.getStdOut().writer();

    for (info.bools, 0..) |value, i| {
        try stdout.print("BOOL - {s}: {}\n", .{ fields.bool_names_long[i], value });
    }

    for (info.numbers, 0..) |value, i| {
        if (value != -1)
            try stdout.print("NUMBER - {s}: {}\n", .{ fields.num_names_long[i], value });
    }

    for (info.strings, 0..) |value, i| {
        if (value != null) {
            try stdout.print(
                "STRING - {s}: {s}{s}\n",
                .{ fields.str_names_long[i], if (value.?[0] == 0x1b) "\\e" else value.?[0..1], value.?[1..] },
            );
        }
    }
}

fn dump_terminal_verbose(info: *curses.TerminalInfo) !void {
    const stdout = std.io.getStdOut().writer();

    for (info.bools, 0..) |value, i| {
        try stdout.print("BOOL - {s}: {}\n", .{ fields.bool_names_long[i], value });
    }

    for (info.numbers, 0..) |value, i| {
        try stdout.print("NUMBER - {s}: {}\n", .{ fields.num_names_long[i], value });
    }

    for (info.strings, 0..) |value, i| {
        if (value == null) {
            try stdout.print("STRING - {s}: null", .{fields.str_names_long[i]});
        } else {
            try stdout.print(
                "STRING - {s}: {s}{s}\n",
                .{ fields.str_names_long[i], if (value.?[0] == 0x1b) "\\e" else value.?[0..1], value.?[1..] },
            );
        }
    }
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const alloc = gpa.allocator();

    var v_flag: bool = false;

    var q_flag: bool = false;
    var query: ?[]const u8 = null;

    var expect_arg: bool = false;
    var prev_flag: u8 = 0;

    var terminal: ?[]const u8 = null;

    var args = std.process.args();
    _ = args.skip();

    var arg: ?[]const u8 = args.next();
    while (arg != null) : (arg = args.next()) {
        if (std.mem.eql(u8, arg.?, "--help")) {
            try printUsage();
            return;
        } else if (std.mem.eql(u8, arg.?, "--version")) {
            try printVersion();
            return;
        } else if (std.mem.eql(u8, arg.?, "-v")) {
            v_flag = true;
        } else if (std.mem.eql(u8, arg.?, "-q")) {
            q_flag = true;
            expect_arg = true;
            prev_flag = 'q';
            continue;
        } else if (std.mem.startsWith(u8, arg.?, "-")) {
            std.io.getStdOut().writer().print("Unknown option \"{s}\"\n", .{arg.?}) catch return;
            return;
        } else {
            if (expect_arg) {
                if (prev_flag == 'q') {
                    query = arg;
                }
            } else {
                terminal = arg;
            }
        }

        prev_flag = 0;
        expect_arg = false;
    }

    const term = try curses.new_term(alloc, terminal);

    const name_pipe = std.mem.indexOf(u8, term.tinfo.names, "|");

    var term_name: []const u8 = undefined;
    if (name_pipe) |pos| {
        term_name = term.tinfo.names[0..pos];
    } else {
        term_name = term.tinfo.names;
    }

    if (q_flag) {
        if (query == null) {
            printUsage() catch return;
            return;
        }

        const fieldtype = curses.util.getFieldType(query.?);
        if (fieldtype == null) {
            std.io.getStdOut().writer().print("Unknown field \"{s}\"\n", .{query.?}) catch return;
            return;
        }

        try std.io.getStdOut().writer().print("Terminal: {s}\n", .{term_name});

        switch (fieldtype.?) {
            .Bool, .BoolLong => {
                try std.io.getStdOut().writer().print("{s}: {?}\n", .{
                    query.?,
                    curses.util.getFieldBool(term.tinfo, query.?, fieldtype.? == .BoolLong),
                });
            },
            .Number, .NumberLong => {
                try std.io.getStdOut().writer().print("{s}: {?}\n", .{
                    query.?,
                    curses.util.getFieldNumber(term.tinfo, query.?, fieldtype.? == .NumberLong),
                });
            },
            .String, .StringLong => {
                const str = curses.util.getFieldString(
                    term.tinfo,
                    query.?,
                    fieldtype.? == .StringLong,
                ) orelse "Null";

                var is_escape_seq: bool = false;

                if (str[0] == 0o33) is_escape_seq = true;
                try std.io.getStdOut().writer().print("{s}: {s}{s}\n", .{
                    query.?,
                    if (is_escape_seq) "\\e" else str[0..1],
                    str[1..],
                });
            },
        }
    } else if (v_flag) {
        try std.io.getStdOut().writer().print("Terminal: {s}\n", .{term_name});
        try dump_terminal_verbose(term.tinfo);
    } else {
        try std.io.getStdOut().writer().print("Terminal: {s}\n", .{term_name});
        try dump_terminal(term.tinfo);
    }

    curses.free_term(alloc, term);
}

const usage =
    \\Usage: dump-tinfo [options] <terminal-name>
    \\Terminal-name is optional and if it is not specified it will default to the current terminal.
    \\Options:
    \\    --help: Shows this message
    \\    --version: Shows the verison of this program and zigcurses library
    \\
    \\    -v: Verbose, shows all fields
    \\
;

fn printUsage() !void {
    _ = try std.io.getStdOut().write(usage);
}

const config = @import("config");

fn printVersion() !void {
    try std.io.getStdOut().writer().print("version: {s}\n", .{config.version});
}
