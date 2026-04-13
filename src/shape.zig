const std = @import("std");
const eng = @import("eng.zig");

const sdl = eng.sdl;

// TODO: implement collision and render logic for ZEN_Shape objects and add a way for ZEN_Object to use a texture

/// rectangle object, never render something without this
/// has some basic utility functions and can be transformed to an SDL_Rect
pub const ZEN_Rect = struct {
    x: f32, // x position, in px
    y: f32, // y position, in px
    w: f32, // width, in px
    h: f32, // height, in px

    r: u8 = 0, // red value, used by ZEN_Object
    g: u8 = 0, // green value, used by ZEN_Object
    b: u8 = 0, // blue value, used by ZEN_Object
    a: u8 = 255, // transparency, used by ZEN_Object

    renderLayer: u32 = 0, // used by ZEN_Object for determining the order rects are rendered in

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
        _ = sdl.SDL_SetRenderDrawColor(renderer, self.r, self.g, self.b, self.a);
        _ = sdl.SDL_RenderFillRect(renderer, &rect);
    }

    pub fn collides(self: *ZEN_Rect, other: *ZEN_Shape) bool {
        switch (other.*) {
            .rect => |rec| {
                return ((self.x < rec.x + rec.w) and (rec.x < self.x + self.w) and (self.y < rec.y + rec.h) and (rec.y < self.y + self.h));
            },
            .ellipse => {},
        }
        return false;
    }

    pub fn getMTV(self: *ZEN_Rect, other: *ZEN_Rect) [2]f32 {
        var min: [2]f32 = [_]f32{ 0, 0 };
        if (!self.collides(@constCast(&ZEN_Shape{ .rect = other.* })))
            return min;

        const overlapX1 = (self.x + self.w) - other.x;
        const overlapX2 = (other.x + other.w) - self.x;
        const overlapY1 = (self.y + self.h) - other.y;
        const overlapY2 = (other.y + other.h) - self.y;

        min[0] = if (overlapX1 < overlapX2) overlapX1 + 0.01 else -overlapX2 - 0.01;
        min[1] = if (overlapY1 < overlapY2) overlapY1 + 0.01 else -overlapY2 - 0.01;

        return min;
    }
};

pub const ZEN_Ellipse = struct {
    x: f32, // x position, in px
    y: f32, // y position, in px
    w: f32, // width, in px
    h: f32, // height, in px

    r: u8 = 0, // red value, used by ZEN_Object
    g: u8 = 0, // green value, used by ZEN_Object
    b: u8 = 0, // blue value, used by ZEN_Object
    a: u8 = 255, // transparency, used by ZEN_Object

    renderLayer: u32 = 0, // used by ZEN_Object for determining the order rects are rendered in

    // transform from ZEN_Rect to SDL_Rect, primarily for rendering or to access SDL functions
    pub fn toSDL(self: *ZEN_Ellipse) sdl.SDL_Rect {
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
    pub fn render(self: *ZEN_Ellipse, renderer: *sdl.SDL_Renderer) !void {
        const midx = self.x + (self.w / 2);
        const midy = self.y + (self.h / 2);
        _ = sdl.filledEllipseRGBA(renderer, @intFromFloat(midx), @intFromFloat(midy), @intFromFloat(self.w / 2), @intFromFloat(self.h / 2), self.r, self.g, self.b, self.a);
    }
};

pub const ZEN_Shape = union(enum) {
    rect: ZEN_Rect,
    ellipse: ZEN_Ellipse,
    pub fn render(self: *ZEN_Shape, renderer: ?*sdl.SDL_Renderer) !void {
        switch (self.*) {
            .rect => |*v| try v.render(renderer.?),
            .ellipse => |*v| try v.render(renderer.?),
        }
    }
    pub fn collides(self: *ZEN_Shape, other: *ZEN_Shape) bool {
        switch (self.*) {
            .rect => |*v| {
                return v.collides(other);
            },
            .ellipse => |*v| {
                _ = v;
            },
        }
        return false;
    }
};

/// internal struct to organize and use ZEN_Shapes for rendering, basic utility functions, and other fundamental operations
pub const ZEN_Object = struct {
    collisionRect: ZEN_Shape,
    renderRects: std.ArrayList(*ZEN_Shape),
    allocator: std.mem.Allocator,
    renderLayer: i32,

    pub fn init(allocator: std.mem.Allocator, collision: ZEN_Shape) ZEN_Object {
        return .{
            .allocator = allocator,
            .collisionRect = collision,
            .renderRects = std.ArrayList(*ZEN_Shape).init(allocator),
        };
    }

    pub fn deinit(self: *ZEN_Object) void {
        self.renderRects.deinit();
    }

    pub fn addRenderShape(self: *ZEN_Object, rect: *ZEN_Shape) !void {
        try self.renderRects.append(self.allocator, rect);
    }

    fn renderLayerLessThan(_: void, a: *ZEN_Shape, b: *ZEN_Shape) bool {
        return a.renderLayer < b.renderLayer;
    }

    pub fn renderLayerLessThanObj(_: void, a: *ZEN_Object, b: *ZEN_Object) bool {
        return a.renderLayer < b.renderLayer;
    }

    pub fn render(self: *ZEN_Object, renderer: *sdl.SDL_Renderer) !void {
        std.sort.sort(ZEN_Shape, self.renderRects.items, {}, renderLayerLessThan);

        for (self.renderRects.items) |rect| {
            rect.setColor(renderer);
            rect.render(renderer);
        }
    }
};
