pub const bool_count = 44;
pub const num_count = 39;
pub const str_count = 414;

pub const bool_names = [_][:0]const u8{
    "bw",
    "am",
    "xsb",
    "xhp",
    "xenl",
    "eo",
    "gn",
    "hc",
    "km",
    "hs",
    "in",
    "da",
    "db",
    "mir",
    "msgr",
    "os",
    "eslok",
    "xt",
    "hz",
    "ul",
    "xon",
    "nxon",
    "mc5i",
    "chts",
    "nrrmc",
    "npc",
    "ndscr",
    "ccc",
    "bce",
    "hls",
    "xhpa",
    "crxm",
    "daisy",
    "xvpa",
    "sam",
    "cpix",
    "lpix",
    "OTbs",
    "OTns",
    "OTnc",
    "OTMT",
    "OTNL",
    "OTpt",
    "OTxr",
};

pub const bool_names_long = [_][:0]const u8{
    "auto_left_margin",
    "auto_right_margin",
    "no_esc_ctlc",
    "ceol_standout_glitch",
    "eat_newline_glitch",
    "erase_overstrike",
    "generic_type",
    "hard_copy",
    "has_meta_key",
    "has_status_line",
    "insert_null_glitch",
    "memory_above",
    "memory_below",
    "move_insert_mode",
    "move_standout_mode",
    "over_strike",
    "status_line_esc_ok",
    "dest_tabs_magic_smso",
    "tilde_glitch",
    "transparent_underline",
    "xon_xoff",
    "needs_xon_xoff",
    "prtr_silent",
    "hard_cursor",
    "non_rev_rmcup",
    "no_pad_char",
    "non_dest_scroll_region",
    "can_change",
    "back_color_erase",
    "hue_lightness_saturation",
    "col_addr_glitch",
    "cr_cancels_micro_mode",
    "has_print_wheel",
    "row_addr_glitch",
    "semi_auto_right_margin",
    "cpi_changes_res",
    "lpi_changes_res",
    "backspaces_with_bs",
    "crt_no_scrolling",
    "no_correctly_working_cr",
    "gnu_has_meta_key",
    "linefeed_is_newline",
    "has_hardware_tabs",
    "return_does_clr_eol",
};

pub const num_names = [_][:0]const u8{
    "cols",
    "it",
    "lines",
    "lm",
    "xmc",
    "pb",
    "vt",
    "wsl",
    "nlab",
    "lh",
    "lw",
    "ma",
    "wnum",
    "colors",
    "pairs",
    "ncv",
    "bufsz",
    "spinv",
    "spinh",
    "maddr",
    "mjump",
    "mcs",
    "mls",
    "npins",
    "orc",
    "orl",
    "orhi",
    "orvi",
    "cps",
    "widcs",
    "btns",
    "bitwin",
    "bitype",
    "OTug",
    "OTdC",
    "OTdN",
    "OTdB",
    "OTdT",
    "OTkn",
};

pub const num_names_long = [_][:0]const u8{
    "columns",
    "init_tabs",
    "lines",
    "lines_of_memory",
    "magic_cookie_glitch",
    "padding_baud_rate",
    "virtual_terminal",
    "width_status_line",
    "num_labels",
    "label_height",
    "label_width",
    "max_attributes",
    "maximum_windows",
    "max_colors",
    "max_pairs",
    "no_color_video",
    "buffer_capacity",
    "dot_vert_spacing",
    "dot_horz_spacing",
    "max_micro_address",
    "max_micro_jump",
    "micro_col_size",
    "micro_line_size",
    "number_of_pins",
    "output_res_char",
    "output_res_line",
    "output_res_horz_inch",
    "output_res_vert_inch",
    "print_rate",
    "wide_char_size",
    "buttons",
    "bit_image_entwining",
    "bit_image_type",
    "magic_cookie_glitch_ul",
    "carriage_return_delay",
    "new_line_delay",
    "backspace_delay",
    "horizontal_tab_delay",
    "number_of_function_keys",
};

