const std = @import("std");

const eng = @import("eng");
const Scene = eng.Scene;
const ZEN_Shape = eng.ZEN_Shape;
const Process = eng.Process;

var shp: ZEN_Shape = ZEN_Shape{ .rect = .{
    .x = 100,
    .y = 20,
    .w = 50,
    .h = 50,
    .r = 100,
    .g = 30,
    .b = 50,
} };

const shpP: *ZEN_Shape = @constCast(&shp);

const colliders = [_]*ZEN_Shape{
    @constCast(&ZEN_Shape{ .rect = .{
        .x = 20,
        .y = 450,
        .w = 460,
        .h = 90,
        .b = 50,
    } }),
    @constCast(&ZEN_Shape{ .rect = .{
        .x = 100,
        .y = 100,
        .w = 200,
        .h = 90,
        .b = 50,
    } }),
    @constCast(&ZEN_Shape{ .rect = .{
        .x = 10,
        .y = 1000,
        .w = 1460,
        .h = 150,
        .b = 50,
    } }),
    @constCast(&ZEN_Shape{ .rect = .{
        .x = 535,
        .y = 760,
        .w = 400,
        .h = 50,
        .b = 50,
    } }),
    @constCast(&ZEN_Shape{ .rect = .{
        .x = 555,
        .y = 660,
        .w = 360,
        .h = 50,
        .b = 50,
    } }),
    @constCast(&ZEN_Shape{ .rect = .{
        .x = 1500,
        .y = 570,
        .w = 150,
        .h = 460,
        .b = 50,
    } }),
    @constCast(&ZEN_Shape{ .rect = .{
        .x = -1800,
        .y = 990,
        .w = 1500,
        .h = 120,
        .b = 50,
    } }),
};

const grav: f32 = 5;

var vx: f32 = 0;
var vy: f32 = 0;

var hSpd: f32 = 15;
var spdOvide: bool = false;

var jumpFrames: u32 = 0;
const jumpMax: u32 = 15;

var canJump: u32 = 0;
const jumpLatency: u32 = 3;

var jumpHeld: bool = false;

fn moveL() bool {
    vx += -1;
    return true;
}

fn moveR() bool {
    vx += 1;
    return true;
}

fn sprint() bool {
    hSpd = 20;
    spdOvide = true;
    return true;
}

fn slow() bool {
    spdOvide = true;
    hSpd = 10;
    return true;
}

fn normalSpd() bool {
    if (!spdOvide)
        hSpd = 15;
    spdOvide = false;
    return true;
}

fn respawn() bool {
    shp.rect.x = 100;
    vy = 0;
    vx = 0;
    shp.rect.y = 20;
    return true;
}

fn jump() bool {
    if (!jumpHeld and jumpFrames == jumpMax and canJump != 0) {
        vy = -50;
        jumpFrames -= 1;
        jumpHeld = true;
    } else if (jumpFrames > 0) {
        vy -= grav / 2;
        jumpFrames -= 1;
    }
    return true;
}

fn notJump() bool {
    jumpHeld = false;
    if (jumpFrames != jumpMax and jumpFrames != 0) {
        vy = 0;
    }
    if (jumpFrames != jumpMax)
        jumpFrames = 0;
    return true;
}

fn resolveCol(ts: *ZEN_Shape, tt: *ZEN_Shape, slipx: f32, slipy: f32) bool {
    const mtv = ts.rect.getMTV(@constCast(&tt.rect));

    if (@abs(mtv[0]) < 0.1 and @abs(mtv[1]) < 0.1)
        return false;

    if (@abs(mtv[0]) < slipx and @abs(mtv[1]) < slipy) {
        if (@abs(mtv[0]) < @abs(mtv[1])) {
            ts.rect.x -= mtv[0];
        } else {
            ts.rect.y -= mtv[1];
            if (@abs(traceDownRect(shpP, tt)) < 0.1 and !jumpHeld) {
                canJump = jumpLatency;
                jumpFrames = jumpMax;
            }

            if ((vy > 0 and @abs(traceDownRect(shpP, tt)) < 0.1)) {
                vy = 0;
            }
            if ((vy < 0 and @abs(traceUpRect(shpP, tt)) < 0.1)) {
                vy = 0;
                jumpFrames = 0;
            }
        }
    }

    if (@abs(mtv[0]) < @abs(mtv[1])) {
        if (@abs(mtv[1]) > slipy) {
            ts.rect.x -= mtv[0];
        } else {
            ts.rect.y -= mtv[1];
            if (@abs(traceDownRect(shpP, tt)) < 0.1 and !jumpHeld) {
                canJump = jumpLatency;
                jumpFrames = jumpMax;
            }

            if ((vy > 0 and @abs(traceDownRect(shpP, tt)) < 0.1)) {
                vy = 0;
            }
            if ((vy < 0 and @abs(traceUpRect(shpP, tt)) < 0.1)) {
                vy = 0;
                jumpFrames = 0;
            }
        }
    } else {
        if (@abs(mtv[0]) > slipx) {
            ts.rect.y -= mtv[1];
            if (vy > 0 and @abs(traceDownRect(shpP, tt)) < 0.1 and !jumpHeld) {
                canJump = jumpLatency;
                jumpFrames = jumpMax;
            }
            if ((vy > 0 and @abs(traceDownRect(shpP, tt)) < 0.1)) {
                vy = 0;
            }
            if ((vy < 0 and @abs(traceUpRect(shpP, tt)) < 0.1)) {
                vy = 0;
                jumpFrames = 0;
            }
        } else ts.rect.x -= mtv[0];
    }
    return true;
}

