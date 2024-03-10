const math = @import("std").math;

/// A 2D vector.
pub const Vec2 = @This();

/// The zero vector (0.0, 0.0).
pub const ZERO = Vec2{
    .x = 0.0,
    .y = 0.0,
};

/// The x-coordinate.
x: f64,
/// The y-coordinate.
y: f64,

/// Dot product of two vectors.
pub fn dot(self: Vec2, other: Vec2) f64 {
    return self.x * other.x + self.y * other.y;
}

/// Magnitude of a vector.
pub fn length(self: Vec2) f64 {
    return math.hypot(f64, self.x, self.y);
}

/// Magnitude squared of a vector.
pub fn length_squared(self: Vec2) f64 {
    return self.dot(self);
}

/// Returns a vector of magnitude 1.0 with the same directionas `self`.
///
/// It returns NaN for both coordinates when the `self`'s magnitude is `0.0`.
pub fn normalize(self: Vec2) Vec2 {
    return self.div(self.length());
}

/// Adds it to another vector.
pub fn add(self: Vec2, other: Vec2) Vec2 {
    return Vec2{
        .x = self.x + other.x,
        .y = self.y + other.y,
    };
}

/// Substracts it from another vector.
pub fn sub(self: Vec2, other: Vec2) Vec2 {
    return Vec2{
        .x = self.x - other.x,
        .y = self.y - other.y,
    };
}

/// Multiples the vector by a scalar.
pub fn mul(self: Vec2, multiplier: f64) Vec2 {
    return Vec2{
        .x = self.x * multiplier,
        .y = self.y * multiplier,
    };
}

/// Divides the vector by a scalar.
pub fn div(self: Vec2, divisor: f64) Vec2 {
    return Vec2{
        .x = self.x / divisor,
        .y = self.y / divisor,
    };
}

// Unit tests below
const testing = @import("std").testing;

test dot {
    const v1 = Vec2{
        .x = 1.5,
        .y = 2.0,
    };
    const v2 = Vec2{
        .x = 2.0,
        .y = 4.0,
    };

    try testing.expectEqual(11.0, v1.dot(v2));
}

test length {
    const v = Vec2{
        .x = 3.0,
        .y = 4.0,
    };
    try testing.expectEqual(5.0, v.length());
}

test length_squared {
    const v = Vec2{
        .x = 3.0,
        .y = 4.0,
    };
    try testing.expectEqual(25.0, v.length_squared());
}

test normalize {
    const v = Vec2{
        .x = 3.0,
        .y = 4.0,
    };
    try testing.expectEqual(Vec2{ .x = 0.6, .y = 0.8 }, v.normalize());
}

test "normalize should return NaN when magnitude is 0" {
    const v = Vec2{
        .x = 0.0,
        .y = 0.0,
    };
    const norm = v.normalize();
    try testing.expect(math.isNan(norm.x));
    try testing.expect(math.isNan(norm.y));
}

test add {
    const v1 = Vec2{
        .x = 1.5,
        .y = 2.0,
    };
    const v2 = Vec2{
        .x = 2.0,
        .y = 4.0,
    };

    try testing.expectEqual(Vec2{ .x = 3.5, .y = 6.0 }, v1.add(v2));
}

test sub {
    const v1 = Vec2{
        .x = 1.5,
        .y = 2.0,
    };
    const v2 = Vec2{
        .x = 2.0,
        .y = 4.0,
    };

    try testing.expectEqual(Vec2{ .x = -0.5, .y = -2.0 }, v1.sub(v2));
}

test mul {
    const v = Vec2{
        .x = 3.0,
        .y = 4.0,
    };
    try testing.expectEqual(Vec2{ .x = 1.5, .y = 2.0 }, v.mul(0.5));
}

test div {
    const v = Vec2{
        .x = 3.0,
        .y = 4.0,
    };
    try testing.expectEqual(Vec2{ .x = 6.0, .y = 8.0 }, v.div(0.5));
}
