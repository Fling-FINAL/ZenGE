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
        .root_source_file = b.path("config/fileLoader.zig"),
    });

    const engMod = b.createModule(.{
        .root_source_file = b.path("src/eng.zig"),
    });

    // Add engine to executable
    exe.root_module.addImport("eng", engMod);

    // Add config modules to executable
    exe.root_module.addImport("config", confMod);
    exe.root_module.addImport("fileLoader", fileLoaderMod);

    fileLoaderMod.addImport("eng", engMod);

    engMod.addImport("config", confMod);
    engMod.addImport("fileLoader", fileLoaderMod);
    engMod.addIncludePath(b.path("libs/SDL2/include"));

    // SDL2 linking
    exe.addIncludePath(b.path("libs/SDL2/include"));
    exe.addLibraryPath(b.path("libs/SDL2/lib"));
    exe.linkSystemLibrary("user32");
    exe.linkSystemLibrary("gdi32");
    exe.linkSystemLibrary("winmm");
    exe.linkSystemLibrary("imm32");
    exe.linkSystemLibrary("ole32");
    exe.linkSystemLibrary("oleaut32");
    exe.linkSystemLibrary("version");
    exe.linkSystemLibrary("setupapi");
    exe.linkSystemLibrary("shell32");
    exe.linkSystemLibrary("advapi32");
    exe.linkSystemLibrary("shlwapi");
    exe.linkSystemLibrary("SDL2");
    exe.linkSystemLibrary("SDL2main");
    exe.linkLibC();

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    const run_step = b.step("run", "Run the program");
    run_step.dependOn(&run_cmd.step);
}
