pub const set_color = (1 << 7) << 8;
pub const set_bold = (1 << 6) << 8;

const clearcmd = @import("screen/clear.zig");
pub const clear_screen = clearcmd.clear_screen;
pub const clear_line = clearcmd.clear_line;
pub const clear_left = clearcmd.clear_left;
pub const clear_right = clearcmd.clear_right;
pub const clear_area = clearcmd.clear_area;

const cursorcmd = @import("screen/cursor.zig");
pub const move_cursor = cursorcmd.move_cursor;
pub const cursor_home = cursorcmd.cursor_home;
pub const cursor_left = cursorcmd.cursor_left;
pub const cursor_right = cursorcmd.cursor_right;
pub const cursor_up = cursorcmd.cursor_up;
pub const cursor_down = cursorcmd.cursor_down;

const printcmd = @import("screen/print.zig");
pub const print = printcmd.print;
pub const print_at = printcmd.print_at;

const colorcmd = @import("screen/color.zig");
pub const set_foreground = colorcmd.set_foreground;
pub const set_background = colorcmd.set_background;
pub const set_colors = colorcmd.set_colors;

pub const color_range = colorcmd.color_range;
pub const color_area = colorcmd.color_area;
pub const color_line = colorcmd.color_line;
