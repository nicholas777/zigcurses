pub const terminfo_dirs = [_][]const u8{ "/etc/terminfo", "/lib/terminfo", "/usr/share/terminfo" };

pub const ColorMode = enum { Ansi, Hp, HpExtended };

// We use ansi colors as default, and translate to HpColor when necessary
pub const Color = AnsiColor;
pub const AnsiColor = enum(u8) {
    Black = 0,
    Red = 1,
    Green = 2,
    Yellow = 3,
    Blue = 4,
    Magenta = 5,
    Cyan = 6,
    White = 7,
};

pub const HpColor = enum(u8) {
    Black = 0,
    Blue = 1,
    Green = 2,
    Cyan = 3,
    Red = 4,
    Magenta = 5,
    Yellow = 6,
    White = 7,
};

pub fn to_hp_color(c: Color) HpColor {
    switch (c) {
        .Black, .Green, .Magenta, .White => {
            return @enumFromInt(@intFromEnum(c));
        },
        .Red => return .Blue,
        .Blue => return .Red,
        .Yellow => return .Cyan,
        .Cyan => return .Yellow,
    }
}
