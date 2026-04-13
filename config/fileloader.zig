const std = @import("std");

const eng = @import("eng");
const targ = eng.target;

pub fn fillScene(alloc: std.mem.Allocator) !*eng.Scene {
    if (std.mem.eql(u8, targ, "projtest")) {
        return try @import("projects/projtest/CTM_M.zig").ctm_fill(alloc);
    }
    if (std.mem.eql(u8, targ, "projtest2")) {
        return try @import("projects/projtest2/CTM_M.zig").ctm_fill(alloc);
    }

    //marker comment
    @panic("register the project");
}
