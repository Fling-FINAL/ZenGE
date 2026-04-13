// !                             DO NOT CHANGE THIS FILE
// !
// ! this file holds the imports used anywhere in a project and any global values that may be needed
// ! this should be the only way that anything gets imported by a project file
// !

pub const std = @import("std");

const eScenehandler = @import("sceneHandler.zig");
const eShape = @import("shape.zig");
const eProcess = @import("process.zig");

const eConfig = @import("config");
const eFileLoader = @import("fileloader");

pub const sdl = @cImport({
    @cInclude("SDL2/SDL.h");
    @cInclude("SDL2/SDL_ttf.h");
    @cInclude("SDL2/SDL2_gfxPrimitives.h");
});

// global consts set by project json

// window init config
pub const bgR: u8 = 200; // background red value
pub const bgG: u8 = 200; // background green value
pub const bgB: u8 = 200; // background blue value
pub const windowName: []const u8 = "ZenGE Project"; // window title

pub var windowX: u32 = 200; // top left x value of the window
pub var windowY: u32 = 200; // top left y value of the window
pub var windowW: u32 = 2500; // width of the window
pub var windowH: u32 = 1500; // height of the window
pub const windowFlags: u32 = 0; // flags of the window, to add a flag to the window, use a logical or with this and the desired flag to add

// calculation vals init
pub const loopTypes = enum(u8) { direct, acc, delta, deltaacc };

// engine set types

pub const actionFn: type = fn () bool;

// global consts set by engine
//
pub const target = eConfig.targetConf;
pub const fileLoader = eFileLoader.fillScene;

pub const Scene = eScenehandler.Scene;
pub const SceneHandler = eScenehandler.SceneHandler;
pub const Process = eProcess.AnyProcess;
pub const PVT = eProcess.ProcessVTable;
pub const Wrap = eProcess.AnyProcess.Wrap;
pub const ZEN_Shape = eShape.ZEN_Shape;
pub const ZEN_Object = eShape.ZEN_Object;

pub const mkProcess = eProcess.makeProcess;
pub const mkSmplProcess = eProcess.makeSimpleProcess;

pub fn getEmptyProcessList() [@intCast(@intFromEnum(Triggers.zuFINAL))]?*Process {
    return [_]?*Process{null} ** @intFromEnum(Triggers.zuFINAL);
}

pub fn filler(self: *Process, dt: u32, ctx: *Scene) bool {
    _ = self;
    _ = dt;
    _ = ctx;
    return true;
}

pub fn smpFiller() bool {
    return true;
}

pub fn noDeinit(self: *Process, alloc: std.mem.Allocator) bool {
    _ = self;
    _ = alloc;
    return true;
}

pub fn voidCtm() *void {
    return @constCast(&{});
}

pub const zuKEY_BASE = 1;
pub const zuMOUSE_BASE = 1000;
pub const zuCONTROLLER_BASE = 2000;
pub const zuACTION_BASE = 3000;
pub const zuCTM_BASE = 4000;

