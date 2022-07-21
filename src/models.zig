
const c = @import("c.zig");
const glm = @import("glm.zig");
const Vec2 = glm.Vec2;
const Vec3 = glm.Vec3;
const SkPoint = c.sk_point_t;
const SkColor =  c.sk_color_t;




pub const Bounds2 = struct
{
    xmin: f32,
    xmax: f32,
    ymin: f32, 
    ymax: f32,

    pub fn getBounds(data: []Vec2) Bounds2
    {
        var xmin = undefined;
        var xmax = undefined;
        var ymin = undefined;
        var ymax = undefined;

        for(data) |vec|
        {
            xmin = if(vec.x < xmin) vec.x else xmin;
            xmax = if(vec.x > xmax) vec.x else xmax;
            ymin = if(vec.y < ymin) vec.y else ymin;
            ymax = if(vec.y > ymax) vec.y else ymax;            
        }

        return .{ xmin, xmax, ymin, ymax };
    }
};


pub const Bounds3 = struct
{
    xmin: f32,
    xmax: f32,
    ymin: f32, 
    ymax: f32,
    zmin: f32,
    zmax: f32,

    pub fn getBounds(data: []Vec2) Bounds2
    {
        var xmin = undefined;
        var xmax = undefined;
        var ymin = undefined;
        var ymax = undefined;
        var zmin = undefined;
        var zmax = undefined;

        for(data) |vec|
        {
            xmin = if(vec.x < xmin) vec.x else xmin;
            xmax = if(vec.x > xmax) vec.x else xmax;
            ymin = if(vec.y < ymin) vec.y else ymin;
            ymax = if(vec.y > ymax) vec.y else ymax;  
            zmin = if(vec.z < zmin) vec.z else zmin;
            zmax = if(vec.z > zmax) vec.z else zmax;   
                      
        }

        return .{ xmin, xmax, ymin, ymax, zmin, zmax };
    }
};


pub const Model2 = struct
{
    data: []Vec2,
    vertices: []SkPoint,
    color: []SkColors,
    bounds: Bounds2,
    isVisible: bool,
    chartType: ChartType2,
    colormap: Colormap,
    color: SkColor,
    count: u32,
    stroke: f32,
    isSingleColor: bool,
    name: []const u8,

    pub fn create(allocator: *Allocator, args: anytype) Model2
    {
        var self = try allocator.create(Model2);
        self.data= args[0];
        self.color = args[1];
        self.vertices = switch(args[2])
        {
            // .Bar => self.vertices = try allocator.alloc()
        };
        
    }
};


pub const Model3 = struct
{
    data: []Vec3,
    indices: []u16,
    vertices: []SkPoint,
    colors: []SkColors,
    bounds: Bounds3,
    chartType: ChartType3,
    colormap: Colormap,
    color: SkColor,
    isVisible: bool,
    stroke: f32,
    isSingleColor: bool,
    name: []const u8,
    
};


