const Point = @import("Point.zig");

/// A line.
pub const Line = @This();

/// The line's start point.
start: Point,
/// The line's end point.
end: Point,
