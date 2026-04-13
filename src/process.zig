const std = @import("std");
const eng = @import("eng.zig");

const Scene = eng.Scene;

pub const ProcessVTable = struct {
    open: *const fn (self: *AnyProcess, dt: u32, ctx: *Scene) bool,
    shut: *const fn (self: *AnyProcess, dt: u32, ctx: *Scene) bool,
    deinit: *const fn (self: *AnyProcess, alloc: std.mem.Allocator) bool,
};

pub const AnyProcess = struct {
    ctm: *anyopaque,
    pvt: *const ProcessVTable,
    ctmT: type,
    pub fn Wrap(comptime T: type) type {
        return struct { val: T };
    }
    pub fn makeCtm(comptime T: type, init_val: T, allocator: std.mem.Allocator) !*anyopaque {
        const s = try allocator.create(T);
        s.* = init_val;
        return s;
    }
    pub fn open(self: *AnyProcess, dt: u32, ctx: *Scene) bool {
        return self.pvt.open(self, dt, ctx);
    }
    pub fn shut(self: *AnyProcess, dt: u32, ctx: *Scene) bool {
        return self.pvt.shut(self, dt, ctx);
    }
    pub fn deinit(self: *AnyProcess, alloc: std.mem.Allocator) bool {
        return self.pvt.deinit(self, alloc);
    }
};

pub fn makeProcess(comptime T: type, comptime pvt: *const ProcessVTable, comptime init: *const fn () *T) *AnyProcess {
    const ctm = init();
    return @constCast(&AnyProcess{
        .ctm = ctm,
        .pvt = pvt,
        .ctmT = T,
    });
}

pub fn makeSimpleProcess(comptime open: *const fn () bool, comptime shut: *const fn () bool) *AnyProcess {
    const fnholder = struct {
        fn openfn(self: *AnyProcess, dt: u32, ctx: *Scene) bool {
            _ = self;
            _ = dt;
            _ = ctx;
            return open();
        }
        fn shutfn(self: *AnyProcess, dt: u32, ctx: *Scene) bool {
            _ = self;
            _ = dt;
            _ = ctx;
            return shut();
        }
    };

    return makeProcess(void, &.{
        .open = &fnholder.openfn,
        .shut = &fnholder.shutfn,
        .deinit = &eng.noDeinit,
    }, &eng.voidCtm);
}
