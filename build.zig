const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const build_lib = b.option(bool, "build-static", "Build a static library") orelse false;

    if (build_lib) {
        const lib = b.addStaticLibrary(.{
            .name = "zigcurses",
            .root_source_file = .{ .path = "src/curses.zig" },
            .target = target,
            .optimize = optimize,
        });

        b.installArtifact(lib);
    }

    const lib_module = b.addModule("zigcurses", .{
        .source_file = .{ .path = "src/curses.zig" },
    });

    b.modules.put("curses", lib_module) catch unreachable;

    const build_tools = b.option(bool, "build-tools", "Build the utilities") orelse true;

    if (build_tools) {
        const exe = b.addExecutable(.{
            .name = "dump-tinfo",
            .root_source_file = .{ .path = "tools/dump-tinfo.zig" },
            .target = target,
            .optimize = optimize,
        });

        exe.addModule("curses", lib_module);

        const options = b.addOptions();
        options.addOption([]const u8, "version", "0.0.1");
        exe.addOptions("config", options);

        b.installArtifact(exe);
    }

    const demo = b.addExecutable(.{
        .name = "demo",
        .root_source_file = .{ .path = "demo/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    demo.addModule("curses", lib_module);
    b.installArtifact(demo);

    const run_cmd = b.addRunArtifact(demo);

    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    const unit_tests = b.addTest(.{
        .root_source_file = .{ .path = "src/curses.zig" },
        .target = target,
        .optimize = optimize,
    });

    const run_unit_tests = b.addRunArtifact(unit_tests);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_unit_tests.step);
}
