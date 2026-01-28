const std = @import("std");
const eng = @import("eng");

const sdl = eng.sdl;

/// rectangle object, never render something without this
/// has some basic utility functions and can be transformed to an SDL_Rect
pub const ZEN_Rect = struct {
    x: f32, // x position, in px
    y: f32, // y position, in px
    w: f32, // width, in px
    h: f32, // height, in px

    r: u8, // red value, used by ZEN_Object
    g: u8, // green value, used by ZEN_Object
    b: u8, // blue value, used by ZEN_Object
    a: u8, // transparency, used by ZEN_Object

    renderLayer: u32, // used by ZEN_Object for determining the order rects are rendered in

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
    pub fn setColor(self: ZEN_Rect, renderer: *sdl.SDL_Renderer) !void {
        renderer.setColor(.{ self.r, self.g, self.b, self.a });
    }

    // render the ZEN_Rect by treating as an SDL_Rect
    pub fn render(self: ZEN_Rect, renderer: *sdl.SDL_Renderer) !void {
        const rect = self.asRect();
        _ = try sdl.SDL_RenderFillRect(renderer, &rect);
    }
};

/// internal struct to organize and use ZEN_Rects for rendering, basic utility functions, and other fundamental operations
pub const ZEN_Object = struct {
    collisionRect: ZEN_Rect,
    renderRects: std.ArrayList(ZEN_Rect),

    fn sortFn(self: ZEN_Object, iS: usize, iE: usize) void {
        const arr = self.renderRects[iS..iE];
        if (arr.len <= 1) return;

        const mid = @trunc((iS + iE) / 2);

        self.sortFn(iS, mid);
        self.sortFn(mid, iE);

        // Merge step
        var left: usize = iS;
        var right: usize = mid;
        var out: usize = 0;

        // Temporary buffer
        var temp = try self.allocator.alloc(@TypeOf(self.renderRects[0]), iE - iS);
        defer self.allocator.free(temp);

        // Merge both halves
        while (left < mid and right < iE) {
            if (self.renderRects[left] <= self.renderRects[right]) {
                temp[out] = self.renderRects[left];
                left += 1;
            } else {
                temp[out] = self.renderRects[right];
                right += 1;
            }
            out += 1;
        }

        // Copy remaining left half
        while (left < mid) {
            temp[out] = self.renderRects[left];
            left += 1;
            out += 1;
        }

        // Copy remaining right half
        while (right < iE) {
            temp[out] = self.renderRects[right];
            right += 1;
            out += 1;
        }

        // Copy merged result back into original array
        @memcpy(self.renderRects[iS..iE], temp);
    }

    pub fn render(self: ZEN_Object, renderer: sdl.SDL_Renderer) !void {
        sortFn(self, 0, self.renderRects.items.len);
        for (self.renderRects.items) |rect| {
            rect.setColor(&renderer);
            rect.render(&renderer);
        }
    }
};
