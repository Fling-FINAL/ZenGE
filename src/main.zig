const std = @import("std");
const builtin = @import("builtin");

const eng = @import("eng");
const c = eng.sdl;
const fl = eng.fileLoader;

const Scene = eng.Scene;
const SceneHandler = eng.SceneHandler;

pub fn main() !void {
    if (c.SDL_Init(c.SDL_INIT_VIDEO) != 0) {
        std.debug.print("SDL_Init error, {s}", .{c.SDL_GetError()});
        return;
    }
    defer _ = c.SDL_Quit();

    if (c.TTF_Init() != 0) {
        std.debug.print("TTF_Init error, {s}", .{c.TTF_GetError()});
        return;
    }
    defer _ = c.TTF_Quit();

    const window = c.SDL_CreateWindow(
        eng.windowName.ptr,
        @intCast(eng.windowX),
        @intCast(eng.windowY),
        @intCast(eng.windowW),
        @intCast(eng.windowH),
        @intCast(eng.windowFlags),
    );
    if (window == null) {
        std.debug.print("SDL_CreateWindow error, {s}", .{c.SDL_GetError()});
        return;
    }
    defer _ = c.SDL_DestroyWindow(window);

    const renderer = c.SDL_CreateRenderer(window, -1, c.SDL_RENDERER_ACCELERATED);
    if (renderer == null) {
        std.debug.print("SDL_CreateRenderer error, {s}", .{c.SDL_GetError()});
        return;
    }
    defer _ = c.SDL_DestroyRenderer(renderer);

    const alloc = std.heap.page_allocator;

    const sce = try fl(alloc);

    const schnd: *SceneHandler = @constCast(&SceneHandler.init(sce));

    var event: c.SDL_Event = undefined;
    var running: bool = true;

    const stateC = c.SDL_GetKeyboardState(null);

    const bgR: c_int = @intCast(eng.bgR);
    const bgG: c_int = @intCast(eng.bgG);
    const bgB: c_int = @intCast(eng.bgB);

    while (running) {
        while (c.SDL_PollEvent(&event) != 0) {
            switch (event.type) {
                c.SDL_QUIT => running = false,
                else => {},
            }
        }
        // set bg
        _ = c.SDL_SetRenderDrawColor(renderer.?, bgR, bgG, bgB, 255);
        _ = c.SDL_RenderClear(renderer.?);

        schnd.updateTrigs(stateC, &.{}, 32);
        try schnd.renderAll(renderer.?, 32);

        _ = c.SDL_RenderPresent(renderer.?);
        _ = c.SDL_Delay(32);
    }
}
