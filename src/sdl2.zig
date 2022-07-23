const std = @import("std");
const c = @import("c.zig");
const vectors_lib = @import("vectors_lib.zig");
const Vector3 = vectors_lib.Vector3;

// constants
pub const Bool = c.SDL_bool;
pub const False = c.SDL_FALSE;
pub const True = c.SDL_TRUE;
pub const DisplayMode = c.SDL_DisplayMode;


pub const Window = ?*c.SDL_Window;
pub const Renderer = ?*c.SDL_Renderer;
pub const Texture = ?*c.SDL_Texture;
pub const Event = c.SDL_Event;
pub const Vertex = c.SDL_Vertex;
pub const Point = c.SDL_Point;
pub const Rect = c.SDL_Rect;
pub const Color = c.SDL_Color;

pub const WINDOWPOS_CENTERED = c.SDL_WINDOWPOS_CENTERED;
pub const WINDOWPOS_UNDEFINED = c.SDL_WINDOWPOS_UNDEFINED;


pub const InitFlags = u32;
pub const WindowFlags = u32;
pub const RendererFlags = u32;


// pub const InitFlags = enum(u32)
// {
    // Timer = c.SDL_INIT_TIMER,
    // Audio = c.SDL_INIT_AUDIO,
    // Video = c.SDL_INIT_VIDEO,
    // Joystick = c.SDL_INIT_JOYSTICK,
    // Haptic = c.SDL_INIT_HAPTIC,
    // GameController = c.SDL_INIT_GAMECONTROLLER,
    // Events = c.SDL_INIT_EVENTS,
    // Everything = c.SDL_INIT_EVERYTHING,
// };


pub const INIT_TIMER = c.SDL_INIT_TIMER;
pub const INIT_AUDIO = c.SDL_INIT_AUDIO;
pub const INIT_VIDEO = c.SDL_INIT_VIDEO;
pub const INIT_JOYSTICK = c.SDL_INIT_JOYSTICK;
pub const INIT_HAPTIC = c.SDL_INIT_HAPTIC;
pub const INIT_GAMECONTROLLER = c.SDL_INIT_GAMECONTROLLER;
pub const INIT_EVENTS = c.SDL_INIT_EVENTS;
pub const INIT_EVERYTHING = c.SDL_INIT_EVERYTHING;



/// the renderer is a software fallback
pub const RENDERER_SOFTWARE = c.SDL_RENDERER_SOFTWARE;
/// the renderer uses hardware acceleration
pub const RENDERER_ACCELERATED = c.SDL_RENDERER_ACCELERATED;
/// present is synchronized with the refresh rate
pub const SDL_RENDERER_PRESENTVSYNC = c.SDL_RENDERER_PRESENTVSYNC;
/// the renderer supports rendering to texture
pub const RENDERER_TARGETTEXTURE = c.SDL_RENDERER_TARGETTEXTURE;   


pub inline fn Init(flags: InitFlags) !void
{
    if(c.SDL_Init(flags) != 0) return Error.SDL_error;
}


/// fullscreen window
pub const WINDOW_FULLSCREEN = c.SDL_WINDOW_FULLSCREEN;
/// fullscreen window at the current desktop resolution
pub const WINDOW_FULLSCREEN_DESKTOP = c.SDL_WINDOW_FULLSCREEN_DESKTOP;
/// window usable with OpenGL context
pub const WINDOW_OPENGL = c.SDL_WINDOW_OPENGL;
/// window is visible
pub const WINDOW_SHOWN = c.SDL_WINDOW_SHOWN;
/// window is not visible
pub const WINDOW_HIDDEN = c.SDL_WINDOW_HIDDEN;
/// no window decoration
pub const WINDOW_BORDERLESS = c.SDL_WINDOW_BORDERLESS;
/// window can be resized
pub const WINDOW_RESIZABLE = c.SDL_WINDOW_RESIZABLE;
/// window is minimized
pub const WINDOW_MINIMIZED = c.SDL_WINDOW_MINIMIZED;
/// window is maximized
pub const SDL_WINDOW_MAXIMIZED = c.SDL_WINDOW_MAXIMIZED;
/// window should be created in high-DPI mode if supported (>= SDL 2.0.1)
pub const WINDOW_ALLOW_HIGHDPI = c.SDL_WINDOW_ALLOW_HIGHDPI;