pub const str_names = [_][:0]const u8{
    "cbt",
    "bel",
    "cr",
    "csr",
    "tbc",
    "clear",
    "el",
    "ed",
    "hpa",
    "cmdch",
    "cup",
    "cud1",
    "home",
    "civis",
    "cub1",
    "mrcup",
    "cnorm",
    "cuf1",
    "ll",
    "cuu1",
    "cvvis",
    "dch1",
    "dl1",
    "dsl",
    "hd",
    "smacs",
    "blink",
    "bold",
    "smcup",
    "smdc",
    "dim",
    "smir",
    "invis",
    "prot",
    "rev",
    "smso",
    "smul",
    "ech",
    "rmacs",
    "sgr0",
    "rmcup",
    "rmdc",
    "rmir",
    "rmso",
    "rmul",
    "flash",
    "ff",
    "fsl",
    "is1",
    "is2",
    "is3",
    "if",
    "ich1",
    "il1",
    "ip",
    "kbs",
    "ktbc",
    "kclr",
    "kctab",
    "kdch1",
    "kdl1",
    "kcud1",
    "krmir",
    "kel",
    "ked",
    "kf0",
    "kf1",
    "kf10",
    "kf2",
    "kf3",
    "kf4",
    "kf5",
    "kf6",
    "kf7",
    "kf8",
    "kf9",
    "khome",
    "kich1",
    "kil1",
    "kcub1",
    "kll",
    "knp",
    "kpp",
    "kcuf1",
    "kind",
    "kri",
    "khts",
    "kcuu1",
    "rmkx",
    "smkx",
    "lf0",
    "lf1",
    "lf10",
    "lf2",
    "lf3",
    "lf4",
    "lf5",
    "lf6",
    "lf7",
    "lf8",
    "lf9",
    "rmm",
    "smm",
    "nel",
    "pad",
    "dch",
    "dl",
    "cud",
    "ich",
    "indn",
    "il",
    "cub",
    "cuf",
    "rin",
    "cuu",
    "pfkey",
    "pfloc",
    "pfx",
    "mc0",
    "mc4",
    "mc5",
    "rep",
    "rs1",
    "rs2",
    "rs3",
    "rf",
    "rc",
    "vpa",
    "sc",
    "ind",
    "ri",
    "sgr",
    "hts",
    "wind",
    "ht",
    "tsl",
    "uc",
    "hu",
    "iprog",
    "ka1",
    "ka3",
    "kb2",
    "kc1",
    "kc3",
    "mc5p",
    "rmp",
    "acsc",
    "pln",
    "kcbt",
    "smxon",
    "rmxon",
    "smam",
    "rmam",
    "xonc",
    "xoffc",
    "enacs",
    "smln",
    "rmln",
    "kbeg",
    "kcan",
    "kclo",
    "kcmd",
    "kcpy",
    "kcrt",
    "kend",
    "kent",
    "kext",
    "kfnd",
    "khlp",
    "kmrk",
    "kmsg",
    "kmov",
    "knxt",
    "kopn",
    "kopt",
    "kprv",
    "kprt",
    "krdo",
    "kref",
    "krfr",
    "krpl",
    "krst",
    "kres",
    "ksav",
    "kspd",
    "kund",
    "kBEG",
    "kCAN",
    "kCMD",
    "kCPY",
    "kCRT",
    "kDC",
    "kDL",
    "kslt",
    "kEND",
    "kEOL",
    "kEXT",
    "kFND",
    "kHLP",
    "kHOM",
    "kIC",
    "kLFT",
    "kMSG",
    "kMOV",
    "kNXT",
    "kOPT",
    "kPRV",
    "kPRT",
    "kRDO",
    "kRPL",
    "kRIT",
    "kRES",
    "kSAV",
    "kSPD",
    "kUND",
    "rfi",
    "kf11",
    "kf12",
    "kf13",
    "kf14",
    "kf15",
    "kf16",
    "kf17",
    "kf18",
    "kf19",
    "kf20",
    "kf21",
    "kf22",
    "kf23",
    "kf24",
    "kf25",
    "kf26",
    "kf27",
    "kf28",
    "kf29",
    "kf30",
    "kf31",
    "kf32",
    "kf33",
    "kf34",
    "kf35",
    "kf36",
    "kf37",
    "kf38",
    "kf39",
    "kf40",
    "kf41",
    "kf42",
    "kf43",
    "kf44",
    "kf45",
    "kf46",
    "kf47",
    "kf48",
    "kf49",
    "kf50",
    "kf51",
    "kf52",
    "kf53",
    "kf54",
    "kf55",
    "kf56",
    "kf57",
    "kf58",
    "kf59",
    "kf60",
    "kf61",
    "kf62",
    "kf63",
    "el1",
    "mgc",
    "smgl",
    "smgr",
    "fln",
    "sclk",
    "dclk",
    "rmclk",
    "cwin",
    "wingo",
    "hup",
    "dial",
    "qdial",
    "tone",
    "pulse",
    "hook",
    "pause",
    "wait",
    "u0",
    "u1",
    "u2",
    "u3",
    "u4",
    "u5",
    "u6",
    "u7",
    "u8",
    "u9",
    "op",
    "oc",
    "initc",
    "initp",
    "scp",
    "setf",
    "setb",
    "cpi",
    "lpi",
    "chr",
    "cvr",
    "defc",
    "swidm",
    "sdrfq",
    "sitm",
    "slm",
    "smicm",
    "snlq",
    "snrmq",
    "sshm",
    "ssubm",
    "ssupm",
    "sum",
    "rwidm",
    "ritm",
    "rlm",
    "rmicm",
    "rshm",
    "rsubm",
    "rsupm",
    "rum",
    "mhpa",
    "mcud1",
    "mcub1",
    "mcuf1",
    "mvpa",
    "mcuu1",
    "porder",
    "mcud",
    "mcub",
    "mcuf",
    "mcuu",
    "scs",
    "smgb",
    "smgbp",
    "smglp",
    "smgrp",
    "smgt",
    "smgtp",
    "sbim",
    "scsd",
    "rbim",
    "rcsd",
    "subcs",
    "supcs",
    "docr",
    "zerom",
    "csnm",
    "kmous",
    "minfo",
    "reqmp",
    "getm",
    "setaf",
    "setab",
    "pfxl",
    "devt",
    "csin",
    "s0ds",
    "s1ds",
    "s2ds",
    "s3ds",
    "smglr",
    "smgtb",
    "birep",
    "binel",
    "bicr",
    "colornm",
    "defbi",
    "endbi",
    "setcolor",
    "slines",
    "dispc",
    "smpch",
    "rmpch",
    "smsc",
    "rmsc",
    "pctrm",
    "scesc",
    "scesa",
    "ehhlm",
    "elhlm",
    "elohlm",
    "erhlm",
    "ethlm",
    "evhlm",
    "sgr1",
    "slength",
    "OTi2",
    "OTrs",
    "OTnl",
    "OTbc",
    "OTko",
    "OTma",
    "OTG2",
    "OTG3",
    "OTG1",
    "OTG4",
    "OTGR",
    "OTGL",
    "OTGU",
    "OTGD",
    "OTGH",
    "OTGV",
    "OTGC",
    "meml",
    "memu",
    "box1",
};

