

pub const Vector3 = struct
{
    x: f32,
    y: f32,
    z: f32,

    pub fn mul(v: *Vector3, s: f32) *Vector3
    {
        v.x *= s;
        v.y *= s;
        v.z *= s;
        
        return v;
    }

    pub fn div(v: *Vector3, s: f32) *Vector3
    {
        v.x /= s;
        v.y /= s;
        v.z /= s;

        return v;
    }

    pub inline fn magnitude(v: *const Vector3) f32
    {
        return @sqrt(v.x*v.x + v.y*v.y + v.z*v.z);
    }

    pub fn normalize(v: *const Vector3) Vector3
    {
        const s = v.magnitude();
            
        return .{
            .x = v.x / s,
            .y = v.y / s,
            .z = v.z / s
        };
    }

    pub fn add(v: *Vector3, s: *const Vector3) *Vector3
    {
        v.x += s.x;
        v.y += s.y;
        v.z += s.z;

        return v; 
    }

    pub fn diff(v: *Vector3, s: *const Vector3) *Vector3
    {
        v.x -= s.x;
        v.y -= s.y;
        v.z -= s.z;

        return v; 
    }
};