// 
// /// An enumeration of window states.
// pub const WindowFlags = enum(u32)
// {
    // /// fullscreen window
    // Fullscreen = c.SDL_WINDOW_FULLSCREEN,
    // /// fullscreen window at the current desktop resolution
    // FullscreenDesktop = c.SDL_WINDOW_FULLSCREEN_DESKTOP,
    // /// window usable with OpenGL context
    // OpenGL = c.SDL_WINDOW_OPENGL,
    // /// window is visible
    // Shown = c.SDL_WINDOW_SHOWN,
    // /// window is not visible
    // Hidden = c.SDL_WINDOW_HIDDEN,
    // /// no window decoration
    // Borderless = c.SDL_WINDOW_BORDERLESS,
    // /// window can be resized
    // Resizable = c.SDL_WINDOW_RESIZABLE,
    // /// window is minimized
    // Minimized = c.SDL_WINDOW_MINIMIZED,
    // /// window is maximized
    // Maximized = c.SDL_WINDOW_MAXIMIZED,
    // /// window should be created in high-DPI mode if supported (>= SDL 2.0.1)
    // AllowHighDPI = c.SDL_WINDOW_ALLOW_HIGHDPI,
// };


/// An enumeration of flags used when creating a rendering context.
// pub const RendererFlags = enum(u32)
// {
    // /// the renderer is a software fallback
    // Software = c.SDL_RENDERER_SOFTWARE,
    // /// the renderer uses hardware acceleration
    // Accelarated = c.SDL_RENDERER_ACCELERATED,
    // /// present is synchronized with the refresh rate
    // PresentVSync = c.SDL_RENDERER_PRESENTVSYNC,
    // /// the renderer supports rendering to texture
    // TargetTexture = c.SDL_RENDERER_TARGETTEXTURE,
// };


/// Poll for currently pending events.
pub inline fn PollEvent(event: *Event) bool
{
    return if(c.SDL_PollEvent(event) == 1) true else false;
}

/// Create a window with the specified position, dimensions, and flags.
pub inline fn CreateWindow(title: [:0]const u8, x: u32, y: u32, w: u32, h: u32, flags: WindowFlags) Window
{    
    return c.SDL_CreateWindow(@ptrCast([*c]const u8, title.ptr),
                              @intCast(c_int, x),
                              @intCast(c_int, y),
                              @intCast(c_int, w),
                              @intCast(c_int, h),
                              flags);
}

/// Destroy a window.
pub inline fn DestroyWindow(window: Window) void
{
    c.SDL_DestroyWindow(window);
}


/// Minimize a window to an iconic representation.
pub inline fn MinimizeWindow(window: Window) void
{
    c.SDL_MinimizeWindow(window);
}

/// Make a window as large as possible.
pub inline fn MaximizeWindow(window: Window) void
{
    c.SDL_MaximizeWindow(window);
}

/// Set a window's fullscreen state.
pub inline fn SetWindowFullscreen(window: Window, flags: WindowFlags) !void
{
    if(c.SDL_SetWindowFullscreen(window, flags) != 0) return Error.SDL_error;
}

/// Restore the size and position of a minimized or maximized window.
pub inline fn RestoreWindow(window: Window) void
{
    c.SDL_RestoreWindow(window);
}

/// Create a 2D rendering context for a window.
pub inline fn CreateRenderer(window: Window, index: c_int, flags: RendererFlags) Renderer
{
    return c.SDL_CreateRenderer(window, index, flags);
}


/// Destroy the rendering context for a window and free associated textures.
pub inline fn DestroyRenderer(renderer: Renderer) void
{
    c.SDL_DestroyRenderer(renderer);
}

/// Clean up all initialized subsystems.
pub inline fn Quit() void
{
    c.SDL_Quit();
}

pub const Error = error { SDL_error };

pub fn GetError() void
{
    const err = c.SDL_GetError();
    std.debug.panic("{s}\n", .{err});
}


pub const EXT = struct
{
    pub inline fn CreateColor(color: u32) Color
    {
        const ptr = @ptrCast([*]u8, &color);
        const r = ptr[0];
        const g = ptr[1];
        const b = ptr[2];
        const a = ptr[3];
    
        return .{ r, g, b, a };
    }            
};

