const c = @import("c.zig");
const SDL = @import("sdl2.zig");

pub const Error = error{ ImGui_error };

pub inline fn CreateContext(shared_font_atlas: ?*c.ImFontAtlas) ?*c.ImGuiContext { return c.igCreateContext(shared_font_atlas); }
pub inline fn StyleColorsDark(dst: ?*c.ImGuiStyle) void { c.igStyleColorsDark(dst); }
pub inline fn ImplSDL2_InitForSDLRenderer(window: SDL.Window) !void {  if(!c.ImGui_ImplSDL2_InitForSDLRenderer(window)) return Error.ImGui_error; }
pub inline fn ImplSDL2_Shutdown() void { c.ImGui_ImplSDL2_Shutdown(); }
pub inline fn ImplSDL2_NewFrame() void { c.ImGui_ImplSDL2_NewFrame(); }
pub inline fn DestroyContext(ctx: ?*c.ImGuiContext) void { c.igDestroyContext(ctx); }
pub inline fn NewFrame() void { c.igNewFrame(); }
pub inline fn EndFrame() void { c.igEndFrame(); }
pub inline fn Render() void { c.igRender(); }

pub inline fn Begin(name: []const u8, p_open: ?*bool, flags: c.ImGuiWindowFlags) bool { 
    return c.igBegin(@ptrCast([*c]const u8, name), p_open, flags); 
}

pub inline fn End() void { 
    c.igEnd(); 
}

pub inline fn Text(fmt: []const u8) void { 
    c.igText(@ptrCast([*c]const u8, fmt)); 
}

pub inline fn CheckBox(label: []const u8, v: ?*bool) bool { 
    return c.igCheckbox(@ptrCast([*c]const u8, label), v); 
}

pub inline fn SliderFloat(label: []const u8, v: *f32, v_min: f32, v_max: f32, format: []const u8, flags: c.ImGuiSliderFlags) bool { 
    return c.igSliderFloat(@ptrCast([*c]const u8, label), v, v_min, v_max, @ptrCast([*c]const u8, format), flags); 
}

pub inline fn ShowDemoWindow(p_open: ?*bool) void { 
    c.igShowDemoWindow(p_open); 
}

pub inline fn ImplSDL2_ProcessEvent(event: *const SDL.Event) !void { 
    if(c.ImGui_ImplSDL2_ProcessEvent(event)) return Error.ImGui_error; 
}
