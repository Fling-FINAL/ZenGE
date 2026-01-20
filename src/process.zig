const std = @import("std");

pub const Process = struct {
    running: fn () void,
    endWhen: fn (forceClose: bool) bool,
    deinit: fn (alloc: std.mem.Allocator) void,
};
