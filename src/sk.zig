const c = @import("c.zig");

pub const Point = c.sk_point_t;
pub const Rect = c.sk_rect_t;
pub const Color = u32;                  // c.sk_color_t;

pub const Surface = ?*c.sk_surface_t;
pub const Canvas = ?*c.sk_canvas_t;
pub const Paint = ?*c.sk_paint_t;
pub const Vertices = ?*c.sk_vertices_t;
pub const Typeface = ?*c.sk_typeface_t;
pub const Path = ?*c.sk_path_t;



// enums
pub const Colors = struct
{
    pub const White = 0xFFFFFF;
    pub const Black = 0x000000;
    pub const Red = 0xDB2020;
    pub const Green = 0x26D850;
    pub const Blue = 0x2C4FFF;
    pub const Orange = 0xFFBF26;
    pub const Violet = 0x692AFC;
    pub const Yellow = 0xF7FF00;
};

pub const PaintStyle = struct
{
    pub const Fill = c.FILL_SK_PAINT_STYLE;
    pub const Stroke = c.STROKE_SK_PAINT_STYLE;
    pub const StrokeAndFill = c.STROKE_AND_FILL_SK_PAINT_STYLE;
};

pub const BlendMode = struct
{
    pub const Clear = c.CLEAR_SK_BLENDMODE;
    // pub const c.SRC_SK_BLENDMODE;
    // pub const c.DST_SK_BLENDMODE;
    // pub const c.SRCOVER_SK_BLENDMODE;
    // pub const c.DSTOVER_SK_BLENDMODE;
    // pub const c.SRCIN_SK_BLENDMODE;
    // pub const c.DSTIN_SK_BLENDMODE;
    // pub const c.SRCOUT_SK_BLENDMODE;
    // pub const c.DSTOUT_SK_BLENDMODE;
    // pub const c.SRCATOP_SK_BLENDMODE;
    // pub const c.DSTATOP_SK_BLENDMODE;
    // pub const c.XOR_SK_BLENDMODE;
    // pub const c.PLUS_SK_BLENDMODE;
    // pub const c.MODULATE_SK_BLENDMODE;
    pub const Screen =  c.SCREEN_SK_BLENDMODE;
    // pub const c.OVERLAY_SK_BLENDMODE;
    // pub const c.DARKEN_SK_BLENDMODE;
    // pub const c.LIGHTEN_SK_BLENDMODE;
    // pub const c.COLORDODGE_SK_BLENDMODE;
    // pub const c.COLORBURN_SK_BLENDMODE;
    // pub const c.HARDLIGHT_SK_BLENDMODE;
    // pub const c.SOFTLIGHT_SK_BLENDMODE;
    // pub const c.DIFFERENCE_SK_BLENDMODE;
    // pub const c.EXCLUSION_SK_BLENDMODE;
    // pub const c.MULTIPLY_SK_BLENDMODE;
    pub const Hue = c.HUE_SK_BLENDMODE;
    pub const Saturarion = c.SATURATION_SK_BLENDMODE;
    pub const Color = c.COLOR_SK_BLENDMODE;
    pub const Luminosity = c.LUMINOSITY_SK_BLENDMODE;
};