pub const str_names_long = [_][:0]const u8{
    "back_tab",
    "bell",
    "carriage_return",
    "change_scroll_region",
    "clear_all_tabs",
    "clear_screen",
    "clr_eol",
    "clr_eos",
    "column_address",
    "command_character",
    "cursor_address",
    "cursor_down",
    "cursor_home",
    "cursor_invisible",
    "cursor_left",
    "cursor_mem_address",
    "cursor_normal",
    "cursor_right",
    "cursor_to_ll",
    "cursor_up",
    "cursor_visible",
    "delete_character",
    "delete_line",
    "dis_status_line",
    "down_half_line",
    "enter_alt_charset_mode",
    "enter_blink_mode",
    "enter_bold_mode",
    "enter_ca_mode",
    "enter_delete_mode",
    "enter_dim_mode",
    "enter_insert_mode",
    "enter_secure_mode",
    "enter_protected_mode",
    "enter_reverse_mode",
    "enter_standout_mode",
    "enter_underline_mode",
    "erase_chars",
    "exit_alt_charset_mode",
    "exit_attribute_mode",
    "exit_ca_mode",
    "exit_delete_mode",
    "exit_insert_mode",
    "exit_standout_mode",
    "exit_underline_mode",
    "flash_screen",
    "form_feed",
    "from_status_line",
    "init_1string",
    "init_2string",
    "init_3string",
    "init_file",
    "insert_character",
    "insert_line",
    "insert_padding",
    "key_backspace",
    "key_catab",
    "key_clear",
    "key_ctab",
    "key_dc",
    "key_dl",
    "key_down",
    "key_eic",
    "key_eol",
    "key_eos",
    "key_f0",
    "key_f1",
    "key_f10",
    "key_f2",
    "key_f3",
    "key_f4",
    "key_f5",
    "key_f6",
    "key_f7",
    "key_f8",
    "key_f9",
    "key_home",
    "key_ic",
    "key_il",
    "key_left",
    "key_ll",
    "key_npage",
    "key_ppage",
    "key_right",
    "key_sf",
    "key_sr",
    "key_stab",
    "key_up",
    "keypad_local",
    "keypad_xmit",
    "lab_f0",
    "lab_f1",
    "lab_f10",
    "lab_f2",
    "lab_f3",
    "lab_f4",
    "lab_f5",
    "lab_f6",
    "lab_f7",
    "lab_f8",
    "lab_f9",
    "meta_off",
    "meta_on",
    "newline",
    "pad_char",
    "parm_dch",
    "parm_delete_line",
    "parm_down_cursor",
    "parm_ich",
    "parm_index",
    "parm_insert_line",
    "parm_left_cursor",
    "parm_right_cursor",
    "parm_rindex",
    "parm_up_cursor",
    "pkey_key",
    "pkey_local",
    "pkey_xmit",
    "print_screen",
    "prtr_off",
    "prtr_on",
    "repeat_char",
    "reset_1string",
    "reset_2string",
    "reset_3string",
    "reset_file",
    "restore_cursor",
    "row_address",
    "save_cursor",
    "scroll_forward",
    "scroll_reverse",
    "set_attributes",
    "set_tab",
    "set_window",
    "tab",
    "to_status_line",
    "underline_char",
    "up_half_line",
    "init_prog",
    "key_a1",
    "key_a3",
    "key_b2",
    "key_c1",
    "key_c3",
    "prtr_non",
    "char_padding",
    "acs_chars",
    "plab_norm",
    "key_btab",
    "enter_xon_mode",
    "exit_xon_mode",
    "enter_am_mode",
    "exit_am_mode",
    "xon_character",
    "xoff_character",
    "ena_acs",
    "label_on",
    "label_off",
    "key_beg",
    "key_cancel",
    "key_close",
    "key_command",
    "key_copy",
    "key_create",
    "key_end",
    "key_enter",
    "key_exit",
    "key_find",
    "key_help",
    "key_mark",
    "key_message",
    "key_move",
    "key_next",
    "key_open",
    "key_options",
    "key_previous",
    "key_print",
    "key_redo",
    "key_reference",
    "key_refresh",
    "key_replace",
    "key_restart",
    "key_resume",
    "key_save",
    "key_suspend",
    "key_undo",
    "key_sbeg",
    "key_scancel",
    "key_scommand",
    "key_scopy",
    "key_screate",
    "key_sdc",
    "key_sdl",
    "key_select",
    "key_send",
    "key_seol",
    "key_sexit",
    "key_sfind",
    "key_shelp",
    "key_shome",
    "key_sic",
    "key_sleft",
    "key_smessage",
    "key_smove",
    "key_snext",
    "key_soptions",
    "key_sprevious",
    "key_sprint",
    "key_sredo",
    "key_sreplace",
    "key_sright",
    "key_srsume",
    "key_ssave",
    "key_ssuspend",
    "key_sundo",
    "req_for_input",
    "key_f11",
    "key_f12",
    "key_f13",
    "key_f14",
    "key_f15",
    "key_f16",
    "key_f17",
    "key_f18",
    "key_f19",
    "key_f20",
    "key_f21",
    "key_f22",
    "key_f23",
    "key_f24",
    "key_f25",
    "key_f26",
    "key_f27",
    "key_f28",
    "key_f29",
    "key_f30",
    "key_f31",
    "key_f32",
    "key_f33",
    "key_f34",
    "key_f35",
    "key_f36",
    "key_f37",
    "key_f38",
    "key_f39",
    "key_f40",
    "key_f41",
    "key_f42",
    "key_f43",
    "key_f44",
    "key_f45",
    "key_f46",
    "key_f47",
    "key_f48",
    "key_f49",
    "key_f50",
    "key_f51",
    "key_f52",
    "key_f53",
    "key_f54",
    "key_f55",
    "key_f56",
    "key_f57",
    "key_f58",
    "key_f59",
    "key_f60",
    "key_f61",
    "key_f62",
    "key_f63",
    "clr_bol",
    "clear_margins",
    "set_left_margin",
    "set_right_margin",
    "label_format",
    "set_clock",
    "display_clock",
    "remove_clock",
    "create_window",
    "goto_window",
    "hangup",
    "dial_phone",
    "quick_dial",
    "tone",
    "pulse",
    "flash_hook",
    "fixed_pause",
    "wait_tone",
    "user0",
    "user1",
    "user2",
    "user3",
    "user4",
    "user5",
    "user6",
    "user7",
    "user8",
    "user9",
    "orig_pair",
    "orig_colors",
    "initialize_color",
    "initialize_pair",
    "set_color_pair",
    "set_foreground",
    "set_background",
    "change_char_pitch",
    "change_line_pitch",
    "change_res_horz",
    "change_res_vert",
    "define_char",
    "enter_doublewide_mode",
    "enter_draft_quality",
    "enter_italics_mode",
    "enter_leftward_mode",
    "enter_micro_mode",
    "enter_near_letter_quality",
    "enter_normal_quality",
    "enter_shadow_mode",
    "enter_subscript_mode",
    "enter_superscript_mode",
    "enter_upward_mode",
    "exit_doublewide_mode",
    "exit_italics_mode",
    "exit_leftward_mode",
    "exit_micro_mode",
    "exit_shadow_mode",
    "exit_subscript_mode",
    "exit_superscript_mode",
    "exit_upward_mode",
    "micro_column_address",
    "micro_down",
    "micro_left",
    "micro_right",
    "micro_row_address",
    "micro_up",
    "order_of_pins",
    "parm_down_micro",
    "parm_left_micro",
    "parm_right_micro",
    "parm_up_micro",
    "select_char_set",
    "set_bottom_margin",
    "set_bottom_margin_parm",
    "set_left_margin_parm",
    "set_right_margin_parm",
    "set_top_margin",
    "set_top_margin_parm",
    "start_bit_image",
    "start_char_set_def",
    "stop_bit_image",
    "stop_char_set_def",
    "subscript_characters",
    "superscript_characters",
    "these_cause_cr",
    "zero_motion",
    "char_set_names",
    "key_mouse",
    "mouse_info",
    "req_mouse_pos",
    "get_mouse",
    "set_a_foreground",
    "set_a_background",
    "pkey_plab",
    "device_type",
    "code_set_init",
    "set0_des_seq",
    "set1_des_seq",
    "set2_des_seq",
    "set3_des_seq",
    "set_lr_margin",
    "set_tb_margin",
    "bit_image_repeat",
    "bit_image_newline",
    "bit_image_carriage_return",
    "color_names",
    "define_bit_image_region",
    "end_bit_image_region",
    "set_color_band",
    "set_page_length",
    "display_pc_char",
    "enter_pc_charset_mode",
    "exit_pc_charset_mode",
    "enter_scancode_mode",
    "exit_scancode_mode",
    "pc_term_options",
    "scancode_escape",
    "alt_scancode_esc",
    "enter_horizontal_hl_mode",
    "enter_left_hl_mode",
    "enter_low_hl_mode",
    "enter_right_hl_mode",
    "enter_top_hl_mode",
    "enter_vertical_hl_mode",
    "set_a_attributes",
    "set_pglen_inch",
    "termcap_init2",
    "termcap_reset",
    "linefeed_if_not_lf",
    "backspace_if_not_bs",
    "other_non_function_keys",
    "arrow_key_map",
    "acs_ulcorner",
    "acs_llcorner",
    "acs_urcorner",
    "acs_lrcorner",
    "acs_ltee",
    "acs_rtee",
    "acs_btee",
    "acs_ttee",
    "acs_hline",
    "acs_vline",
    "acs_plus",
    "memory_lock",
    "memory_unlock",
    "box_chars_1",
};

