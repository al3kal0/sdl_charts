
const glm = @import("glm.zig");
const vec3 = glm.vec3;

const SkPaint = c.sk_paint_t;
const SkColor = c_uint;
const SkFont = c.sk_font_t;


pub const Chart3DType = enum
{
    Arrows,
    Line3D,
    Points,
    Surface,        
};


var stringPool: [2048]u8 = undefined;      // holds the labels slices


pub const Chart3D = struct
{
    bounds: Bounds3,
    fill: SkPaint,
    colorbar: Colorbar,

    dX: f32,
    dY: f32,
    dZ: f32,

    xtick: f32 = 2,
    ytick: f32 = 2,
    ztick: f32 = 4,

    xindex: f32,
    yindex: f32,
    zindex: f32,

    axisThickness: f32 = 1.8,
    gridlineThickness: f32 = 1.4,

    tickFontSize: f32 = 6.0,
    titleFontSize: f32 = 14.0,
    labelFontSize: f32 = 12.0,

    isXGrid: bool = true,
    isYGrid: bool = true,
    isZGrid: bool = true,
    isColorBar: bool = false,
    isColorMap: bool = false,
    isHiddenLine: bool = true,
    isInterp: bool = false,
    isBarSingleColor: bool = true,
    isLineColorMatch: bool = false,

    //private SKPoint title_pos;
    title: []const u8,
    xtitle: []const u8, 
    ytitle: []const u8, 
    ztitle: []const u8, 

    axis: [4]SkPoint,
    pta: [8]Vec3,

    tick_color: SkColor,
    title_color: SkColor,
    label_color: SkColor,
    grindline_color: SkColor,
    axis_color: SkColor,

    tick_paint: SkPaint,
    title_paint: SkPaint,
    label_paint: SkPaint,
    grindline_paint: SkPaint,
    axis_paint: SkPaint,

    title_font: SkFont,
    tick_font: SkFont,
    label_font: SkFont,


    const ColormapWidth = 100;
    const ChartWidth = 600;
    const Width = ChartWidth + ColormapWidth;
    const Height = 400;

    fn resetMinMax(self: *Chart3) void
    {
        for(self.models) |model|
        {
            try setMinMax(&self.bounds, &model.bounds);
        }
    }


    fn setMinMax(a: *Bounds3, b: *const Bounds3) !void
    {
        const xmin = math.min(a.xmin, b.xmin);
        const xmax = math.max(a.xmax, b.xmax);
        const ymin = math.min(a.ymin, b.ymin);
        const ymax = math.max(a.ymax, b.ymax);
        const zmin = math.min(a.zmin, b.zmin);
        const zmax = math.max(a.zmax, b.zmax);

        a.xmin = xmin;
        a.ymin = ymin;
        a.zmin = zmin;
        a.xmax = xmax;
        a.ymax = ymax;
        a.zmax = zmax;
    
        pta[0] = vec3(xmax, ymin, zmin);
        pta[1] = vec3(xmin, ymin, zmin);
        pta[2] = vec3(xmin, ymax, zmin);
        pta[3] = vec3(xmin, ymax, zmax);
        pta[4] = vec3(xmin, ymin, zmax);
        pta[5] = vec3(xmax, ymin, zmax);
        pta[6] = vec3(xmax, ymax, zmax);
        pta[7] = vec3(xmax, ymax, zmin);
    }
};