var shift: f32 = 0;

fn center() bool {
    shift = (@as(f32, @floatFromInt(eng.windowW)) / 2) - (shp.rect.x + shp.rect.w / 2);
    shp.rect.x += shift;
    for (colliders) |co| {
        co.rect.x += shift;
    }
    return true;
}

fn deCenter() bool {
    shp.rect.x -= shift;
    for (colliders) |co| {
        co.rect.x -= shift;
    }
    return true;
}

fn traceDownRect(ts: *ZEN_Shape, tt: *ZEN_Shape) f32 {
    if (tt.rect.x + tt.rect.w < ts.rect.x or tt.rect.x > ts.rect.x + ts.rect.w)
        return std.math.floatMax(f32);
    return (tt.rect.y) - (ts.rect.y + ts.rect.h);
}

fn traceUpRect(ts: *ZEN_Shape, tt: *ZEN_Shape) f32 {
    if (tt.rect.x + tt.rect.w < ts.rect.x or tt.rect.x > ts.rect.x + ts.rect.w)
        return std.math.floatMax(f32);
    return (ts.rect.y) - (tt.rect.y + tt.rect.h);
}

fn move() bool {
    shp.rect.x += hSpd * std.math.clamp(vx, -1, 1);
    vx = 0;

    if (canJump != 0)
        canJump -= 1;
    vy += grav;
    vy = std.math.clamp(vy, -50.0, 50.0);

    var dec: f32 = @abs(vy);

    while (dec > 0) {
        shp.rect.y += std.math.sign(vy);
        dec -= 1;
        for (colliders) |co|
            _ = resolveCol(shpP, co, 0, 5);
    }
    return true;
}

pub fn ctm_fill(alloc: std.mem.Allocator) !*Scene {
    var lst = eng.getEmptyProcessList();

    lst[@intCast(@intFromEnum(eng.Triggers.zuACTION_POSTUPDATE))] =
        eng.mkSmplProcess(
            &move,
            &move,
        );

    lst[@intCast(@intFromEnum(eng.Triggers.zuKEY_SPACE))] =
        eng.mkSmplProcess(
            &jump,
            &notJump,
        );
    lst[@intCast(@intFromEnum(eng.Triggers.zuKEY_A))] =
        eng.mkSmplProcess(
            &moveL,
            &eng.smpFiller,
        );
    lst[@intCast(@intFromEnum(eng.Triggers.zuKEY_LEFT))] =
        eng.mkSmplProcess(
            &moveL,
            &eng.smpFiller,
        );
    lst[@intCast(@intFromEnum(eng.Triggers.zuKEY_D))] =
        eng.mkSmplProcess(
            &moveR,
            &eng.smpFiller,
        );
    lst[@intCast(@intFromEnum(eng.Triggers.zuKEY_RIGHT))] =
        eng.mkSmplProcess(
            &moveR,
            &eng.smpFiller,
        );
    lst[@intCast(@intFromEnum(eng.Triggers.zuKEY_LSHIFT))] =
        eng.mkSmplProcess(
            &sprint,
            &normalSpd,
        );
    lst[@intCast(@intFromEnum(eng.Triggers.zuKEY_LCTRL))] =
        eng.mkSmplProcess(
            &slow,
            &normalSpd,
        );
    lst[@intCast(@intFromEnum(eng.Triggers.zuKEY_R))] =
        eng.mkSmplProcess(
            &respawn,
            &eng.smpFiller,
        );
    lst[@intCast(@intFromEnum(eng.Triggers.zuACTION_PRERENDER))] =
        eng.mkSmplProcess(
            &center,
            &eng.smpFiller,
        );
    lst[@intCast(@intFromEnum(eng.Triggers.zuACTION_POSTRENDER))] =
        eng.mkSmplProcess(
            &deCenter,
            &eng.smpFiller,
        );

    return Scene.init(alloc, @constCast(&([_]*ZEN_Shape{shpP} ++ colliders)), lst);
}
