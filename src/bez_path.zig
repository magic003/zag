const Point = @import("Point.zig");

/// The element of a Bézier path.
///
/// A valid path has `move_to` at the beginning of each subpath.
pub const PathEl = union(enum) {
    /// Moves directly to a point without drawing anything, starting a new subpath.
    move_to: Point,
    /// Draws a line from the current point to the point.
    line_to: Point,
    /// Draws a quadratic bezier path using the current point and the two points.
    quad_to: [2]Point,
    /// Draws a cubic bezier path using the current point and the three points.
    curve_to: [3]Point,
    /// Closes off the path.
    close_path,
};
