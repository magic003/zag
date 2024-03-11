const math = @import("std").math;
const Vec2 = @import("Vec2.zig");

/// A 2D point.
pub const Point = @This();

/// The zero point (0.0, 0.0).
pub const ZERO = Point{
    .x = 0.0,
    .y = 0.0,
};

/// The x-coordinate.
x: f64,
/// The y-coordinate.
y: f64,

/// Returns the midpoint of two points.
pub fn midpoint(self: Point, other: Point) Point {
    return Point{
        .x = (self.x + other.x) * 0.5,
        .y = (self.y + other.y) * 0.5,
    };
}

/// Returns the Euclidean distance of two points.
pub fn distance(self: Point, other: Point) f64 {
    const x = self.x - other.x;
    const y = self.y - other.y;
    return math.hypot(f64, x, y);
}

/// Adds the point to a directional vector and returns the new point.
pub fn add(self: Point, dir: Vec2) Point {
    return Point{
        .x = self.x + dir.x,
        .y = self.y + dir.y,
    };
}

// Unit tests below
const testing = @import("std").testing;

test midpoint {
    const p1 = Point{
        .x = 10.0,
        .y = 8.0,
    };
    const p2 = Point{
        .x = 4.0,
        .y = 2.0,
    };
    try testing.expectEqual(Point{ .x = 7.0, .y = 5.0 }, p1.midpoint(p2));
}

test distance {
    const p1 = Point{
        .x = 7.0,
        .y = 8.0,
    };
    const p2 = Point{
        .x = 4.0,
        .y = 4.0,
    };
    try testing.expectEqual(5.0, p1.distance(p2));
}

test add {
    const p = Point{
        .x = 7.0,
        .y = 8.0,
    };
    const dir = Vec2{
        .x = 1.0,
        .y = 3.0,
    };
    try testing.expectEqual(Point{ .x = 8.0, .y = 11.0 }, p.add(dir));
}
