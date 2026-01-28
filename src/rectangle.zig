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
    pub fn toSDL(self: *ZEN_Rect) sdl.SDL_Rect {
        return sdl.SDL_Rect{
            .x = @intFromFloat(@trunc(self.x + 0.5)),
            .y = @intFromFloat(@trunc(self.y + 0.5)),
            .w = @intFromFloat(@trunc(self.w + 0.5)),
            .h = @intFromFloat(@trunc(self.h + 0.5)),
        };
    }

    //
    pub fn setColor(self: *ZEN_Rect, renderer: *sdl.SDL_Renderer) !void {
        sdl.SDL_SetRenderDrawColor(renderer, self.r, self.g, self.b, self.a);
    }

    // render the ZEN_Rect by treating as an SDL_Rect
    pub fn render(self: *ZEN_Rect, renderer: *sdl.SDL_Renderer) !void {
        const rect = self.toSDL();
        _ = try sdl.SDL_RenderFillRect(renderer, &rect);
    }
};

/// internal struct to organize and use ZEN_Rects for rendering, basic utility functions, and other fundamental operations
pub const ZEN_Object = struct {
    collisionRect: ZEN_Rect,
    renderRects: std.ArrayList(*ZEN_Rect),
    allocator: std.mem.Allocator,

    pub fn init(allocator: std.mem.Allocator, collision: ZEN_Rect) ZEN_Object {
        return .{
            .allocator = allocator,
            .collisionRect = collision,
            .renderRects = std.ArrayList(*ZEN_Rect).init(allocator),
        };
    }

    pub fn deinit(self: *ZEN_Object) void {
        self.renderRects.deinit();
    }

    pub fn addRenderRect(self: *ZEN_Object, rect: *ZEN_Rect) !void {
        try self.renderRects.append(self.allocator, rect);
    }

    fn renderLayerLessThan(_: void, a: *ZEN_Rect, b: *ZEN_Rect) bool {
        return a.renderLayer < b.renderLayer;
    }

    pub fn render(self: *ZEN_Object, renderer: *sdl.SDL_Renderer) !void {
        std.sort.sort(ZEN_Rect, self.renderRects.items, {}, renderLayerLessThan);

        for (self.renderRects.items) |rect| {
            rect.setColor(renderer);
            rect.render(renderer);
        }
    }
};
