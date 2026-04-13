const std = @import("std");
const eng = @import("eng.zig");

const sdl = eng.sdl;
const ZEN_Shape = eng.ZEN_Shape;
const Process = eng.Process;

pub const Scene = struct {
    allocator: std.mem.Allocator,
    shapes: []*ZEN_Shape,
    processes: [@intCast(@intFromEnum(eng.Triggers.zuFINAL))]?*Process,
    held: [@intCast(@intFromEnum(eng.Triggers.zuFINAL))]u32 = [_]u32{0} ** @intFromEnum(eng.Triggers.zuFINAL),
    pub fn init(allocator: std.mem.Allocator, shapes: []*ZEN_Shape, processes: [@intCast(@intFromEnum(eng.Triggers.zuFINAL))]?*Process) *Scene {
        const sce: Scene = .{
            .shapes = shapes,
            .processes = processes,
            .allocator = allocator,
        };
        return @constCast(&sce);
    }
    pub fn appendProcess(self: *Scene, item: *Process, trig: eng.Triggers) !void {
        self.processes[@intFromEnum(trig)] = item;
    }
    pub inline fn runP(self: *Scene, dt: u32, trig: eng.Triggers, st: bool) bool {
        if (st) {
            return runPAsT(self, dt, trig);
        }
        return runPAsF(self, dt, trig);
    }
    pub fn runPAsT(self: *Scene, dt: u32, trig: eng.Triggers) bool {
        @setEvalBranchQuota(5200);
        switch (@intFromEnum(trig)) {
            inline 0...(@intFromEnum(eng.Triggers.zuFINAL) - 1) => |val| {
                if (self.processes[val]) |pro| {
                    return pro.open(dt, self);
                }
            },
            else => {
                return false;
            },
        }
        return false;
    }

    pub fn runPAsF(self: *Scene, dt: u32, trig: eng.Triggers) bool {
        @setEvalBranchQuota(5200);
        switch (@intFromEnum(trig)) {
            inline 0...(@intFromEnum(eng.Triggers.zuFINAL) - 1) => |val| {
                if (self.processes[val]) |pro| {
                    return pro.shut(dt, self);
                }
            },
            else => {
                return false;
            },
        }
        return false;
    }
    pub fn deinit(self: *Scene) !void {
        for (self.processes) |pro| {
            for (self.processes.items) |pr| {
                pr.deinit(self.allocator);
            }
            pro.deinit(self.allocator);
        }
        self.shapes.deinit(self.allocator);
    }
};

var trigs: [@intFromEnum(eng.Triggers.zuFINAL)]bool = [_]bool{false} ** (@intFromEnum(eng.Triggers.zuFINAL));

pub const SceneHandler = struct {
    act: *Scene,
    pub fn init(sce: *Scene) SceneHandler {
        return .{
            .act = sce,
        };
    }
    pub fn runProcesses(self: *SceneHandler, dt: u32) bool {
        var ret: bool = true;
        @setEvalBranchQuota(5200);
        //        inline for (@typeInfo(eng.Triggers).@"enum".fields) |i| {
        //            const t: eng.Triggers = @enumFromInt(i.value);
        //            switch (t) {
        //                .zuACTION_PRERENDER, .zuACTION_PREUPDATE, .zuACTION_POSTUPDATE, .zuACTION_POSTRENDER => {},
        //                inline else => |m| {
        //                    if (trigs[@intFromEnum(m)]) {
        //                        ret = ret and self.act.runPAsT(dt, m);
        //                    } else {
        //                        ret = ret and self.act.runPAsF(dt, m);
        //                    }
        //                },
        //            }
        //        }
        const ign = std.enums.EnumSet(eng.Triggers).init(.{
            .zuACTION_PRERENDER = true,
            .zuACTION_PREUPDATE = true,
            .zuACTION_POSTUPDATE = true,
            .zuACTION_POSTRENDER = true,
        });

        inline for (std.meta.fields(eng.Triggers)) |ti| {
            if (ti.value == trigs.len) continue;
            const t: eng.Triggers = @enumFromInt(ti.value);
            var re: bool = true;
            if (!ign.contains(t)) {
                if (trigs[ti.value]) {
                    re = self.act.runPAsT(dt, t);
                } else {
                    re = self.act.runPAsF(dt, t);
                }
            }
            ret = ret and re;
        }

        return ret;
    }
    pub fn updateTrigs(self: *SceneHandler, keys: [*c]const u8, specials: []eng.Triggers, dt: u32) void {
        _ = self.act.runPAsT(dt, eng.Triggers.zuACTION_PREUPDATE);
        trigs = [_]bool{false} ** (@intFromEnum(eng.Triggers.zuFINAL));
        for (0..@intFromEnum(eng.Triggers.zuKEY_FINAL) - eng.zuKEY_BASE) |i| {
            trigs[eng.zuKEY_BASE + i] = (keys[i] == 1);
        }
        for (specials) |pos| {
            trigs[@intFromEnum(pos)] = true;
        }
        _ = self.runProcesses(dt);
        _ = self.act.runPAsT(dt, eng.Triggers.zuACTION_POSTUPDATE);
    }
    pub fn renderAll(self: *SceneHandler, renderer: *sdl.SDL_Renderer, dt: u32) !void {
        _ = self.act.runPAsT(dt, eng.Triggers.zuACTION_PRERENDER);

        for (self.act.shapes) |obj| {
            try obj.render(renderer);
        }
        _ = self.act.runPAsT(dt, eng.Triggers.zuACTION_POSTRENDER);
    }
};