/// Render a list of triangles, optionally using a texture and indices into the vertex array Color 
/// and alpha modulation is done per vertex (SDL_SetTextureColorMod and SDL_SetTextureAlphaMod are ignored).
pub inline fn RenderGeometry(renderer: Renderer, texture: Texture, vertices: []Vertex, indices: ?[]u16) !void
{    
    if(c.SDL_RenderGeometry(renderer,
                            texture,
                            @ptrCast([*c]Vertex, vertices),
                            @intCast(c_int, vertices.len),
                            @ptrCast([*c]c_int, indices),
                            @intCast(c_int, indices.len)) != 0) return Error.SDL_error;
}

/// Render a list of triangles, optionally using a texture and indices into the vertex arrays Color 
/// and alpha modulation is done per vertex (SDL_SetTextureColorMod and SDL_SetTextureAlphaMod are ignored).
pub inline fn RenderGeometryRaw(renderer: Renderer, texture: Texture, xy: []Vector3, color: []Color, uv: ?[]f32, indices: ?[]u16) !void
{
    if(c.SDL_RenderGeometryRaw(renderer,
                               texture,
                               @ptrCast([*c]f32, xy),
                               @sizeOf(f32) * 3,                // xy_stride
                               @ptrCast([*c]Color, color),
                               @sizeOf(Color),                  // color_stride
                               @ptrCast([*c]f32, uv),
                               @sizeOf(f32) * 2,                // uv_stride
                               @intCast(c_int, xy.len),                          // num_vertices ^ the above thing is the vertices
                               @ptrCast([*c]anyopaque, indices),
                               @intCast(c_int, indices.len)) != 0) return Error.SLD_error;
}



/// Draw a series of connected lines on the current rendering target.
pub inline fn RenderDrawLines(renderer: Renderer, points: []Point) !void
{
    if(c.SDL_RenderDrawLines(renderer, @ptrCast([*c]Point, points), @intCast(c_int, points.len)) != 0) return Error.SDL_error;
}

/// Draw multiple points on the current rendering target.
pub inline fn RenderDrawPoints(renderer: Renderer, points: []Point) !void
{
    if(c.SDL_RenderDrawPoints(renderer, @ptrCast([*c]Point, points), @intCast(c_int, points.len)) != 0) return Error.SDL_error;
}

/// Draw a rectangle on the current rendering target.
pub inline fn RenderDrawRect(renderer: Renderer, rect: *const Rect) !void
{
    if(c.SDL_RenderDrawRect(renderer, rect) != 0) return Error.SDL_error;
}

/// Draw some number of rectangles on the current rendering target. 
pub inline fn RenderDrawRects(renderer: Renderer, rects: []Rect) !void
{
    if(c.SDL_RenderDrawRects(renderer, @ptrCast([*c]Rect, rects), @intCast(c_int, rects.len)) != 0) return Error.SDL_error;
}

/// Fill some number of rectangles on the current rendering target with the drawing color.
pub inline fn RenderFillRects(renderer: Renderer, rects: []Rect) !void
{
    if(c.SDL_RenderFillRects(renderer, @ptrCast([*c]Rect, rects), @intCast(c_int, rects.len)) != 0) return Error.SDL_error;
}

/// Set the color used for drawing operations (Rect, Line and Clear).
pub inline fn SetRenderDrawColor(renderer: Renderer, rgba: Color) !void
{
    if(c.SDL_SetRenderDrawColor(renderer, rgba.r, rgba.g, rgba.b, rgba.a) != 0) return Error.SDL_error;
}

/// Update the screen with any rendering performed since the previous call.
pub inline fn RenderPresent(renderer: Renderer) void
{
    c.SDL_RenderPresent(renderer);
}

/// Clear the current rendering target with the drawing color.
pub inline fn RenderClear(renderer: Renderer) !void
{
    if(c.SDL_RenderClear(renderer) != 0) return Error.SDL_error;
}

/// Get information about the desktop's display mode.
pub inline fn GetDesktopDisplayMode(displayIndex: u32, mode: *DisplayMode) !void
{
    if(c.SDL_GetDesktopDisplayMode(@intCast(c_int, displayIndex), mode) != 0) return Error.SDL_error;
}

/// Get the pixel format associated with the window.
pub inline fn GetWindowPixelFormat(window: Window) c_uint
{
    return c.SDL_GetWindowPixelFormat(window);
} 