pub const bool_auto_left_margin = 0;
pub const bool_auto_right_margin = 1;
pub const bool_no_esc_ctlc = 2;
pub const bool_ceol_standout_glitch = 3;
pub const bool_eat_newline_glitch = 4;
pub const bool_erase_overstrike = 5;
pub const bool_generic_type = 6;
pub const bool_hard_copy = 7;
pub const bool_has_meta_key = 8;
pub const bool_has_status_line = 9;
pub const bool_insert_null_glitch = 10;
pub const bool_memory_above = 11;
pub const bool_memory_below = 12;
pub const bool_move_insert_mode = 13;
pub const bool_move_standout_mode = 14;
pub const bool_over_strike = 15;
pub const bool_status_line_esc_ok = 16;
pub const bool_dest_tabs_magic_smso = 17;
pub const bool_tilde_glitch = 18;
pub const bool_transparent_underline = 19;
pub const bool_xon_xoff = 20;
pub const bool_needs_xon_xoff = 21;
pub const bool_prtr_silent = 22;
pub const bool_hard_cursor = 23;
pub const bool_non_rev_rmcup = 24;
pub const bool_no_pad_char = 25;
pub const bool_non_dest_scroll_region = 26;
pub const bool_can_change = 27;
pub const bool_back_color_erase = 28;
pub const bool_hue_lightness_saturation = 29;
pub const bool_col_addr_glitch = 30;
pub const bool_cr_cancels_micro_mode = 31;
pub const bool_has_print_wheel = 32;
pub const bool_row_addr_glitch = 33;
pub const bool_semi_auto_right_margin = 34;
pub const bool_cpi_changes_res = 35;
pub const bool_lpi_changes_res = 36;

