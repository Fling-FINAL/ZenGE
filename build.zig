const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "ZENGE",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });

    const confMod = b.createModule(.{
        .root_source_file = b.path("config/config.zig"),
    });

    const fileLoaderMod = b.createModule(.{
        .root_source_file = b.path("config/fileloader.zig"),
    });

    const engMod = b.createModule(.{
        .root_source_file = b.path("src/eng.zig"),
    });

    // Add engine to executable
    exe.root_module.addImport("eng", engMod);

    // Add config modules to executable
    exe.root_module.addImport("config", confMod);
    exe.root_module.addImport("fileloader", fileLoaderMod);

    fileLoaderMod.addImport("eng", engMod);

    engMod.addImport("config", confMod);
    engMod.addImport("fileloader", fileLoaderMod);

    // SDL2 linking
    exe.linkSystemLibrary("SDL2");
    exe.linkSystemLibrary("SDL2_ttf");
    exe.linkSystemLibrary("SDL2_gfx");
    exe.linkSystemLibrary("SDL2main");
    exe.linkSystemLibrary("m");
    exe.linkLibC();

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    const run_step = b.step("run", "Run the program");
    run_step.dependOn(&run_cmd.step);
}
