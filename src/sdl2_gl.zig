const c = @import("c.zig");
const SDL = @import("sdl2.zig");


pub const Error = error { SDL_GL_error };


pub const Context = c.SDL_GLContext;

pub const GLattr = u32;
pub const Profile = u32;


/// the minimum number of bits for the red channel of the color buffer; defaults to 3
pub const RED_SIZE = c.SDL_GL_RED_SIZE;  
/// the minimum number of bits for the green channel of the color buffer; defaults to 3
pub const GREEN_SIZE = c.SDL_GL_GREEN_SIZE;
/// the minimum number of bits for the blue channel of the color buffer; defaults to 2
pub const BLUE_SIZE= c.SDL_GL_BLUE_SIZE;
/// the minimum number of bits for the alpha channel of the color buffer; defaults to 0
pub const ALPHA_SIZE = c.SDL_GL_ALPHA_SIZE;
/// the minimum number of bits for frame buffer size; defaults to 0
pub const BUFFER_SIZE = c.SDL_GL_BUFFER_SIZE;
/// whether the output is single or double buffered; defaults to double buffering on
pub const DOUBLEBUFFER = c.SDL_GL_DOUBLEBUFFER;
/// the minimum number of bits in the depth buffer; defaults to 16
pub const DEPTH_SIZE = c.SDL_GL_DEPTH_SIZE;
/// the minimum number of bits in the stencil buffer; defaults to 0
pub const STENCIL_SIZE = c.SDL_GL_STENCIL_SIZE;
/// the minimum number of bits for the red channel of the accumulation buffer; defaults to 0
pub const ACCUM_RED_SIZE = c.SDL_GL_ACCUM_RED_SIZE;
/// the minimum number of bits for the green channel of the accumulation buffer; defaults to 0
pub const ACCUM_GREEN_SIZE = c.SDL_GL_ACCUM_GREEN_SIZE;
/// the minimum number of bits for the blue channel of the accumulation buffer; defaults to 0
pub const ACCUM_BLUE_SIZE = c.SDL_GL_ACCUM_BLUE_SIZE;
/// the minimum number of bits for the alpha channel of the accumulation buffer; defaults to 0
pub const ACCUM_ALPHA_SIZE = c.SDL_GL_ACCUM_ALPHA_SIZE;
/// whether the output is stereo 3D; defaults to off
pub const STEREO = c.SDL_GL_STEREO;
/// the number of buffers used for multisample anti-aliasing; defaults to 0; see Remarks for details
pub const MULTISAMPLEBUFFERS = c.SDL_GL_MULTISAMPLEBUFFERS;
/// the number of samples used around the current pixel used for multisample anti-aliasing; defaults to 0; see Remarks for details
pub const MULTISAMPLESAMPLES = c.SDL_GL_MULTISAMPLESAMPLES;
/// set to 1 to require hardware acceleration, set to 0 to force software rendering; defaults to allow either
pub const ACCELERATED_VISUAL = c.SDL_GL_ACCELERATED_VISUAL;
/// OpenGL context major version; see Remarks for details
pub const CONTEXT_MAJOR_VERSION = c.SDL_GL_CONTEXT_MAJOR_VERSION;
/// OpenGL context minor version; see Remarks for details
pub const CONTEXT_MINOR_VERSION = c.SDL_GL_CONTEXT_MINOR_VERSION;
/// some combination of 0 or more of elements of the SDL_GLcontextFlag enumeration; defaults to 0some combination of 0 or more of elements of the SDL_GLcontextFlag enumeration; defaults to 0
pub const CONTEXT_FLAGS = c.SDL_GL_CONTEXT_FLAGS;
/// type of GL context (Core, Compatibility, ES). See SDL_GLprofile; default value depends on platform
pub const CONTEXT_PROFILE_MASK = c.SDL_GL_CONTEXT_PROFILE_MASK;
/// OpenGL context sharing; defaults to 0
pub const SHARE_WITH_CURRENT_CONTEXT = c.SDL_GL_SHARE_WITH_CURRENT_CONTEXT;
///requests sRGB capable visual; defaults to 0 (>= SDL 2.0.1)
pub const FRAMEBUFFER_SRGB_CAPABLE = c.SDL_GL_FRAMEBUFFER_SRGB_CAPABLE;
/// sets context the release behavior; defaults to 1 (>= SDL 2.0.4)
pub const CONTEXT_RELEASE_BEHAVIOR = c.SDL_GL_CONTEXT_RELEASE_BEHAVIOR;




/// OpenGL core profile - deprecated functions are disabled
pub const CONTEXT_PROFILE_CORE = c.SDL_GL_CONTEXT_PROFILE_CORE;
/// OpenGL compatibility profile - deprecated functions are allowed
pub const CONTEXT_PROFILE_COMPATIBILITY = c.SDL_GL_CONTEXT_PROFILE_COMPATIBILITY;
/// OpenGL ES profile - only a subset of the base OpenGL functionality is available
pub const CONTEXT_PROFILE_ES = c.SDL_GL_CONTEXT_PROFILE_ES;



pub inline fn SetAttribute(attr: GLattr, value: c_int) !void 
{
    if(c.SDL_GL_SetAttribute(attr, value) != 0) return Error.SDL_GL_error;
}

/// Get the actual value for an attribute from the current context.
pub inline fn GetAttribute(attr: GLattr, value: *c_int) !void 
{
    if(c.SDL_GL_GetAttribute(attr, value) != 0) return Error.SDL_GL_error;
}

pub inline fn CreateContext(window: SDL.Window) Context
{
    return c.SDL_GL_CreateContext(window);
}

/// Delete an OpenGL context.
pub inline fn DeleteContext(context: Context) void
{
    c.SDL_GL_DeleteContext(context);
}

pub inline fn GetProcAddress(entry_point: [:0]const u8) ?*anyopaque
{
    return c.SDL_GL_GetProcAddress(entry_point);
}

/// Set up an OpenGL context for rendering into an OpenGL window.
pub inline fn MakeCurrent(window: SDL.Window, context: Context) !void
{
    if(c.SDL_GL_MakeCurrent(window, context) != 0) return Error.SDL_GL_error;
}

/// Get the size of a window's underlying drawable in pixels.
pub inline fn GetDrawableSize(window: SDL.Window, w: *c_int, h: *c_int) void
{
    c.SDL_GL_GetDrawableSize(window, w, h);
}

/// Update a window with OpenGL rendering.
pub inline fn SwapWindow(window: SDL.Window) void
{
    c.SDL_GL_SwapWindow(window);
}