/// recognized engine triggers
pub const Triggers = enum(u32) {
    zuUNKNOWN = 0,

    // keyboard triggers
    zuKEY_A = zuKEY_BASE + sdl.SDL_SCANCODE_A,
    zuKEY_B = zuKEY_BASE + sdl.SDL_SCANCODE_B,
    zuKEY_C = zuKEY_BASE + sdl.SDL_SCANCODE_C,
    zuKEY_D = zuKEY_BASE + sdl.SDL_SCANCODE_D,
    zuKEY_E = zuKEY_BASE + sdl.SDL_SCANCODE_E,
    zuKEY_F = zuKEY_BASE + sdl.SDL_SCANCODE_F,
    zuKEY_G = zuKEY_BASE + sdl.SDL_SCANCODE_G,
    zuKEY_H = zuKEY_BASE + sdl.SDL_SCANCODE_H,
    zuKEY_I = zuKEY_BASE + sdl.SDL_SCANCODE_I,
    zuKEY_J = zuKEY_BASE + sdl.SDL_SCANCODE_J,
    zuKEY_K = zuKEY_BASE + sdl.SDL_SCANCODE_K,
    zuKEY_L = zuKEY_BASE + sdl.SDL_SCANCODE_L,
    zuKEY_M = zuKEY_BASE + sdl.SDL_SCANCODE_M,
    zuKEY_N = zuKEY_BASE + sdl.SDL_SCANCODE_N,
    zuKEY_O = zuKEY_BASE + sdl.SDL_SCANCODE_O,
    zuKEY_P = zuKEY_BASE + sdl.SDL_SCANCODE_P,
    zuKEY_Q = zuKEY_BASE + sdl.SDL_SCANCODE_Q,
    zuKEY_R = zuKEY_BASE + sdl.SDL_SCANCODE_R,
    zuKEY_S = zuKEY_BASE + sdl.SDL_SCANCODE_S,
    zuKEY_T = zuKEY_BASE + sdl.SDL_SCANCODE_T,
    zuKEY_U = zuKEY_BASE + sdl.SDL_SCANCODE_U,
    zuKEY_V = zuKEY_BASE + sdl.SDL_SCANCODE_V,
    zuKEY_W = zuKEY_BASE + sdl.SDL_SCANCODE_W,
    zuKEY_X = zuKEY_BASE + sdl.SDL_SCANCODE_X,
    zuKEY_Y = zuKEY_BASE + sdl.SDL_SCANCODE_Y,
    zuKEY_Z = zuKEY_BASE + sdl.SDL_SCANCODE_Z,

    zuKEY_1 = zuKEY_BASE + sdl.SDL_SCANCODE_1,
    zuKEY_2 = zuKEY_BASE + sdl.SDL_SCANCODE_2,
    zuKEY_3 = zuKEY_BASE + sdl.SDL_SCANCODE_3,
    zuKEY_4 = zuKEY_BASE + sdl.SDL_SCANCODE_4,
    zuKEY_5 = zuKEY_BASE + sdl.SDL_SCANCODE_5,
    zuKEY_6 = zuKEY_BASE + sdl.SDL_SCANCODE_6,
    zuKEY_7 = zuKEY_BASE + sdl.SDL_SCANCODE_7,
    zuKEY_8 = zuKEY_BASE + sdl.SDL_SCANCODE_8,
    zuKEY_9 = zuKEY_BASE + sdl.SDL_SCANCODE_9,
    zuKEY_0 = zuKEY_BASE + sdl.SDL_SCANCODE_0,

    zuKEY_RETURN = zuKEY_BASE + sdl.SDL_SCANCODE_RETURN,
    zuKEY_ESCAPE = zuKEY_BASE + sdl.SDL_SCANCODE_ESCAPE,
    zuKEY_BACKSPACE = zuKEY_BASE + sdl.SDL_SCANCODE_BACKSPACE,
    zuKEY_TAB = zuKEY_BASE + sdl.SDL_SCANCODE_TAB,
    zuKEY_SPACE = zuKEY_BASE + sdl.SDL_SCANCODE_SPACE,

    zuKEY_MINUS = zuKEY_BASE + sdl.SDL_SCANCODE_MINUS,
    zuKEY_EQUALS = zuKEY_BASE + sdl.SDL_SCANCODE_EQUALS,

    zuKEY_LEFTBRACKET = zuKEY_BASE + sdl.SDL_SCANCODE_LEFTBRACKET,
    zuKEY_RIGHTBRACKET = zuKEY_BASE + sdl.SDL_SCANCODE_RIGHTBRACKET,
    zuKEY_BACKSLASH = zuKEY_BASE + sdl.SDL_SCANCODE_BACKSLASH,
    zuKEY_NONUSHASH = zuKEY_BASE + sdl.SDL_SCANCODE_NONUSHASH,

    zuKEY_SEMICOLON = zuKEY_BASE + sdl.SDL_SCANCODE_SEMICOLON,
    zuKEY_APOSTROPHE = zuKEY_BASE + sdl.SDL_SCANCODE_APOSTROPHE,
    zuKEY_GRAVE = zuKEY_BASE + sdl.SDL_SCANCODE_GRAVE,
    zuKEY_COMMA = zuKEY_BASE + sdl.SDL_SCANCODE_COMMA,
    zuKEY_PERIOD = zuKEY_BASE + sdl.SDL_SCANCODE_PERIOD,
    zuKEY_SLASH = zuKEY_BASE + sdl.SDL_SCANCODE_SLASH,

    zuKEY_CAPSLOCK = zuKEY_BASE + sdl.SDL_SCANCODE_CAPSLOCK,
    zuKEY_F1 = zuKEY_BASE + sdl.SDL_SCANCODE_F1,
    zuKEY_F2 = zuKEY_BASE + sdl.SDL_SCANCODE_F2,
    zuKEY_F3 = zuKEY_BASE + sdl.SDL_SCANCODE_F3,
    zuKEY_F4 = zuKEY_BASE + sdl.SDL_SCANCODE_F4,
    zuKEY_F5 = zuKEY_BASE + sdl.SDL_SCANCODE_F5,
    zuKEY_F6 = zuKEY_BASE + sdl.SDL_SCANCODE_F6,
    zuKEY_F7 = zuKEY_BASE + sdl.SDL_SCANCODE_F7,
    zuKEY_F8 = zuKEY_BASE + sdl.SDL_SCANCODE_F8,
    zuKEY_F9 = zuKEY_BASE + sdl.SDL_SCANCODE_F9,
    zuKEY_F10 = zuKEY_BASE + sdl.SDL_SCANCODE_F10,
    zuKEY_F11 = zuKEY_BASE + sdl.SDL_SCANCODE_F11,
    zuKEY_F12 = zuKEY_BASE + sdl.SDL_SCANCODE_F12,

    zuKEY_PRINTSCREEN = zuKEY_BASE + sdl.SDL_SCANCODE_PRINTSCREEN,
    zuKEY_SCROLLLOCK = zuKEY_BASE + sdl.SDL_SCANCODE_SCROLLLOCK,
    zuKEY_PAUSE = zuKEY_BASE + sdl.SDL_SCANCODE_PAUSE,
    zuKEY_INSERT = zuKEY_BASE + sdl.SDL_SCANCODE_INSERT,

    zuKEY_HOME = zuKEY_BASE + sdl.SDL_SCANCODE_HOME,
    zuKEY_PAGEUP = zuKEY_BASE + sdl.SDL_SCANCODE_PAGEUP,
    zuKEY_DELETE = zuKEY_BASE + sdl.SDL_SCANCODE_DELETE,
    zuKEY_END = zuKEY_BASE + sdl.SDL_SCANCODE_END,
    zuKEY_PAGEDOWN = zuKEY_BASE + sdl.SDL_SCANCODE_PAGEDOWN,
    zuKEY_RIGHT = zuKEY_BASE + sdl.SDL_SCANCODE_RIGHT,
    zuKEY_LEFT = zuKEY_BASE + sdl.SDL_SCANCODE_LEFT,
    zuKEY_DOWN = zuKEY_BASE + sdl.SDL_SCANCODE_DOWN,
    zuKEY_UP = zuKEY_BASE + sdl.SDL_SCANCODE_UP,

    zuKEY_NUMLOCKCLEAR = zuKEY_BASE + sdl.SDL_SCANCODE_NUMLOCKCLEAR,

    zuKEY_KP_DIVIDE = zuKEY_BASE + sdl.SDL_SCANCODE_KP_DIVIDE,
    zuKEY_KP_MULTIPLY = zuKEY_BASE + sdl.SDL_SCANCODE_KP_MULTIPLY,
    zuKEY_KP_MINUS = zuKEY_BASE + sdl.SDL_SCANCODE_KP_MINUS,
    zuKEY_KP_PLUS = zuKEY_BASE + sdl.SDL_SCANCODE_KP_PLUS,
    zuKEY_KP_ENTER = zuKEY_BASE + sdl.SDL_SCANCODE_KP_ENTER,
    zuKEY_KP_1 = zuKEY_BASE + sdl.SDL_SCANCODE_KP_1,
    zuKEY_KP_2 = zuKEY_BASE + sdl.SDL_SCANCODE_KP_2,
    zuKEY_KP_3 = zuKEY_BASE + sdl.SDL_SCANCODE_KP_3,
    zuKEY_KP_4 = zuKEY_BASE + sdl.SDL_SCANCODE_KP_4,
    zuKEY_KP_5 = zuKEY_BASE + sdl.SDL_SCANCODE_KP_5,
    zuKEY_KP_6 = zuKEY_BASE + sdl.SDL_SCANCODE_KP_6,
    zuKEY_KP_7 = zuKEY_BASE + sdl.SDL_SCANCODE_KP_7,
    zuKEY_KP_8 = zuKEY_BASE + sdl.SDL_SCANCODE_KP_8,
    zuKEY_KP_9 = zuKEY_BASE + sdl.SDL_SCANCODE_KP_9,
    zuKEY_KP_0 = zuKEY_BASE + sdl.SDL_SCANCODE_KP_0,

    zuKEY_KP_PERIOD = zuKEY_BASE + sdl.SDL_SCANCODE_KP_PERIOD,

    zuKEY_NONUSBACKSLASH = zuKEY_BASE + sdl.SDL_SCANCODE_NONUSBACKSLASH,
    zuKEY_APPLICATION = zuKEY_BASE + sdl.SDL_SCANCODE_APPLICATION,
    zuKEY_POWER = zuKEY_BASE + sdl.SDL_SCANCODE_POWER,
    zuKEY_KP_EQUALS = zuKEY_BASE + sdl.SDL_SCANCODE_KP_EQUALS,

    zuKEY_F13 = zuKEY_BASE + sdl.SDL_SCANCODE_F13,
    zuKEY_F14 = zuKEY_BASE + sdl.SDL_SCANCODE_F14,
    zuKEY_F15 = zuKEY_BASE + sdl.SDL_SCANCODE_F15,
    zuKEY_F16 = zuKEY_BASE + sdl.SDL_SCANCODE_F16,
    zuKEY_F17 = zuKEY_BASE + sdl.SDL_SCANCODE_F17,
    zuKEY_F18 = zuKEY_BASE + sdl.SDL_SCANCODE_F18,
    zuKEY_F19 = zuKEY_BASE + sdl.SDL_SCANCODE_F19,
    zuKEY_F20 = zuKEY_BASE + sdl.SDL_SCANCODE_F20,
    zuKEY_F21 = zuKEY_BASE + sdl.SDL_SCANCODE_F21,
    zuKEY_F22 = zuKEY_BASE + sdl.SDL_SCANCODE_F22,
    zuKEY_F23 = zuKEY_BASE + sdl.SDL_SCANCODE_F23,
    zuKEY_F24 = zuKEY_BASE + sdl.SDL_SCANCODE_F24,

    zuKEY_EXECUTE = zuKEY_BASE + sdl.SDL_SCANCODE_EXECUTE,
    zuKEY_HELP = zuKEY_BASE + sdl.SDL_SCANCODE_HELP,
    zuKEY_MENU = zuKEY_BASE + sdl.SDL_SCANCODE_MENU,
    zuKEY_SELECT = zuKEY_BASE + sdl.SDL_SCANCODE_SELECT,
    zuKEY_STOP = zuKEY_BASE + sdl.SDL_SCANCODE_STOP,
    zuKEY_AGAIN = zuKEY_BASE + sdl.SDL_SCANCODE_AGAIN,
    zuKEY_UNDO = zuKEY_BASE + sdl.SDL_SCANCODE_UNDO,
    zuKEY_CUT = zuKEY_BASE + sdl.SDL_SCANCODE_CUT,
    zuKEY_COPY = zuKEY_BASE + sdl.SDL_SCANCODE_COPY,
    zuKEY_PASTE = zuKEY_BASE + sdl.SDL_SCANCODE_PASTE,
    zuKEY_FIND = zuKEY_BASE + sdl.SDL_SCANCODE_FIND,
    zuKEY_MUTE = zuKEY_BASE + sdl.SDL_SCANCODE_MUTE,
    zuKEY_VOLUMEUP = zuKEY_BASE + sdl.SDL_SCANCODE_VOLUMEUP,
    zuKEY_VOLUMEDOWN = zuKEY_BASE + sdl.SDL_SCANCODE_VOLUMEDOWN,

    zuKEY_KP_COMMA = zuKEY_BASE + sdl.SDL_SCANCODE_KP_COMMA,
    zuKEY_KP_EQUALSAS400 = zuKEY_BASE + sdl.SDL_SCANCODE_KP_EQUALSAS400,

    zuKEY_INTERNATIONAL1 = zuKEY_BASE + sdl.SDL_SCANCODE_INTERNATIONAL1,
    zuKEY_INTERNATIONAL2 = zuKEY_BASE + sdl.SDL_SCANCODE_INTERNATIONAL2,
    zuKEY_INTERNATIONAL3 = zuKEY_BASE + sdl.SDL_SCANCODE_INTERNATIONAL3,
    zuKEY_INTERNATIONAL4 = zuKEY_BASE + sdl.SDL_SCANCODE_INTERNATIONAL4,
    zuKEY_INTERNATIONAL5 = zuKEY_BASE + sdl.SDL_SCANCODE_INTERNATIONAL5,
    zuKEY_INTERNATIONAL6 = zuKEY_BASE + sdl.SDL_SCANCODE_INTERNATIONAL6,
    zuKEY_INTERNATIONAL7 = zuKEY_BASE + sdl.SDL_SCANCODE_INTERNATIONAL7,
    zuKEY_INTERNATIONAL8 = zuKEY_BASE + sdl.SDL_SCANCODE_INTERNATIONAL8,
    zuKEY_INTERNATIONAL9 = zuKEY_BASE + sdl.SDL_SCANCODE_INTERNATIONAL9,

    zuKEY_LANG1 = zuKEY_BASE + sdl.SDL_SCANCODE_LANG1,
    zuKEY_LANG2 = zuKEY_BASE + sdl.SDL_SCANCODE_LANG2,
    zuKEY_LANG3 = zuKEY_BASE + sdl.SDL_SCANCODE_LANG3,
    zuKEY_LANG4 = zuKEY_BASE + sdl.SDL_SCANCODE_LANG4,
    zuKEY_LANG5 = zuKEY_BASE + sdl.SDL_SCANCODE_LANG5,
    zuKEY_LANG6 = zuKEY_BASE + sdl.SDL_SCANCODE_LANG6,
    zuKEY_LANG7 = zuKEY_BASE + sdl.SDL_SCANCODE_LANG7,
    zuKEY_LANG8 = zuKEY_BASE + sdl.SDL_SCANCODE_LANG8,
    zuKEY_LANG9 = zuKEY_BASE + sdl.SDL_SCANCODE_LANG9,

    zuKEY_ALTERASE = zuKEY_BASE + sdl.SDL_SCANCODE_ALTERASE,
    zuKEY_SYSREQ = zuKEY_BASE + sdl.SDL_SCANCODE_SYSREQ,
    zuKEY_CANCEL = zuKEY_BASE + sdl.SDL_SCANCODE_CANCEL,
    zuKEY_CLEAR = zuKEY_BASE + sdl.SDL_SCANCODE_CLEAR,
    zuKEY_PRIOR = zuKEY_BASE + sdl.SDL_SCANCODE_PRIOR,
    zuKEY_RETURN2 = zuKEY_BASE + sdl.SDL_SCANCODE_RETURN2,
    zuKEY_SEPARATOR = zuKEY_BASE + sdl.SDL_SCANCODE_SEPARATOR,
    zuKEY_OUT = zuKEY_BASE + sdl.SDL_SCANCODE_OUT,
    zuKEY_OPER = zuKEY_BASE + sdl.SDL_SCANCODE_OPER,
    zuKEY_CLEARAGAIN = zuKEY_BASE + sdl.SDL_SCANCODE_CLEARAGAIN,
    zuKEY_CRSEL = zuKEY_BASE + sdl.SDL_SCANCODE_CRSEL,
    zuKEY_EXSEL = zuKEY_BASE + sdl.SDL_SCANCODE_EXSEL,

    zuKEY_KP_00 = zuKEY_BASE + sdl.SDL_SCANCODE_KP_00,
    zuKEY_KP_000 = zuKEY_BASE + sdl.SDL_SCANCODE_KP_000,
    zuKEY_THOUSANDSSEPARATOR = zuKEY_BASE + sdl.SDL_SCANCODE_THOUSANDSSEPARATOR,
    zuKEY_DECIMALSEPARATOR = zuKEY_BASE + sdl.SDL_SCANCODE_DECIMALSEPARATOR,
    zuKEY_CURRENCYUNIT = zuKEY_BASE + sdl.SDL_SCANCODE_CURRENCYUNIT,
    zuKEY_CURRENCYSUBUNIT = zuKEY_BASE + sdl.SDL_SCANCODE_CURRENCYSUBUNIT,

    zuKEY_KP_LEFTPAREN = zuKEY_BASE + sdl.SDL_SCANCODE_KP_LEFTPAREN,
    zuKEY_KP_RIGHTPAREN = zuKEY_BASE + sdl.SDL_SCANCODE_KP_RIGHTPAREN,
    zuKEY_KP_LEFTBRACE = zuKEY_BASE + sdl.SDL_SCANCODE_KP_LEFTBRACE,
    zuKEY_KP_RIGHTBRACE = zuKEY_BASE + sdl.SDL_SCANCODE_KP_RIGHTBRACE,
    zuKEY_KP_TAB = zuKEY_BASE + sdl.SDL_SCANCODE_KP_TAB,
    zuKEY_KP_BACKSPACE = zuKEY_BASE + sdl.SDL_SCANCODE_KP_BACKSPACE,

    zuKEY_KP_A = zuKEY_BASE + sdl.SDL_SCANCODE_KP_A,
    zuKEY_KP_B = zuKEY_BASE + sdl.SDL_SCANCODE_KP_B,
    zuKEY_KP_C = zuKEY_BASE + sdl.SDL_SCANCODE_KP_C,
    zuKEY_KP_D = zuKEY_BASE + sdl.SDL_SCANCODE_KP_D,
    zuKEY_KP_E = zuKEY_BASE + sdl.SDL_SCANCODE_KP_E,
    zuKEY_KP_F = zuKEY_BASE + sdl.SDL_SCANCODE_KP_F,

    zuKEY_KP_XOR = zuKEY_BASE + sdl.SDL_SCANCODE_KP_XOR,
    zuKEY_KP_POWER = zuKEY_BASE + sdl.SDL_SCANCODE_KP_POWER,
    zuKEY_KP_PERCENT = zuKEY_BASE + sdl.SDL_SCANCODE_KP_PERCENT,
    zuKEY_KP_LESS = zuKEY_BASE + sdl.SDL_SCANCODE_KP_LESS,
    zuKEY_KP_GREATER = zuKEY_BASE + sdl.SDL_SCANCODE_KP_GREATER,
    zuKEY_KP_AMPERSAND = zuKEY_BASE + sdl.SDL_SCANCODE_KP_AMPERSAND,
    zuKEY_KP_DBLAMPERSAND = zuKEY_BASE + sdl.SDL_SCANCODE_KP_DBLAMPERSAND,
    zuKEY_KP_VERTICALBAR = zuKEY_BASE + sdl.SDL_SCANCODE_KP_VERTICALBAR,
    zuKEY_KP_DBLVERTICALBAR = zuKEY_BASE + sdl.SDL_SCANCODE_KP_DBLVERTICALBAR,
    zuKEY_KP_COLON = zuKEY_BASE + sdl.SDL_SCANCODE_KP_COLON,
    zuKEY_KP_HASH = zuKEY_BASE + sdl.SDL_SCANCODE_KP_HASH,
    zuKEY_KP_SPACE = zuKEY_BASE + sdl.SDL_SCANCODE_KP_SPACE,
    zuKEY_KP_AT = zuKEY_BASE + sdl.SDL_SCANCODE_KP_AT,
    zuKEY_KP_EXCLAM = zuKEY_BASE + sdl.SDL_SCANCODE_KP_EXCLAM,
    zuKEY_KP_MEMSTORE = zuKEY_BASE + sdl.SDL_SCANCODE_KP_MEMSTORE,
    zuKEY_KP_MEMRECALL = zuKEY_BASE + sdl.SDL_SCANCODE_KP_MEMRECALL,
    zuKEY_KP_MEMCLEAR = zuKEY_BASE + sdl.SDL_SCANCODE_KP_MEMCLEAR,
    zuKEY_KP_MEMADD = zuKEY_BASE + sdl.SDL_SCANCODE_KP_MEMADD,
    zuKEY_KP_MEMSUBTRACT = zuKEY_BASE + sdl.SDL_SCANCODE_KP_MEMSUBTRACT,
    zuKEY_KP_MEMMULTIPLY = zuKEY_BASE + sdl.SDL_SCANCODE_KP_MEMMULTIPLY,
    zuKEY_KP_MEMDIVIDE = zuKEY_BASE + sdl.SDL_SCANCODE_KP_MEMDIVIDE,
    zuKEY_KP_PLUSMINUS = zuKEY_BASE + sdl.SDL_SCANCODE_KP_PLUSMINUS,
    zuKEY_KP_CLEAR = zuKEY_BASE + sdl.SDL_SCANCODE_KP_CLEAR,
    zuKEY_KP_CLEARENTRY = zuKEY_BASE + sdl.SDL_SCANCODE_KP_CLEARENTRY,
    zuKEY_KP_BINARY = zuKEY_BASE + sdl.SDL_SCANCODE_KP_BINARY,
    zuKEY_KP_OCTAL = zuKEY_BASE + sdl.SDL_SCANCODE_KP_OCTAL,
    zuKEY_KP_DECIMAL = zuKEY_BASE + sdl.SDL_SCANCODE_KP_DECIMAL,
    zuKEY_KP_HEXADECIMAL = zuKEY_BASE + sdl.SDL_SCANCODE_KP_HEXADECIMAL,

    zuKEY_LCTRL = zuKEY_BASE + sdl.SDL_SCANCODE_LCTRL,
    zuKEY_LSHIFT = zuKEY_BASE + sdl.SDL_SCANCODE_LSHIFT,
    zuKEY_LALT = zuKEY_BASE + sdl.SDL_SCANCODE_LALT,
    zuKEY_LGUI = zuKEY_BASE + sdl.SDL_SCANCODE_LGUI,
    zuKEY_RCTRL = zuKEY_BASE + sdl.SDL_SCANCODE_RCTRL,
    zuKEY_RSHIFT = zuKEY_BASE + sdl.SDL_SCANCODE_RSHIFT,
    zuKEY_RALT = zuKEY_BASE + sdl.SDL_SCANCODE_RALT,
    zuKEY_RGUI = zuKEY_BASE + sdl.SDL_SCANCODE_RGUI,

    zuKEY_SCANCODES_MODE = zuKEY_BASE + sdl.SDL_SCANCODE_MODE,

    zuKEY_AUDIONEXT = zuKEY_BASE + sdl.SDL_SCANCODE_AUDIONEXT,
    zuKEY_AUDIOPREV = zuKEY_BASE + sdl.SDL_SCANCODE_AUDIOPREV,
    zuKEY_AUDIOSTOP = zuKEY_BASE + sdl.SDL_SCANCODE_AUDIOSTOP,
    zuKEY_AUDIOPLAY = zuKEY_BASE + sdl.SDL_SCANCODE_AUDIOPLAY,
    zuKEY_AUDIOMUTE = zuKEY_BASE + sdl.SDL_SCANCODE_AUDIOMUTE,
    zuKEY_MEDIASELECT = zuKEY_BASE + sdl.SDL_SCANCODE_MEDIASELECT,
    zuKEY_WWW = zuKEY_BASE + sdl.SDL_SCANCODE_WWW,
    zuKEY_MAIL = zuKEY_BASE + sdl.SDL_SCANCODE_MAIL,
    zuKEY_CALCULATOR = zuKEY_BASE + sdl.SDL_SCANCODE_CALCULATOR,
    zuKEY_COMPUTER = zuKEY_BASE + sdl.SDL_SCANCODE_COMPUTER,
    zuKEY_AC_SEARCH = zuKEY_BASE + sdl.SDL_SCANCODE_AC_SEARCH,
    zuKEY_AC_HOME = zuKEY_BASE + sdl.SDL_SCANCODE_AC_HOME,
    zuKEY_AC_BACK = zuKEY_BASE + sdl.SDL_SCANCODE_AC_BACK,
    zuKEY_AC_FORWARD = zuKEY_BASE + sdl.SDL_SCANCODE_AC_FORWARD,
    zuKEY_AC_STOP = zuKEY_BASE + sdl.SDL_SCANCODE_AC_STOP,
    zuKEY_AC_REFRESH = zuKEY_BASE + sdl.SDL_SCANCODE_AC_REFRESH,
    zuKEY_AC_BOOKMARKS = zuKEY_BASE + sdl.SDL_SCANCODE_AC_BOOKMARKS,

    zuKEY_BRIGHTNESSDOWN = zuKEY_BASE + sdl.SDL_SCANCODE_BRIGHTNESSDOWN,
    zuKEY_BRIGHTNESSUP = zuKEY_BASE + sdl.SDL_SCANCODE_BRIGHTNESSUP,
    zuKEY_DISPLAYSWITCH = zuKEY_BASE + sdl.SDL_SCANCODE_DISPLAYSWITCH,
    zuKEY_KBDILLUMTOGGLE = zuKEY_BASE + sdl.SDL_SCANCODE_KBDILLUMTOGGLE,
    zuKEY_KBDILLUMDOWN = zuKEY_BASE + sdl.SDL_SCANCODE_KBDILLUMDOWN,
    zuKEY_KBDILLUMUP = zuKEY_BASE + sdl.SDL_SCANCODE_KBDILLUMUP,
    zuKEY_EJECT = zuKEY_BASE + sdl.SDL_SCANCODE_EJECT,
    zuKEY_SLEEP = zuKEY_BASE + sdl.SDL_SCANCODE_SLEEP,

    zuKEY_APP1 = zuKEY_BASE + sdl.SDL_SCANCODE_APP1,
    zuKEY_APP2 = zuKEY_BASE + sdl.SDL_SCANCODE_APP2,

    zuKEY_AUDIOREWIND = zuKEY_BASE + sdl.SDL_SCANCODE_AUDIOREWIND,
    zuKEY_AUDIOFASTFORWARD = zuKEY_BASE + sdl.SDL_SCANCODE_AUDIOFASTFORWARD,
    zuKEY_SOFTLEFT = zuKEY_BASE + sdl.SDL_SCANCODE_SOFTLEFT,
    zuKEY_SOFTRIGHT = zuKEY_BASE + sdl.SDL_SCANCODE_SOFTRIGHT,

    zuKEY_CALL = zuKEY_BASE + sdl.SDL_SCANCODE_CALL,
    zuKEY_ENDCALL = zuKEY_BASE + sdl.SDL_SCANCODE_ENDCALL,

    // composite keys
    zuKEY_CTRL,
    zuKEY_ALT,
    zuKEY_SHIFT,

    zuKEY_FINAL,

    // action triggers
    zuACTION_PREUPDATE = zuACTION_BASE + 1,
    zuACTION_POSTUPDATE,
    zuACTION_PRERENDER,
    zuACTION_POSTRENDER,

    zuACTION_QUIT,
    zuACTION_RESET,

    zuACTION_FINAL,

    // mouse triggers
    zuMOUSE_LEFT = zuMOUSE_BASE + 1,
    zuMOUSE_MIDDLE,
    zuMOUSE_RIGHT,

    zuCTM_FINAL = zuCTM_BASE + 1000,
    zuFINAL,
};
