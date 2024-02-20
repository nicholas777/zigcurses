const std = @import("std");
const curses = @import("curses.zig");

pub const Keycode = enum(u8) {
    // Control characters
    Null = 0,
    Bell = 7,
    Backspace = 8,
    Tab = 9,
    Newline = 10,
    Carriage = 13,
    Escape = 27,
    Delete = 127,

    // Non-Ascii custom characters
    ArrowLeft = 1,
    ArrowRight = 2,
    ArrowDown = 3,
    ArrowUp = 4,

    Space = 32,
    ExclMark = 33,
    DoubleQuote = 34,
    HashTag = 35,
    Dollar = 36,
    Percent = 37,
    Ampersand = 38,
    SingleQuote = 39,
    OpeningParen = 40,
    ClosingParen = 41,
    Asterisk = 42,
    Plus = 43,
    Comma = 44,
    Minus = 45,
    Dot = 46,
    Slash = 47,
    Zero = 48,
    One = 49,
    Two = 50,
    Three = 51,
    Four = 52,
    Five = 53,
    Six = 54,
    Seven = 55,
    Eight = 56,
    Nine = 57,
    Colon = 58,
    Semicolon = 59,
    LessThan = 60,
    Equals = 61,
    GreaterThan = 62,
    QuestionMark = 63,
    At = 64,

    UpperCaseA = 65,
    UpperCaseB = 66,
    UpperCaseC = 67,
    UpperCaseD = 68,
    UpperCaseE = 69,
    UpperCaseF = 70,
    UpperCaseG = 71,
    UpperCaseH = 72,
    UpperCaseI = 73,
    UpperCaseJ = 74,
    UpperCaseK = 75,
    UpperCaseL = 76,
    UpperCaseM = 77,
    UpperCaseN = 78,
    UpperCaseO = 79,
    UpperCaseP = 80,
    UpperCaseQ = 81,
    UpperCaseR = 82,
    UpperCaseS = 83,
    UpperCaseT = 84,
    UpperCaseU = 85,
    UpperCaseV = 86,
    UpperCaseW = 87,
    UpperCaseX = 88,
    UpperCaseY = 89,
    UpperCaseZ = 90,

    OpeningSquareBracket = 91,
    BackSlash = 92,
    ClosingSquareBracket = 93,
    Caret = 94,
    Underscore = 95,
    GraveAccent = 96,

    LowerCaseA = 97,
    LowerCaseB = 98,
    LowerCaseC = 99,
    LowerCaseD = 100,
    LowerCaseE = 101,
    LowerCaseF = 102,
    LowerCaseG = 103,
    LowerCaseH = 104,
    LowerCaseI = 105,
    LowerCaseJ = 106,
    LowerCaseK = 107,
    LowerCaseL = 108,
    LowerCaseM = 109,
    LowerCaseN = 110,
    LowerCaseO = 111,
    LowerCaseP = 112,
    LowerCaseQ = 113,
    LowerCaseR = 114,
    LowerCaseS = 115,
    LowerCaseT = 116,
    LowerCaseU = 117,
    LowerCaseV = 118,
    LowerCaseW = 119,
    LowerCaseX = 120,
    LowerCaseY = 121,
    LowerCaseZ = 122,

    OpeningCurlyBracket = 123,
    Pipe = 124,
    ClosingCurlyBracket = 125,
    Tilda = 126,
};

const specialKeys = std.ComptimeStringMap(Keycode, .{
    .{ "[A", .ArrowUp },
    .{ "OA", .ArrowUp },
    .{ "[B", .ArrowDown },
    .{ "OB", .ArrowDown },
    .{ "[C", .ArrowRight },
    .{ "OC", .ArrowRight },
    .{ "[D", .ArrowLeft },
    .{ "OD", .ArrowLeft },
});

pub const InputError = error{
    UnsupportedKey,
};

const command = @import("command.zig");

pub fn read_char(screen: *curses.Screen) !Keycode {
    var buf: [1]u8 = undefined;
    _ = try screen.term.tty_file.read(&buf);

    if (buf[0] != 0x1b) {
        return @enumFromInt(buf[0]);
    } else {
        screen.term.curr_termios.cc[std.os.system.V.TIME] = 1;
        screen.term.curr_termios.cc[std.os.system.V.MIN] = 0;
        try std.os.tcsetattr(screen.term.tty_file.handle, .NOW, screen.term.curr_termios);

        var buf2: [8]u8 = undefined;
        const read = try screen.term.tty_file.read(&buf2);

        screen.term.curr_termios.cc[std.os.system.V.TIME] = 0;
        screen.term.curr_termios.cc[std.os.system.V.MIN] = 1;
        try std.os.tcsetattr(screen.term.tty_file.handle, .NOW, screen.term.curr_termios);

        if (read == 0) {
            return .Escape;
        }

        if (specialKeys.get(buf2[0..read])) |value| {
            return value;
        }
    }

    return InputError.UnsupportedKey;
}
