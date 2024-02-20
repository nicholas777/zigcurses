const command = @import("command.zig");
const curses = @import("curses.zig");
const cmd = curses.cmd;

const std = @import("std");

pub fn draw_screen(screen: *curses.Screen) !void {
    var is_bold = false;

    var buffered = std.io.bufferedWriter(std.io.getStdOut().writer());
    const bw = buffered.writer();

    try command.move_cursor(screen, @intCast(screen.cursor_x), @intCast(screen.cursor_y));

    try command.save_cursor(screen);
    try command.cursor_home(screen);

    var i: usize = 0;
    while (i < screen.buffer.len - 1) : (i += 1) {
        for (screen.buffer[i]) |char| {
            if (char & 0xFF00 != 0) {
                try buffered.flush();

                if (char & cmd.set_color != 0) {
                    try command.set_colors(screen, @enumFromInt((char >> 8) & 0x7), @enumFromInt((char >> 11) & 0x7));
                }

                if (char & cmd.set_bold != 0) {
                    if (is_bold) {
                        try command.end_bold(screen);
                    } else {
                        try command.start_bold(screen);
                        is_bold = true;
                    }
                }
            }

            try bw.writeByte(@intCast(char & 0xFF));
        }
    }

    i = 0;
    while (i < screen.buffer[screen.lines - 1].len) : (i += 1) {
        const char = screen.buffer[screen.lines - 1][i];

        if (char & 0xFF00 != 0) {
            try buffered.flush();

            if (char & cmd.set_color != 0) {
                try command.set_colors(screen, @enumFromInt((char >> 8) & 0x7), @enumFromInt((char >> 11) & 0x7));
            }

            if (char & cmd.set_bold != 0) {
                if (is_bold) {
                    try command.end_bold(screen);
                } else {
                    try command.start_bold(screen);
                    is_bold = true;
                }
            }
        }

        if (i != screen.columns)
            try bw.writeByte(@intCast(char & 0xFF));
    }

    try buffered.flush();

    try command.load_cursor(screen);
}
