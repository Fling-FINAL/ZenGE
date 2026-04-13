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
    .a = 255,
} };

const shpP: *ZEN_Shape = @constCast(&shp);

var col: ZEN_Shape = ZEN_Shape{ .rect = .{
    .x = 100,
    .y = 100,
    .w = 200,
    .h = 90,
    .r = 0,
    .g = 0,
    .b = 50,
    .a = 255,
} };

const colP: *ZEN_Shape = @constCast(&col);

var floor: ZEN_Shape = ZEN_Shape{ .rect = .{
    .x = -20,
    .y = 450,
    .w = 540,
    .h = 60,
    .r = 200,
    .g = 110,
    .b = 0,
    .a = 255,
} };

const floorP: *ZEN_Shape = @constCast(&floor);

var dx: f32 = 0;
var dy: f32 = 0;

fn moveL() bool {
    dx -= 1;
    return true;
}
fn moveR() bool {
    dx += 1;
    return true;
}
fn moveU() bool {
    dy -= 1;
    return true;
}
fn moveD() bool {
    dy += 1;
    return true;
}

fn resolveCol(ts: *ZEN_Shape, tt: *ZEN_Shape, slip: f32) void {
    const mtv = ts.rect.getMTV(@constCast(&tt.rect));

    if (@abs(mtv[0]) < slip and @abs(mtv[1]) < slip) {
        if (@abs(mtv[0]) < @abs(mtv[1])) {
            ts.rect.x -= mtv[0];
        } else ts.rect.y -= mtv[1];
    }

    if (@abs(mtv[0]) < @abs(mtv[1])) {
        if (@abs(mtv[1]) > slip) {
            ts.rect.x -= mtv[0];
        } else ts.rect.y -= mtv[1];
    } else {
        if (@abs(mtv[0]) > slip) {
            ts.rect.y -= mtv[1];
        } else ts.rect.x -= mtv[0];
    }
}

fn move() bool {
    const mag: f32 = std.math.sqrt(std.math.pow(f32, dx, 2) + std.math.pow(f32, dy, 2));
    const spd: i32 = 5;
    if (mag != 0) {
        shp.rect.x += ((spd * dx) / mag);
        shp.rect.y += ((spd * dy) / mag);
    }

    resolveCol(shpP, colP, 10);
    resolveCol(shpP, floorP, 0);

    dx = 0;
    dy = 0;
    return true;
}

pub fn ctm_fill(alloc: std.mem.Allocator) !*Scene {
    var lst = eng.getEmptyProcessList();

    lst[@intCast(@intFromEnum(eng.Triggers.zuACTION_POSTUPDATE))] =
        eng.mkSmplProcess(
            &move,
            &move,
        );

    lst[@intCast(@intFromEnum(eng.Triggers.zuKEY_W))] =
        eng.mkSmplProcess(
            &moveU,
            &eng.smpFiller,
        );
    lst[@intCast(@intFromEnum(eng.Triggers.zuKEY_A))] =
        eng.mkSmplProcess(
            &moveL,
            &eng.smpFiller,
        );
    lst[@intCast(@intFromEnum(eng.Triggers.zuKEY_S))] =
        eng.mkSmplProcess(
            &moveD,
            &eng.smpFiller,
        );
    lst[@intCast(@intFromEnum(eng.Triggers.zuKEY_D))] =
        eng.mkSmplProcess(
            &moveR,
            &eng.smpFiller,
        );

    return Scene.init(alloc, @constCast(&[_]*ZEN_Shape{ colP, shpP, floorP }), lst);
}
