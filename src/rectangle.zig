const std = @import("std");
const eng = @import("eng");

const sdl = eng.sdl;

// rectangle object, never render something without this
// has some basic utility functions and can be transformed to an SDL_Rect
pub const ZEN_Rect = struct {
    x: f32, // x position, in px
    y: f32, // y position, in px
    w: f32, // width, in px
    h: f32, // height, in px

    // transform from ZEN_Rect to SDL_Rect, primarily for rendering or to access SDL functions
    pub fn toSDL(self: ZEN_Rect) sdl.SDL_Rect {
        return sdl.SDL_Rect{
            .x = @intFromFloat(@trunc(self.x + 0.5)),
            .y = @intFromFloat(@trunc(self.y + 0.5)),
            .w = @intFromFloat(@trunc(self.w + 0.5)),
            .h = @intFromFloat(@trunc(self.h + 0.5)),
        };
    }

    //
    pub fn render(self: ZEN_Rect, renderer: sdl.SDL_Renderer) void {
        const rect = self.asRect();
        _ = sdl.SDL_RenderFillRect(renderer, &rect);
    }
};