pub const num_columns = 0;
pub const num_init_tabs = 1;
pub const num_lines = 2;
pub const num_lines_of_memory = 3;
pub const num_magic_cookie_glitch = 4;
pub const num_padding_baud_rate = 5;
pub const num_virtual_terminal = 6;
pub const num_width_status_line = 7;
pub const num_num_labels = 8;
pub const num_label_height = 9;
pub const num_label_width = 10;
pub const num_max_attributes = 11;
pub const num_maximum_windows = 12;
pub const num_max_colors = 13;
pub const num_max_pairs = 14;
pub const num_no_color_video = 15;
pub const num_buffer_capacity = 16;
pub const num_dot_vert_spacing = 17;
pub const num_dot_horz_spacing = 18;
pub const num_max_micro_address = 19;
pub const num_max_micro_jump = 20;
pub const num_micro_col_size = 21;
pub const num_micro_line_size = 22;
pub const num_number_of_pins = 23;
pub const num_output_res_char = 24;
pub const num_output_res_line = 25;
pub const num_output_res_horz_inch = 26;
pub const num_output_res_vert_inch = 27;
pub const num_print_rate = 28;
pub const num_wide_char_size = 29;
pub const num_buttons = 30;
pub const num_bit_image_entwining = 31;
pub const num_bit_image_type = 32;

