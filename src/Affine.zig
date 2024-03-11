const Vec2 = @import("Vec2.zig");

pub const Affine = @This();

/// The identity transformation.
pub const IDENTITY = Affine.scale(1.0);

/// The affine transformation can be represented as an
/// [argumented matrix](https://en.wikipedia.org/wiki/Affine_transformation#Augmented_matrix).
/// The coefficients are a compact way of representing the argumented matrix.
///
/// If the coefficients are `(a, b, c, d, e, f)`, then the resulting
/// transformation represents this augmented matrix:
///
/// ```text
/// | a c e |
/// | b d f |
/// | 0 0 1 |
/// ```
coefficients: [6]f64,

/// An affine transform representing uniform scaling.
pub fn scale(s: f64) Affine {
    return Affine{
        .coefficients = [_]f64{ s, 0.0, 0.0, s, 0.0, 0.0 },
    };
}

/// An affine transform representing translation.
pub fn translate(v: Vec2) Affine {
    return Affine{
        .coefficients = [_]f64{ 1.0, 0.0, 0.0, 1.0, v.x, v.y },
    };
}
