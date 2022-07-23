

pub const Vector3 = struct
{
    x: f32,
    y: f32,
    z: f32,

    pub inline fn vec(a: f32, b: f32, c: f32) Vector3
    {
        return .{
            .x = a,
            .y = b,
            .z = c,
        };
    }

    pub fn mul(v: *const Vector3, s: f32) Vector3
    {
        return .{
            .x = v.x + s,
            .y = v.y + s,
            .z = v.z + s,
        };
    }

    pub fn div(v: *const Vector3, s: f32) Vector3
    {
        return .{
            .x = v.x / s,
            .y = v.y / s,
            .z = v.z / s,
        };
    }

    pub inline fn magnitude(v: *const Vector3) f32
    {
        return @sqrt(v.x * v.x + v.y * v.y + v.z * v.z);
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

    pub fn add(v: *const Vector3, s: *const Vector3) Vector3
    {
        return .{
            .x = v.x + s.x,
            .y = v.y + s.y,
            .z = v.z + s.z,
        };
    }

    pub fn sub(v: *const Vector3, s: *const Vector3) Vector3
    {
        return .{
            .x = v.x - s.x,
            .y = v.y - s.y,
            .z = v.z - s.z,
        }; 
    }

    pub fn dot(a: *const Vector3, b: *const Vector3) f32
    {
        return a.x * b.x + a.y * b.y + a.z * b.z;
    }

    pub fn cross(a: *const Vector3, b: *const Vector3) Vector3
    {
        return .{ 
            .x = a.y * b.z - a.z * b.y,
            .y = a.z * b.x - a.x * b.z,
            .z = a.x * b.y - a.y * b.x,
        };
    }

    pub fn project(a: *const Vector3, b: *const Vector3) Vector3
    {
        const s = dot(a, b) / dot(b, b);

        return mul(b, s);
    }

    pub fn reject(a: *const Vector3, b: *const Vector3) Vector3
    {
        const s = dot(a, b) / dot(a, b);
        const _b = &mul(b, s);

        return sub(a, _b);
    }
};

// pub const Matrix3x3 = struct
// {
    // n00: f32, n01: f32, n02: f32,
    // n10: f32, n11: f32, n12: f32,
    // n20: f32, n21: f32, n22: f32,
// };


pub const Matrix3x3 = struct
{
    val: [3][3]f32,

    pub inline fn matrix(a00: f32, a01: f32, a02: f32,
                      a10: f32, a11: f32, a12: f32,
                      a20: f32, a21: f32, a22: f32
    ) Matrix3x3
    {
        return .{
            .val = [3]f32{ 
                [_]f32{a00, a01, a02},
                [_]f32{a10, a11, a12},
                [_]f32{a20, a21, a22},
            },    
        };
    }

    pub fn mul(A: *const Matrix3x3, B: *const Matrix3x3) Matrix3x3
    {
        var C: Matrix3x3 = undefined;
        const a = A.val;
        const b = B.val;
        const c = C.val;
        
        c[0][0] = a[0][0]*b[0][0] + a[0][1]*b[1][0] + a[0][2]*b[2][0];
        c[0][1] = a[0][0]*b[0][1] + a[0][1]*b[1][1] + a[0][2]*b[2][1];
        c[0][2] = a[0][0]*b[0][2] + a[0][1]*b[1][2] + a[0][2]*b[2][2];
        c[1][0] = a[1][0]*b[0][0] + a[1][1]*b[1][0] + a[1][2]*b[2][0];
        c[1][1] = a[1][0]*b[0][1] + a[1][1]*b[1][1] + a[1][2]*b[2][1];
        c[1][2] = a[1][0]*b[0][2] + a[1][1]*b[1][2] + a[1][2]*b[2][2];
        c[2][0] = a[2][0]*b[0][0] + a[2][1]*b[1][0] + a[2][2]*b[2][0];
        c[2][1] = a[2][0]*b[0][1] + a[2][1]*b[1][1] + a[2][2]*b[2][1];
        c[2][2] = a[2][0]*b[0][2] + a[2][1]*b[1][2] + a[2][2]*b[2][2];

        return c;
    }

    /// Multiplies a matrix with a vector and creates a new vector3 // i.e the transformed vector3
    pub fn mul_vec(mat: *const Matrix3x3, v: *const Vector3) Vector3
    {        
        const m = mat.val;

        return .{
            .x = m[0][0]*v.x + m[0][1]*v.y + m[0][2]*v.z,
            .y = m[1][0]*v.x + m[1][1]*v.y + m[1][2]*v.z,
            .x = m[2][0]*v.x + m[2][1]*v.y + m[2][2]*v.z,            
        };
    }

    pub fn identity() Matrix3x3
    {
        return matrix(1.0, 0.0, 0.0,
                      0.0, 1.0, 0.0,
                      0.0, 0.0, 1.0,
                      );
    }

    pub fn determinant(mat: *const Matrix3x3) f32
    {
        const m = mat.val;

        return (m[0][0] * (m[1][1] * m[1][2] - m[1][2] * m[2][1])
             + m[0][1] * (m[1][2] * m[2][0] - m[1][0] * m[2][2])
             + m[0][2] * (m[1][0] * m[2][1] - m[1][1] * m[2][0]));
    }

    pub fn inverse(mat: *const Matrix3x3) Matrix3x3
    {
        const m = mat.val;
        const a = &Vector3.vec(m[0][0], m[0][1], m[0][2]);
        const b = &Vector3.vec(m[1][0], m[1][1], m[1][2]);
        const c = &Vector3.vec(m[2][0], m[2][1], m[2][2]);

        const cross = Vector3.cross;
        const dot = Vector3.dot;

        const r0 = &cross(b, c);
        const r1 = &cross(c, a);
        const r2 = &cross(a, b);

        const invDet = 1.0 / dot(r2, c);

        return matrix(r0.x * invDet, r0.y * invDet, r0.z * invDet,
                      r1.x * invDet, r1.y * invDet, r1.z * invDet,        
                      r2.x * invDet, r2.y * invDet, r2.z * invDet,
                      );        
    }

    pub fn makeRotationX(t: f32) Matrix3x3
    {
        const c = @cos(t);
        const s = @sin(t);

        return matrix(1.0, 0.0, 0.0,
                      0.0,   c,  -s,
                      0.0,   s,   c,
                      );
    }

    pub fn makeRotationY(t: f32) Matrix3x3
    {
        const c = @cos(t);
        const s = @sin(t);

        return matrix(c,   0.0,   s,
                      0.0, 1.0, 0.0,
                      -s,  0.0,   c,
                      );
    }

    pub fn makeRotationZ(t: f32) Matrix3x3
    {
        const c = @cos(t);
        const s = @sin(t);

        return matrix(c,    -s, 0.0,
                      s,     c, 0.0,
                      0.0, 0.0, 1.0,
                      );
    }

    pub fn makeRotation(t: f32, a: *const Vector3) Matrix3x3
    {
        const c = @cos(t);
        const s = @sin(t);
        const d = 1.0 - c;
        const x = a.x * d; 
        const y = a.y * d; 
        const z = a.z * d;
        const axay = x * a.y; 
        const axaz = x * a.z; 
        const ayaz = y * a.z; 

        return matrix(c + x * a.x, axay -s * a.z, axaz + s * a.y,
                      axay + s * a.z, c + y * a.y, ayaz - s * a.x,
                      axaz - s * a.y, ayaz + s * a.x, c + z * a.z
                      );
    }

    pub fn makeScale(s: f32, a: *const Vector3) Matrix3x3
    {
        s -= 1.0;
        const x = a.x * s;        
        const y = a.y * s;        
        const z = a.z * s;
        const axay = x * a.y;
        const axaz = x * a.z;
        const ayaz = y * a.z;

        return matrix(x * a.x + 1.0, axay, axaz,
                      axay, y * a.y + 1.0, ayaz,
                      axaz, ayaz, z * a.z + 1.0);        
    }

    pub fn makeScale3(sx: f32, sy: f32, sz: f32) Matrix3x3
    {
        return matrix(sx, 0.0, 0.0, 0.0, sy, 0.0, 0.0, 0.0, sz);
    }
    
    
};


pub const Matrix4x4 = struct
{
    val: [4][4]f32,

    pub inline fn matrix(a00: f32, a01: f32, a02: f32, a03: f32,
                         a10: f32, a11: f32, a12: f32, a13: f32,
                         a20: f32, a21: f32, a22: f32, a23: f32,
                         a30: f32, a31: f32, a32: f32, a33: f32,
    ) Matrix4x4
    {
        return .{
            .val = [4]f32{ 
                [_]f32{a00, a01, a02, a03},
                [_]f32{a10, a11, a12, a13},
                [_]f32{a20, a21, a22, a23},
                [_]f32{a30, a31, a32, a33},
            },    
        };
    }
    
    pub inline fn transform(a00: f32, a01: f32, a02: f32, a03: f32,
                            a10: f32, a11: f32, a12: f32, a13: f32,
                            a20: f32, a21: f32, a22: f32, a23: f32,
    ) Matrix4x4
    {
        return .{
            .val = [4]f32{ 
                [_]f32{a00, a01, a02, a03},
                [_]f32{a10, a11, a12, a13},
                [_]f32{a20, a21, a22, a23},
                [_]f32{0.0, 0.0, 0.0, 1.0},
            },    
        };
    }
    
    pub fn getTranslation(self: *const Matrix4x4) Vector3
    {
        const v = self.val[3];

        return .{
             .x = v[0],
             .y = v[1],
             .z = v[2],
        };
    }
    
    pub fn setTranslation(self: *Matrix4x4, v: Vector3) void
    {
        var m = self.val[3];

        m[0] = v.x; 
        m[1] = v.y; 
        m[2] = v.z; 
    }

    pub fn inverse(mat: *const Matrix4x4) Matrix4x4
    {
        const m = mat.val;
        const a = &Vector3.vec(m[0][0], m[1][0], m[2][0]);
        const b = &Vector3.vec(m[0][1], m[1][1], m[2][1]);
        const c = &Vector3.vec(m[0][2], m[1][2], m[2][2]);
        const d = &Vector3.vec(m[0][3], m[1][3], m[2][3]);

        const x = m[3][0];
        const y = m[3][1];
        const z = m[3][2];
        const w = m[3][3];

        const cross = Vector3.cross;
        const sub = Vector3.sub;
        const _mul = Vector3.mul;
        const dot = Vector3.dot;
        const add = Vector3.add;

        var s = &cross(a, b);
        var t = &cross(c, d);
        var u = &sub(mul(a, y), mul(b, x));
        var v = &sub(mul(c, w), mul(d, z));

        const invDet = 1.0 / (dot(s, v) + dot(t, u));
        s.* = mul(s, invDet);
        t.* = mul(t, invDet);        
        u.* = mul(u, invDet);        
        v.* = mul(v, invDet);        

        const r0 = &add(cross(b, v), (_mul(t, y)));
        const r1 = &sub(cross(v, a), (_mul(t, x)));
        const r2 = &add(cross(d, u), (_mul(s, w)));
        const r3 = &sub(cross(u, c), (_mul(s, z)));

        return matrix(r0.x, r0.y, r0.z, -dot(b, t),
                      r1.x, r1.y, r1.z, dot(a, t),
                      r2.x, r2.y, r2.z, -dot(d, s),
                      r3.x, r3.y, r3.z, dot(c, s),
                      );
    }
    
    pub fn mul(A: *const Matrix4x4, B: *const Matrix4x4) Matrix4x4
    {
        const a = A.val;
        const b = B.val;
        
        return transform(a[0][0] * b[0][0] + a[0][1] * b[1][0] + a[0][2] * b[2][0],
                         a[0][0] * b[0][1] + a[0][1] * b[1][1] + a[0][2] * b[2][1],
                         a[0][0] * b[0][2] + a[0][1] * b[1][2] + a[0][2] * b[2][2],
                         a[0][0] * b[0][3] + a[0][1] * b[1][3] + a[0][2] * b[2][3] + a[0][3],
                         a[1][0] * b[0][0] + a[1][1] * b[1][0] + a[1][2] * b[2][0],
                         a[1][0] * b[0][1] + a[1][1] * b[1][1] + a[1][2] * b[2][1],
                         a[1][0] * b[0][2] + a[1][1] * b[1][2] + a[1][2] * b[2][2],
                         a[1][0] * b[0][3] + a[1][1] * b[1][3] + a[1][2] * b[2][3] + a[1][3],
                         a[2][0] * b[0][0] + a[2][1] * b[1][0] + a[2][2] * b[2][0],
                         a[2][0] * b[0][1] + a[2][1] * b[1][1] + a[2][2] * b[2][1],
                         a[2][0] * b[0][2] + a[2][1] * b[1][2] + a[2][2] * b[2][2],
                         a[2][0] * b[0][3] + a[2][1] * b[1][3] + a[2][2] * b[2][3] + a[2][3],
                        );
    }
    
    pub fn mul_vec(mat: *const Matrix4x4, v: *const Vector3) Vector3
    {
        const m = mat.val;
    
        return Vector3.vec(m[0][0] * v.x + m[0][1] * v.y + m[0][2] * v.z,
                           m[1][0] * v.x + m[1][1] * v.y + m[1][2] * v.z,
                           m[2][0] * v.x + m[2][1] * v.y + m[2][2] * v.z,
        );
    }
    
    pub fn makeOrthoProjection(t: f32, r: f32, b: f32, n: f32, f: f32) Matrix4x4
    {
        const w_inv = 1.0 / (r - 1.0);
        const h_inv = 1.0 / (b - t);
        const d_inv = 1.0 / (f - n);
        
        return matrix(2.0 * w_inv, 0.0, 0.0, -(r + 1.0) * w_inv,
                      0.0, 2.0 * h_inv, 0.0, -(b + t) * h_inv,
                      0.0, 0.0, d_inv, -n * d_inv,
                      0.0, 0.0, 0.0, 1.0
                      );        
    }
    
    
};
