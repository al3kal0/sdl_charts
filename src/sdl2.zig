const c = @import("c.zig");

// constants
pub const Bool = c.SDL_bool;
pub const False = c.SDL_FALSE;
pub const True = c.SDL_TRUE;


pub const Window = ?*c.SDL_Window;
pub const Renderer = ?*c.SDL_Renderer;
pub const Texture = ?*c.SDL_Texture;
pub const Event = c.SDL_Event;
pub const Vertex = c.SDL_Vertex;
pub const Point = c.SDL_Point;
pub const Rect = c.SDL_Rect;
pub const Color = c.SDL_Color;

pub const WindowPosCentered = c.SDL_WINDOWPOS_CENTERED;
pub const WindowPosUndefined = c.SDL_WINDOWPOS_UNDEFINED;


// window flags
// pub const WindowFullscreen = c.SDL_WINDOW_FULLSCREEN;
// pub const WindowFullscreenDesktop = c.SDL_WINDOW_FULLSCREEN_DESKTOP;
// pub const WindowShown = c.SDL_WINDOW_SHOWN;
// pub const WindowHidden = c.SDL_WINDOW_HIDDEN;
// pub const WindowBorderless = c.SDL_WINDOW_BORDERLESS;
// pub const WindowResizable = c.SDL_WINDOW_RESIZABLE;
// pub const WindowMinimized = c.SDL_WINDOW_MINIMIZED;
// pub const WindowMaximized = c.SDL_WINDOW_MAXIMIZED;
// pub const WindowAllowHighDPI = c.SDL_WINDOW_ALLOW_HIGHDPI;

/// An enumeration of window states.
pub const WindowFlags = enum(u32)
{
    /// fullscreen window
    Fullscreen = c.SDL_WINDOW_FULLSCREEN,
    /// fullscreen window at the current desktop resolution
    FullscreenDesktop = c.SDL_WINDOW_FULLSCREEN_DESKTOP,
    /// window is visible
    Shown = c.SDL_WINDOW_SHOWN,
    /// window is not visible
    Hidden = c.SDL_WINDOW_HIDDEN,
    /// no window decoration
    Borderless = c.SDL_WINDOW_BORDERLESS,
    /// window can be resized
    Resizable = c.SDL_WINDOW_RESIZABLE,
    /// window is minimized
    Minimized = c.SDL_WINDOW_MINIMIZED,
    /// window is maximized
    Maximized = c.SDL_WINDOW_MAXIMIZED,
    /// window should be created in high-DPI mode if supported (>= SDL 2.0.1)
    AllowHighDPI = c.SDL_WINDOW_ALLOW_HIGHDPI,
};


// renderer flags
// pub const RendererSoftware = c.SDL_RENDERER_SOFTWARE;
// pub const RendererAccelarated = c.SDL_RENDERER_ACCELERATED;
// pub const RendererPresentVSync = c.SDL_RENDERER_PRESENTVSYNC;
// pub const RendererTargetTexture = c.SDL_RENDERER_TARGETTEXTURE;


/// An enumeration of flags used when creating a rendering context.
pub const RendererFlags = enum(u32)
{
    /// the renderer is a software fallback
    Software = c.SDL_RENDERER_SOFTWARE,
    /// the renderer uses hardware acceleration
    Accelarated = c.SDL_RENDERER_ACCELERATED,
    /// present is synchronized with the refresh rate
    PresentVSync = c.SDL_RENDERER_PRESENTVSYNC,
    /// the renderer supports rendering to texture
    TargetTexture = c.SDL_RENDERER_TARGETTEXTURE,   
};

/// Poll for currently pending events.
pub inline fn PollEvent(event: *Event) bool
{
    return if(c.SDL_PollEvent(event) == 1) true else false;
}

/// Create a window with the specified position, dimensions, and flags.
pub inline fn CreateWindow(title: []const u8, x: u32, y: u32, w: u32, h: u32, flags: WindowFlags) Window
{    
    return c.SDL_CreateWindow(@ptrCast([*c]const u8, &title),
                              @intCast(c_int, x),
                              @intCast(c_int, y),
                              @intCast(c_int, w),
                              @intCast(c_int, h),
                              @enumToInt(flags));
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
    if(c.SDL_SetWindowFullscreen(window, @enumToInt(flags)) != 0) return Error.SDL_error;
}

/// Restore the size and position of a minimized or maximized window.
pub inline fn RestoreWindow(window: Window) void
{
    c.SDL_RestoreWindow(window);
}

/// Create a 2D rendering context for a window.
pub inline fn CreateRenderer(window: Window, index: c_int, flags: RendererFlags) Renderer
{
    return c.SDL_CreateRenderer(window, index, @enumToInt(flags));
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

pub fn GetError() []const u8
{
    unreachable;
}

/// RGBA layout Color
// pub const Color = struct
// {
    // r: u8,
    // g: u8,
    // b: u8,
    // a: u8,
// 
    // pub fn create(color: u32) Color
    // {
        // const ptr = @ptrCast([*]u8, &color);
        // const r = ptr[0];
        // const g = ptr[1];
        // const b = ptr[2];
        // const a = ptr[3];
// 
        // return .{ r, g, b, a };
    // }
// };

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
                            vertices.len,
                            @ptrCast([*c]c_int, indices),
                            indices.len) != 0) return Error.SDL_error;
}

/// Render a list of triangles, optionally using a texture and indices into the vertex arrays Color 
/// and alpha modulation is done per vertex (SDL_SetTextureColorMod and SDL_SetTextureAlphaMod are ignored).
// pub inline fn RenderGeometryRaw(renderer: Renderer,
                                // texture: Texture,
                                // xy: []f32,
                                // color: Color,
                                // uv: []f32,
                                // num_vertices: u32,
                                // indices: *anyopaque,
                                // num_indices: u32,
                                // size_indices: u32
                                // ) !void
// {
    // unreachable;
// }



/// Draw a series of connected lines on the current rendering target.
pub inline fn RenderDrawLines(renderer: Renderer, points: []Point) !void
{
    if(c.SDL_RenderDrawLines(renderer, @ptrCast([*c]Point, points), points.len) != 0) return Error.SDL_error;
}

/// Draw multiple points on the current rendering target.
pub inline fn RenderDrawPoints(renderer: Renderer, points: []Point) !void
{
    if(c.SDL_RenderDrawPoints(renderer, @ptrCast([*c]Point, points), points.len) != 0) return Error.SDL_error;
}

/// Draw some number of rectangles on the current rendering target. 
pub inline fn RenderDrawRects(renderer: Renderer, rects: []Rect) !void
{
    if(c.SDL_RenderDrawRects(renderer, @ptrCast([*c]Rect, rects), rects.len) != 0) return Error.SDL_error;
}

/// Fill some number of rectangles on the current rendering target with the drawing color.
pub inline fn RenderFillRects(renderer: Renderer, rects: []Rect) !void
{
    if(c.SDL_RenderFillRects(renderer, @ptrCast([*c]Rect, rects), rects.len) != 0) return Error.SDL_error;
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
