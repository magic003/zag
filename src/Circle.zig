const Point = @import("Point.zig");

/// A circle.
pub const Circle = @This();

/// The center of the circle.
center: Point,
/// The radius of the circle.
radius: f64,
