const std = @import("std");

const fields = @import("tinfo-fields.zig");
const terminfo = @import("terminfo.zig");

pub fn getFieldBool(term: *terminfo.TerminalInfo, field: []const u8, long: bool) ?bool {
    var index: ?usize = null;

    if (long) {
        for (fields.bool_names_long, 0..) |name, i| {
            if (std.mem.eql(u8, name, field)) index = i;
        }
    } else {
        for (fields.bool_names, 0..) |name, i| {
            if (std.mem.eql(u8, name, field)) index = i;
        }
    }

    if (index == null) return null;
    return term.bools[index.?];
}

pub fn getFieldNumber(term: *terminfo.TerminalInfo, field: []const u8, long: bool) ?i16 {
    var index: ?usize = null;

    if (long) {
        for (fields.num_names_long, 0..) |name, i| {
            if (std.mem.eql(u8, name, field)) index = i;
        }
    } else {
        for (fields.num_names, 0..) |name, i| {
            if (std.mem.eql(u8, name, field)) index = i;
        }
    }

    if (index == null) return null;
    return term.numbers[index.?];
}

pub fn getFieldString(term: *terminfo.TerminalInfo, field: []const u8, long: bool) ?[]const u8 {
    var index: ?usize = null;

    if (long) {
        for (fields.str_names_long, 0..) |name, i| {
            if (std.mem.eql(u8, name, field)) index = i;
        }
    } else {
        for (fields.str_names, 0..) |name, i| {
            if (std.mem.eql(u8, name, field)) index = i;
        }
    }

    if (index == null) return null;
    return term.strings[index.?];
}

pub const FieldType = enum { Bool, BoolLong, Number, NumberLong, String, StringLong };

pub fn getFieldType(field: []const u8) ?FieldType {
    for (fields.bool_names) |name| {
        if (std.mem.eql(u8, field, name)) return FieldType.Bool;
    }

    for (fields.bool_names_long) |name| {
        if (std.mem.eql(u8, field, name)) return FieldType.BoolLong;
    }

    for (fields.num_names) |name| {
        if (std.mem.eql(u8, field, name)) return FieldType.Number;
    }

    for (fields.num_names_long) |name| {
        if (std.mem.eql(u8, field, name)) return FieldType.NumberLong;
    }

    for (fields.str_names) |name| {
        if (std.mem.eql(u8, field, name)) return FieldType.String;
    }

    for (fields.str_names_long) |name| {
        if (std.mem.eql(u8, field, name)) return FieldType.StringLong;
    }

    return null;
}
