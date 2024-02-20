const std = @import("std");
const common = @import("common.zig");

const tinfo = @import("tinfo-fields.zig");

pub const TerminfoError = error{
    InvalidName,
    InvalidDirectory,
    NoTerminfoFound,
    InvalidTerminfo,
};

pub fn getTerminfo(alloc: std.mem.Allocator, termtype: []const u8) !std.fs.File {
    if (termtype.len == 0) return TerminfoError.InvalidName;

    const terminfo_env = std.os.getenv("TERMINFO");
    if (terminfo_env != null) {
        const file = try searchDirectory(terminfo_env.?, termtype);
        if (file == null) return TerminfoError.InvalidDirectory;
        return file.?;
    } else {
        const home_dir = std.os.getenv("HOME");
        if (home_dir != null) {
            const path = try std.mem.concat(alloc, u8, &.{ home_dir.?, "/.terminfo" });

            const file = try searchDirectory(path, termtype);
            if (file != null) return file.?;
        }

        for (common.terminfo_dirs) |dir| {
            const file = try searchDirectory(dir, termtype);
            if (file != null) return file.?;
        }
    }

    return TerminfoError.NoTerminfoFound;
}

fn searchDirectory(dir: []const u8, termtype: []const u8) !?std.fs.File {
    var handle = std.fs.cwd().openDir(dir, .{}) catch return null;
    defer handle.close();

    var letter_dir = handle.openDir(termtype[0..1], .{}) catch return null;
    defer letter_dir.close();

    return letter_dir.openFile(termtype, .{}) catch |err| switch (err) {
        error.FileNotFound, error.AccessDenied => return null,
        else => return err,
    };
}

pub const Wordsize = enum { Bits32, Bits16 };

pub const TerminalInfo = struct {
    wordsize: Wordsize = undefined,
    str_table: []u8 = undefined,
    names: []u8 = undefined,
    bools: []bool = undefined,
    numbers: []i16 = undefined,
    strings: []?[]const u8 = undefined,
};

pub const TerminfoMagic16 = 0x11a;
pub const TerminfoMagic32 = 0x21e;

pub const NumberAbsent = -1;

pub const TerminfoParseError = error{
    InvalidMagic,
    OutOfMemory,
    InvalidTerminfo,
};

const MaxTerminfoSize = 0x1000;

fn i16FromBytes(slice: []i8) i16 {
    return @as([*]i16, @ptrCast(@alignCast(slice.ptr)))[0];
}

fn i32FromBytes(slice: []i8) i32 {
    return @as([*]i16, @ptrCast(@alignCast(slice.ptr)))[0];
}

// See man pages for terminfo
pub fn parseTerminfo(alloc: std.mem.Allocator, data: []const u8) TerminfoParseError!*TerminalInfo {
    var terminfo: *TerminalInfo = alloc.create(TerminalInfo) catch return error.OutOfMemory;

    // Check for the magic
    // For reference: _nc_read_termtype in libncurses
    if (std.mem.bytesAsValue(u16, data.ptr[0..2]).* == TerminfoMagic16) {
        terminfo.wordsize = .Bits16;
    } else if (std.mem.bytesAsValue(u16, data.ptr[0..2]).* == TerminfoMagic32) {
        terminfo.wordsize = .Bits32;
    } else {
        return TerminfoParseError.InvalidMagic;
    }

    const name_size: u16 = std.mem.bytesAsValue(u16, (data.ptr + 2)[0..2]).*;
    const bool_count: u16 = std.mem.bytesAsValue(u16, (data.ptr + 4)[0..2]).*;
    const num_count: u16 = std.mem.bytesAsValue(u16, (data.ptr + 6)[0..2]).*;
    const str_count: u16 = std.mem.bytesAsValue(u16, (data.ptr + 8)[0..2]).*;
    const str_size: u16 = std.mem.bytesAsValue(u16, (data.ptr + 10)[0..2]).*;
    var offset: u32 = 12;

    terminfo.str_table = alloc.alloc(u8, str_size + name_size + 1) catch return TerminfoParseError.OutOfMemory;

    terminfo.names = terminfo.str_table[0..name_size];
    @memcpy(terminfo.names, data[offset .. offset + name_size]);
    offset += name_size;

    terminfo.str_table = terminfo.str_table[name_size..];

    // Get the bools
    terminfo.bools = alloc.alloc(bool, tinfo.bool_count) catch return error.OutOfMemory;
    @memcpy(std.mem.sliceAsBytes(terminfo.bools)[0..bool_count], data[offset .. offset + bool_count]);
    offset += bool_count;

    // Need to be on an even boundary
    if (offset % 2 == 1) offset += 1;

    const num_size: u32 = if (terminfo.wordsize == .Bits32) 4 else 2;
    terminfo.numbers = alloc.alloc(i16, tinfo.num_count) catch return error.OutOfMemory;
    var num_buf: [4096]i8 = undefined;
    std.mem.copyForwards(i8, &num_buf, @as([]const i8, @ptrCast(data[offset .. offset + num_count * num_size])));

    var i: u32 = 0;
    if (terminfo.wordsize == .Bits16) {
        while (i < num_count) : (i += 1) {
            terminfo.numbers[i] = i16FromBytes(num_buf[i * 2 .. i * 2 + 2]);
        }
    } else {
        var number: i32 = 0;
        while (i < num_count) : (i += 1) {
            number = i32FromBytes(num_buf[i * 2 .. i * 2 + 4]);
            if (number > std.math.maxInt(i16)) {
                terminfo.numbers[i] = std.math.maxInt(i16);
            } else {
                terminfo.numbers[i] = @intCast(number);
            }
        }
    }

    offset += num_count * num_size;

    // Strings
    terminfo.strings = alloc.alloc(?[]const u8, tinfo.str_count) catch return error.OutOfMemory;
    if (str_count > 0) {
        // These are the string offsets
        std.mem.copyForwards(u8, std.mem.sliceAsBytes(num_buf[0 .. 2 * str_count]), data[offset .. offset + 2 * str_count]);
        offset += 2 * str_count;

        @memcpy(terminfo.str_table[0..str_size], data[offset .. offset + str_size]);

        // Validating the strings
        i = 0;
        while (i < str_count) : (i += 1) {
            const str_offset = i16FromBytes(num_buf[i * 2 .. i * 2 + 2]);
            if (str_offset < 0 or str_offset > str_size) {
                terminfo.strings[i] = null;
            } else {
                const end = std.mem.indexOfScalarPos(u8, terminfo.str_table, @intCast(str_offset), 0);
                if (end == null) return error.InvalidTerminfo;

                terminfo.strings[i] = terminfo.str_table[@intCast(str_offset)..end.?];
            }
        }
    }

    var count: u32 = bool_count;
    while (count < tinfo.bool_count) : (count += 1) terminfo.bools[count] = false;

    count = num_count;
    while (count < tinfo.num_count) : (count += 1) terminfo.numbers[count] = -1;

    count = str_count;
    while (count < tinfo.str_count) : (count += 1) terminfo.strings[count] = null;

    return terminfo;
}

fn findFieldEnding(data: []const u8) ?usize {
    while (true) {
        const pos = std.mem.indexOf(u8, data, ",");

        if (pos == null) return null;
        if (pos == 0) return 0;
        if (data[pos.? - 1] != '\\') return pos.?;
    }
}

pub const Parameter = union(enum) {
    index: u32,
};