pub const str_back_tab = 0;
pub const str_bell = 1;
pub const str_carriage_return = 2;
pub const str_change_scroll_region = 3;
pub const str_clear_all_tabs = 4;
pub const str_clear_screen = 5;
pub const str_clr_eol = 6;
pub const str_clr_eos = 7;
pub const str_column_address = 8;
pub const str_command_character = 9;
pub const str_cursor_address = 10;
pub const str_cursor_down = 11;
pub const str_cursor_home = 12;
pub const str_cursor_invisible = 13;
pub const str_cursor_left = 14;
pub const str_cursor_mem_address = 15;
pub const str_cursor_normal = 16;
pub const str_cursor_right = 17;
pub const str_cursor_to_ll = 18;
pub const str_cursor_up = 19;
pub const str_cursor_visible = 20;
pub const str_delete_character = 21;
pub const str_delete_line = 22;
pub const str_dis_status_line = 23;
pub const str_down_half_line = 24;
pub const str_enter_alt_charset_mode = 25;
pub const str_enter_blink_mode = 26;
pub const str_enter_bold_mode = 27;
pub const str_enter_ca_mode = 28;
pub const str_enter_delete_mode = 29;
pub const str_enter_dim_mode = 30;
pub const str_enter_insert_mode = 31;
pub const str_enter_secure_mode = 32;
pub const str_enter_protected_mode = 33;
pub const str_enter_reverse_mode = 34;
pub const str_enter_standout_mode = 35;
pub const str_enter_underline_mode = 36;
pub const str_erase_chars = 37;
pub const str_exit_alt_charset_mode = 38;
pub const str_exit_attribute_mode = 39;
pub const str_exit_ca_mode = 40;
pub const str_exit_delete_mode = 41;
pub const str_exit_insert_mode = 42;
pub const str_exit_standout_mode = 43;
pub const str_exit_underline_mode = 44;
pub const str_flash_screen = 45;
pub const str_form_feed = 46;
pub const str_from_status_line = 47;
pub const str_init_1string = 48;
pub const str_init_2string = 49;
pub const str_init_3string = 50;
pub const str_init_file = 51;
pub const str_insert_character = 52;
pub const str_insert_line = 53;
pub const str_insert_padding = 54;
pub const str_key_backspace = 55;
pub const str_key_catab = 56;
pub const str_key_clear = 57;
pub const str_key_ctab = 58;
pub const str_key_dc = 59;
pub const str_key_dl = 60;
pub const str_key_down = 61;
pub const str_key_eic = 62;
pub const str_key_eol = 63;
pub const str_key_eos = 64;
pub const str_key_f0 = 65;
pub const str_key_f1 = 66;
pub const str_key_f10 = 67;
pub const str_key_f2 = 68;
pub const str_key_f3 = 69;
pub const str_key_f4 = 70;
pub const str_key_f5 = 71;
pub const str_key_f6 = 72;
pub const str_key_f7 = 73;
pub const str_key_f8 = 74;
pub const str_key_f9 = 75;
pub const str_key_home = 76;
pub const str_key_ic = 77;
pub const str_key_il = 78;
pub const str_key_left = 79;
pub const str_key_ll = 80;
pub const str_key_npage = 81;
pub const str_key_ppage = 82;
pub const str_key_right = 83;
pub const str_key_sf = 84;
pub const str_key_sr = 85;
pub const str_key_stab = 86;
pub const str_key_up = 87;
pub const str_keypad_local = 88;
pub const str_keypad_xmit = 89;
pub const str_lab_f0 = 90;
pub const str_lab_f1 = 91;
pub const str_lab_f10 = 92;
pub const str_lab_f2 = 93;
pub const str_lab_f3 = 94;
pub const str_lab_f4 = 95;
pub const str_lab_f5 = 96;
pub const str_lab_f6 = 97;
pub const str_lab_f7 = 98;
pub const str_lab_f8 = 99;
pub const str_lab_f9 = 100;
pub const str_meta_off = 101;
pub const str_meta_on = 102;
pub const str_newline = 103;
pub const str_pad_char = 104;
pub const str_parm_dch = 105;
pub const str_parm_delete_line = 106;
pub const str_parm_down_cursor = 107;
pub const str_parm_ich = 108;
pub const str_parm_index = 109;
pub const str_parm_insert_line = 110;
pub const str_parm_left_cursor = 111;
pub const str_parm_right_cursor = 112;
pub const str_parm_rindex = 113;
pub const str_parm_up_cursor = 114;
pub const str_pkey_key = 115;
pub const str_pkey_local = 116;
pub const str_pkey_xmit = 117;
pub const str_print_screen = 118;
pub const str_prtr_off = 119;
pub const str_prtr_on = 120;
pub const str_repeat_char = 121;
pub const str_reset_1string = 122;
pub const str_reset_2string = 123;
pub const str_reset_3string = 124;
pub const str_reset_file = 125;
pub const str_restore_cursor = 126;
pub const str_row_address = 127;
pub const str_save_cursor = 128;
pub const str_scroll_forward = 129;
pub const str_scroll_reverse = 130;
pub const str_set_attributes = 131;
pub const str_set_tab = 132;
pub const str_set_window = 133;
pub const str_tab = 134;
pub const str_to_status_line = 135;
pub const str_underline_char = 136;
pub const str_up_half_line = 137;
pub const str_init_prog = 138;
pub const str_key_a1 = 139;
pub const str_key_a3 = 140;
pub const str_key_b2 = 141;
pub const str_key_c1 = 142;
pub const str_key_c3 = 143;
pub const str_prtr_non = 144;
pub const str_char_padding = 145;
pub const str_acs_chars = 146;
pub const str_plab_norm = 147;
pub const str_key_btab = 148;
pub const str_enter_xon_mode = 149;
pub const str_exit_xon_mode = 150;
pub const str_enter_am_mode = 151;
pub const str_exit_am_mode = 152;
pub const str_xon_character = 153;
pub const str_xoff_character = 154;
pub const str_ena_acs = 155;
pub const str_label_on = 156;
pub const str_label_off = 157;
pub const str_key_beg = 158;
pub const str_key_cancel = 159;
pub const str_key_close = 160;
pub const str_key_command = 161;
pub const str_key_copy = 162;
pub const str_key_create = 163;
pub const str_key_end = 164;
pub const str_key_enter = 165;
pub const str_key_exit = 166;
pub const str_key_find = 167;
pub const str_key_help = 168;
pub const str_key_mark = 169;
pub const str_key_message = 170;
pub const str_key_move = 171;
pub const str_key_next = 172;
pub const str_key_open = 173;
pub const str_key_options = 174;
pub const str_key_previous = 175;
pub const str_key_print = 176;
pub const str_key_redo = 177;
pub const str_key_reference = 178;
pub const str_key_refresh = 179;
pub const str_key_replace = 180;
pub const str_key_restart = 181;
pub const str_key_resume = 182;
pub const str_key_save = 183;
pub const str_key_suspend = 184;
pub const str_key_undo = 185;
pub const str_key_sbeg = 186;
pub const str_key_scancel = 187;
pub const str_key_scommand = 188;
pub const str_key_scopy = 189;
pub const str_key_screate = 190;
pub const str_key_sdc = 191;
pub const str_key_sdl = 192;
pub const str_key_select = 193;
pub const str_key_send = 194;
pub const str_key_seol = 195;
pub const str_key_sexit = 196;
pub const str_key_sfind = 197;
pub const str_key_shelp = 198;
pub const str_key_shome = 199;
pub const str_key_sic = 200;
pub const str_key_sleft = 201;
pub const str_key_smessage = 202;
pub const str_key_smove = 203;
pub const str_key_snext = 204;
pub const str_key_soptions = 205;
pub const str_key_sprevious = 206;
pub const str_key_sprint = 207;
pub const str_key_sredo = 208;
pub const str_key_sreplace = 209;
pub const str_key_sright = 210;
pub const str_key_srsume = 211;
pub const str_key_ssave = 212;
pub const str_key_ssuspend = 213;
pub const str_key_sundo = 214;
pub const str_req_for_input = 215;
pub const str_key_f11 = 216;
pub const str_key_f12 = 217;
pub const str_key_f13 = 218;
pub const str_key_f14 = 219;
pub const str_key_f15 = 220;
pub const str_key_f16 = 221;
pub const str_key_f17 = 222;
pub const str_key_f18 = 223;
pub const str_key_f19 = 224;
pub const str_key_f20 = 225;
pub const str_key_f21 = 226;
pub const str_key_f22 = 227;
pub const str_key_f23 = 228;
pub const str_key_f24 = 229;
pub const str_key_f25 = 230;
pub const str_key_f26 = 231;
pub const str_key_f27 = 232;
pub const str_key_f28 = 233;
pub const str_key_f29 = 234;
pub const str_key_f30 = 235;
pub const str_key_f31 = 236;
pub const str_key_f32 = 237;
pub const str_key_f33 = 238;
pub const str_key_f34 = 239;
pub const str_key_f35 = 240;
pub const str_key_f36 = 241;
pub const str_key_f37 = 242;
pub const str_key_f38 = 243;
pub const str_key_f39 = 244;
pub const str_key_f40 = 245;
pub const str_key_f41 = 246;
pub const str_key_f42 = 247;
pub const str_key_f43 = 248;
pub const str_key_f44 = 249;
pub const str_key_f45 = 250;
pub const str_key_f46 = 251;
pub const str_key_f47 = 252;
pub const str_key_f48 = 253;
pub const str_key_f49 = 254;
pub const str_key_f50 = 255;
pub const str_key_f51 = 256;
pub const str_key_f52 = 257;
pub const str_key_f53 = 258;
pub const str_key_f54 = 259;
pub const str_key_f55 = 260;
pub const str_key_f56 = 261;
pub const str_key_f57 = 262;
pub const str_key_f58 = 263;
pub const str_key_f59 = 264;
pub const str_key_f60 = 265;
pub const str_key_f61 = 266;
pub const str_key_f62 = 267;
pub const str_key_f63 = 268;
pub const str_clr_bol = 269;
pub const str_clear_margins = 270;
pub const str_set_left_margin = 271;
pub const str_set_right_margin = 272;
pub const str_label_format = 273;
pub const str_set_clock = 274;
pub const str_display_clock = 275;
pub const str_remove_clock = 276;
pub const str_create_window = 277;
pub const str_goto_window = 278;
pub const str_hangup = 279;
pub const str_dial_phone = 280;
pub const str_quick_dial = 281;
pub const str_tone = 282;
pub const str_pulse = 283;
pub const str_flash_hook = 284;
pub const str_fixed_pause = 285;
pub const str_wait_tone = 286;
pub const str_user0 = 287;
pub const str_user1 = 288;
pub const str_user2 = 289;
pub const str_user3 = 290;
pub const str_user4 = 291;
pub const str_user5 = 292;
pub const str_user6 = 293;
pub const str_user7 = 294;
pub const str_user8 = 295;
pub const str_user9 = 296;
pub const str_orig_pair = 297;
pub const str_orig_colors = 298;
pub const str_initialize_color = 299;
pub const str_initialize_pair = 300;
pub const str_set_color_pair = 301;
pub const str_set_foreground = 302;
pub const str_set_background = 303;
pub const str_change_char_pitch = 304;
pub const str_change_line_pitch = 305;
pub const str_change_res_horz = 306;
pub const str_change_res_vert = 307;
pub const str_define_char = 308;
pub const str_enter_doublewide_mode = 309;
pub const str_enter_draft_quality = 310;
pub const str_enter_italics_mode = 311;
pub const str_enter_leftward_mode = 312;
pub const str_enter_micro_mode = 313;
pub const str_enter_near_letter_quality = 314;
pub const str_enter_normal_quality = 315;
pub const str_enter_shadow_mode = 316;
pub const str_enter_subscript_mode = 317;
pub const str_enter_superscript_mode = 318;
pub const str_enter_upward_mode = 319;
pub const str_exit_doublewide_mode = 320;
pub const str_exit_italics_mode = 321;
pub const str_exit_leftward_mode = 322;
pub const str_exit_micro_mode = 323;
pub const str_exit_shadow_mode = 324;
pub const str_exit_subscript_mode = 325;
pub const str_exit_superscript_mode = 326;
pub const str_exit_upward_mode = 327;
pub const str_micro_column_address = 328;
pub const str_micro_down = 329;
pub const str_micro_left = 330;
pub const str_micro_right = 331;
pub const str_micro_row_address = 332;
pub const str_micro_up = 333;
pub const str_order_of_pins = 334;
pub const str_parm_down_micro = 335;
pub const str_parm_left_micro = 336;
pub const str_parm_right_micro = 337;
pub const str_parm_up_micro = 338;
pub const str_select_char_set = 339;
pub const str_set_bottom_margin = 340;
pub const str_set_bottom_margin_parm = 341;
pub const str_set_left_margin_parm = 342;
pub const str_set_right_margin_parm = 343;
pub const str_set_top_margin = 344;
pub const str_set_top_margin_parm = 345;
pub const str_start_bit_image = 346;
pub const str_start_char_set_def = 347;
pub const str_stop_bit_image = 348;
pub const str_stop_char_set_def = 349;
pub const str_subscript_characters = 350;
pub const str_superscript_characters = 351;
pub const str_these_cause_cr = 352;
pub const str_zero_motion = 353;
pub const str_char_set_names = 354;
pub const str_key_mouse = 355;
pub const str_mouse_info = 356;
pub const str_req_mouse_pos = 357;
pub const str_get_mouse = 358;
pub const str_set_a_foreground = 359;
pub const str_set_a_background = 360;
pub const str_pkey_plab = 361;
pub const str_device_type = 362;
pub const str_code_set_init = 363;
pub const str_set0_des_seq = 364;
pub const str_set1_des_seq = 365;
pub const str_set2_des_seq = 366;
pub const str_set3_des_seq = 367;
pub const str_set_lr_margin = 368;
pub const str_set_tb_margin = 369;
pub const str_bit_image_repeat = 370;
pub const str_bit_image_newline = 371;
pub const str_bit_image_carriage_return = 372;
pub const str_color_names = 373;
pub const str_define_bit_image_region = 374;
pub const str_end_bit_image_region = 375;
pub const str_set_color_band = 376;
pub const str_set_page_length = 377;
pub const str_display_pc_char = 378;
pub const str_enter_pc_charset_mode = 379;
pub const str_exit_pc_charset_mode = 380;
pub const str_enter_scancode_mode = 381;
pub const str_exit_scancode_mode = 382;
pub const str_pc_term_options = 383;
pub const str_scancode_escape = 384;
pub const str_alt_scancode_esc = 385;
pub const str_enter_horizontal_hl_mode = 386;
pub const str_enter_left_hl_mode = 387;
pub const str_enter_low_hl_mode = 388;
pub const str_enter_right_hl_mode = 389;
pub const str_enter_top_hl_mode = 390;
pub const str_enter_vertical_hl_mode = 391;
pub const str_set_a_attributes = 392;
pub const str_set_pglen_inch = 393;
