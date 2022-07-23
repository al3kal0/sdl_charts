const std = @import("std");
const gl = @import("opengl_bindings.zig");
const SDL = @import("sdl2.zig");
const SDL_GL = @import("sdl2_gl.zig");
const Sk = @import("sk.zig");
const c = @import("c.zig");

const kNumPoints = 5;
const kStencilBits = 8; 
// If you want multisampling, uncomment the below lines and set a sample count
const kMsaaSampleCount = 0; //4;
// SDL_GL_SetAttribute(SDL_GL_MULTISAMPLEBUFFERS, 1);
// SDL_GL_SetAttribute(SDL_GL_MULTISAMPLESAMPLES, kMsaaSampleCount);

fn create_star(canvas: Sk.Canvas) void
{
    _ = canvas;   
}

// necessary to load OpenGL functions
fn wrapper(ctx: void, entry_point: [:0]const u8) ?*anyopaque
{
    _ = ctx;
    return SDL_GL.GetProcAddress(entry_point);
}

pub fn main() !void
{
    var rect = Sk.Rect{ .left = 0.0, .top =0.0, .right = 200.0, .bottom = 100.0 };

    try SDL.Init(SDL.INIT_VIDEO | SDL.INIT_EVENTS);
    defer SDL.Quit();
    
    const windowFlags = SDL.WINDOW_RESIZABLE | SDL.WINDOW_OPENGL;

    try SDL_GL.SetAttribute(SDL_GL.CONTEXT_MAJOR_VERSION, 3);
    try SDL_GL.SetAttribute(SDL_GL.CONTEXT_MINOR_VERSION, 3);
    
    try SDL_GL.SetAttribute(SDL_GL.CONTEXT_PROFILE_MASK, SDL_GL.CONTEXT_PROFILE_CORE);
    try SDL_GL.SetAttribute(SDL_GL.RED_SIZE, 8);
    try SDL_GL.SetAttribute(SDL_GL.GREEN_SIZE, 8);
    try SDL_GL.SetAttribute(SDL_GL.BLUE_SIZE, 8);
    try SDL_GL.SetAttribute(SDL_GL.DOUBLEBUFFER, 1);
    try SDL_GL.SetAttribute(SDL_GL.DEPTH_SIZE, 0);
    try SDL_GL.SetAttribute(SDL_GL.STENCIL_SIZE, kStencilBits);
    try SDL_GL.SetAttribute(SDL_GL.ACCELERATED_VISUAL, 1);
   


    var dm: SDL.DisplayMode = undefined;
    try SDL.GetDesktopDisplayMode(0, &dm);

    dm.h = 600;
    dm.w = 500;
    var window = SDL.CreateWindow("SDL Window", SDL.WINDOWPOS_CENTERED, SDL.WINDOWPOS_CENTERED, 500, 600, windowFlags);
    defer SDL.DestroyWindow(window);
    var context = SDL_GL.CreateContext(window);
    defer SDL_GL.DeleteContext(context);

    gl.load({}, wrapper) catch
    {
       std.debug.panic("failed to initialize GL functions\n", .{});
    };

    try SDL_GL.MakeCurrent(window, context);        

    // const windowFormat = SDL.GetWindowPixelFormat(window);
    var contextType: i32 = undefined;
    try SDL_GL.GetAttribute(SDL_GL.CONTEXT_PROFILE_MASK, &contextType);

    var dw: c_int = undefined;
    var dh: c_int = undefined;
    SDL_GL.GetDrawableSize(window, &dw, &dh);

    gl.viewport(0, 0, dw, dh);
    gl.clearColor(1.0, 1.0, 1.0, 1.0);
    gl.clearStencil(0);
    gl.clear(gl.COLOR_BUFFER_BIT | gl.STENCIL_BUFFER_BIT);

    var interface = c.gr_glinterface_create_native_interface();
    var grContext = c.gr_direct_context_make_gl(interface);
    
    var buffer: gl.GLint = undefined;
    gl.getIntegerv(gl.FRAMEBUFFER_BINDING, &buffer);

    var info: c.gr_gl_framebufferinfo_t = .{
        .fFBOID = @intCast(c_uint, buffer),
        .fFormat = gl.RGB8,
    };


    // var recodingContext: *anyopaque = undefined;

    var target = c.gr_backendrendertarget_new_gl(dw, dh, kMsaaSampleCount, kStencilBits, &info);
    var props = c.sk_surfaceprops_new(c.USE_DEVICE_INDEPENDENT_FONTS_SK_SURFACE_PROPS_FLAGS, c.RGB_H_SK_PIXELGEOMETRY);
    var surface = c.sk_surface_new_backend_render_target(
        @ptrCast(*c.gr_recording_context_t, grContext),
        target,
        c.BOTTOM_LEFT_GR_SURFACE_ORIGIN,
        c.RGB_888X_SK_COLORTYPE,
        c.sk_colorspace_new_srgb(),
        props,
    );

    var canvas =  c.sk_surface_get_canvas(surface);
    var paint = c.sk_paint_new(); //c.sk_paint_new();
    c.sk_paint_set_antialias(paint, true);
    c.sk_paint_set_stroke_width(paint, 12.0);
    c.sk_paint_set_color(paint, Sk.Colors.Green);
    c.sk_paint_set_blendmode(paint, Sk.BlendMode.Color);
    c.sk_paint_set_style(paint, Sk.PaintStyle.StrokeAndFill);

    // const helpMessage: [:0]const u8 = "Click and drag to create rects.  Press esc to quit.";

    // var cpuSurface =

    // var font = c.sk_font_new_with_values(sk_typeface_t* typeface, float size, float scaleX, float skewX);

    var quit = false;
    while(!quit)
    {
        var event: SDL.Event = undefined;
        
        while(SDL.PollEvent(&event))
        {
            switch(event.type)
            {
                c.SDL_QUIT => quit = true,
                c.SDLK_ESCAPE => quit = true,
                else => {},
            }

            // try ImGui.ImplSDL2_ProcessEvent(&event);
            if(event.type == c.SDL_KEYDOWN and event.key.keysym.sym == c.SDLK_ESCAPE) quit = true;
        }

        // c.sk_surface_flush(surface);
        // c.gr_direct_context_flush_and_submit(grContext, false);
        _ = rect;
        // _ = canvas;
        _ = paint;

        gl.clearColor(0.3, 0.1, 0.5, 0.9);
        gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
        c.sk_canvas_clear(canvas, Sk.Colors.Blue);
        c.sk_canvas_draw_rect(canvas, &rect, paint);
        // c.sk_canvas_restore(canvas);
        c.sk_canvas_flush(canvas);
        SDL_GL.SwapWindow(window);
    }

    std.debug.print("exits normally\n", .{});
}
