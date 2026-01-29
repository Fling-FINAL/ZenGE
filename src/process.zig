const std = @import("std");
const eng = @import("eng");

pub const Process = struct {
    activator: *eng.Triggers,
    timeHeld: i32,

    onPress: *fn (scene: *eng.Scene) void,
    onRelease: *fn (scene: *eng.Scene) void,
    onHeld: *fn (scene: *eng.Scene) void,
    endWhen: *fn (scene: *eng.Scene, forceClose: bool) bool,
    deinitFunc: *fn (alloc: std.mem.Allocator) void,

    pub fn init(eActivator: *eng.Triggers, eOnPress: *fn (scene: *eng.Scene) void, eOnRelease: *fn (scene: *eng.Scene) void, eOnHeld: *fn (scene: *eng.Scene) void, eEndWhen: *fn (scene: *eng.Scene, forceClose: bool) bool, eDeinit: *fn (scene: *eng.Scene, alloc: std.mem.Allocator) void) Process {
        return .{
            .activator = eActivator,
            .timeHeld = 0,

            .onHeld = eOnHeld,
            .onPress = eOnPress,
            .onRelease = eOnRelease,

            .endWhen = eEndWhen,
            .deinit = eDeinit,
        };
    }

    pub fn deinit(self: *Process, alloc: std.mem.Allocator) void {
        self.deinitFunc(alloc);
    }

    pub fn update(self: Process, scene: *eng.Scene, pressed: bool, forceClose: bool) bool {
        if (pressed) {
            self.timeHeld += 1;
            self.onHeld(scene);
        }

        if (self.timeHeld == 1)
            self.onPress(scene);

        if (!pressed and self.timeHeld != 0)
            self.onRelease(scene);

        if (!pressed)
            self.timeHeld = 0;

        const ret: bool = self.endWhen(scene, forceClose);

        return ret;
    }
};
