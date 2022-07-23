const Sk = @import("sk.zig");


pub const Colormap = enum
{
    Spring,
    Summer,
    Autumn,
    Winter,
    Gray,
    VSpectrum,
    Colored,
    Hot,
    Cool,
    Jet
};

inline fn ushort(i: usize) u16
{
    return @intCast(u16, i);
}

pub const Colorbar = struct
{
    vertices: []SK.Point,
    indices: []u16,
    colors: []SK.Color,
    border: SK.Rect,
    drawBorder: bool,
    colormap: Colormap,
    fontSize: f32,
    left: f32,
    height: f32,
    zmin: f32,
    zmx: f32,

    const ColormapLenght = 64.0;
    var cmap: []u8 = undefined;


    fn set_colormap(self: *Colorbar, colormap: Colormap, left: f32, height: f32, zmin: f32, zmax: f32) void
    {
        if(self.colormap != colormap){ return; }
        else { self.colormap = colormap; }
    
        var x = left;
        var y = height / 2.0 - 150.0;
        var dy = (height - 100.0) / ColormapLength; // 64f;
        var dx = 20.0;
        var value = zmax;

        const vertices = self.vertices;
        const indices = self.vertices;
        const colors = self.colors;
        
        var i: usize = 0;
        var c: usize = 0;
        var m: usize = 0;       
        while(m < vertices.len)
        {
            vertices[m + 0] = Sk.Point{ .x = x, .y = y};
            vertices[m + 1] = Sk.Point{ .x = x + dx, .y = y};
            vertices[m + 2] = Sk.Point{ .x = x + dx, .y = y + dy};
            vertices[m + 3] = Sk.Point{ .x = x, .y = y + dy};

            indices[i + 0] = ushort(m + 0);
            indices[i + 1] = ushort(m + 1);
            indices[i + 2] = ushort(m + 3);
            indices[i + 3] = ushort(m + 3);
            indices[i + 4] = ushort(m + 1);
            indices[i + 5] = ushort(m + 2);

            colors[c + 0] = ColorPicker(colormap, value, zmin, zmax);
            colors[c + 1] = ColorPicker(colormap, value, zmin, zmax);
            colors[c + 2] = ColorPicker(colormap, value, zmin, zmax);
            colors[c + 3] = ColorPicker(colormap, value, zmin, zmax);

            value -= (zmax - zmin) / 64.0;
            y += dy;

            m += 4;
            i += 6;
            c += 4;
        }
    }

    pub fn restore(self: *Colorbar, left: f32, height: f32, zmin: f32, zmax: f32, fontSize: f32) void
    {
        var x = left;
        var y = height / 2.0 - 150.0;
        var dy = (height - 100.0) / 64.0;
        var dx = 20.0;
        var value = zmax;

        set_colormap(left, height, zmin, zmax);

        var z = height / 2.0 - 150.0;
        var dz = (height - 100.0) / 5.0;
        // labels.Clear();
        // labelsPositions.Clear();

        var d = zmax;
        while(d > zmin) : (d -= (zmax - zmin) / 5.0)
        {
            // labels.Add(d.ToString("0.00"));
            // labelsPositions.Add(new SKPoint(x + dx + 10, z + fontSize / 2f));
            z += dz;
        }


        self.left = left;
        self.height = height;
        self.zmin = zmin;
        self.zmax = zmax;
        self.fontSize = fontSize;
    }



};
