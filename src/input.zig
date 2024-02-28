const std = @import("std");
const curses = @import("curses.zig");

pub const AsciiCode = enum(u8) {
    // Control characters
    Null = 0,
    StartHeading = 1,
    StartText = 2,
    EndText = 3,
    EndTransmission = 4,
    Enquiry = 5,
    Acknowledge = 6,
    Bell = 7,
    Backspace = 8,
    Tab = 9,
    Newline = 10,
    VerticalTab = 11,
    FormFeed = 12,
    Carriage = 13,
    ShiftOut = 14,
    ShiftIn = 15,
    DataLink = 16,
    Xon = 17,
    ControlTwo = 18,
    Xoff = 19,
    Control4 = 20,
    AckNeg = 21,
    Idle = 22,
    EndOfBlock = 23,
    Cancel = 24,
    EndOfMedium = 25,
    Substitute = 26,
    Escape = 27,
    FileSeparator = 28,
    GroupSeparator = 29,
    RecordSeparator = 30,
    UnitSeparator = 31,
    Delete = 127,

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

pub const InputError = error{
    UnsupportedKey,
    ReadError,
    InvalidUnicode,
};

const command = @import("command.zig");

pub const Input = union(enum) {
    ascii: u8,
    utf8: u21,
    control: u8, // Ctrl + key
    key: Keycode,

    // On some terminals you press escape and then another button registered as
    // one character.
    escape: u8,
};

/// Various special keys not representable in ascii or unicode
pub const Keycode = enum {
    ArrowUp,
    ArrowDown,
    ArrowLeft,
    ArrowRight,
};

const special_keys = std.ComptimeStringMap(Keycode, .{
    .{ "[A", .ArrowUp },
    .{ "[B", .ArrowDown },
    .{ "[C", .ArrowRight },
    .{ "[D", .ArrowLeft },
});

pub fn read_char(screen: *curses.Screen) InputError!Input {
    var buf: [8]u8 = undefined;
    const read = screen.term.tty_file.read(&buf) catch return InputError.ReadError;

    if (read == 0) {
        return InputError.ReadError;
    } else if (read == 1) {
        // https://en.wikipedia.org/wiki/Control_character#How_control_characters_map_to_keyboards
        if (buf[0] < 32 and
            buf[0] != @intFromEnum(AsciiCode.Newline) and
            buf[0] != @intFromEnum(AsciiCode.Tab) and
            buf[0] != @intFromEnum(AsciiCode.Escape))
        {
            return .{ .control = buf[0] + 0x40 };
        }

        return .{ .ascii = buf[0] };
    } else if (buf[0] == 0x1b) {
        const key = special_keys.get(buf[1..read]);
        if (key != null) {
            return .{ .key = key.? };
        }

        // For simplicity we will assume that it isn't an escape sequence
        if (buf[1] != '[') {
            return .{ .escape = buf[1] };
        }
    } else if (read <= 4) {
        return .{
            .utf8 = std.unicode.utf8Decode(buf[0..read]) catch return InputError.InvalidUnicode,
        };
    }

    return InputError.UnsupportedKey;
}
