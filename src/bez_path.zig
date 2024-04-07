const std = @import("std");
const Allocator = std.mem.Allocator;

const Point = @import("Point.zig");

/// A Bézier path. It is represented as a list of `PathEl`s.
///
/// For an introduction of Bézier path,
/// refer to [A Primer on Bézier Curves](https://pomax.github.io/bezierinfo/).
pub const BezPath = struct {
    elements: std.ArrayList(PathEl),

    /// Creates a `BezPath` with empty path elements.
    pub fn init(allocator: Allocator) !Allocator.Error!BezPath {
        return .{
            .elements = std.ArrayList(PathEl).init(allocator),
        };
    }

    /// Releases allocated memory.
    pub fn deinit(self: BezPath) void {
        self.elements.deinit();
    }

    /// Removes the last `PathEl` from the path and returns it. Returns `null` if the path
    /// is empty.
    pub fn pop(self: *BezPath) ?PathEl {
        return self.elements.popOrNull();
    }

    /// Pushes a `PathEl` to the path. It panics if the first element of the path is not `PathEl.move_to`.
    pub fn push(self: *BezPath, el: PathEl) void {
        self.elements.append(el);
        self.checkFirstIsMoveTo();
    }

    fn checkFirstIsMoveTo(self: BezPath) void {
        if (self.elements.items.len > 0) {
            const first = self.elements.items[0];
            if (!first.isMoveTo()) {
                std.debug.panic("BezPath must begin with move_to");
            }
        }
    }
};

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
    close_path: void,

    /// Returns true if it is a move_to element.
    pub fn isMoveTo(self: PathEl) bool {
        return switch (self) {
            .move_to => true,
            else => false,
        };
    }

    // Unit tests below
    const testing = @import("std").testing;

    test isMoveTo {
        const move_to_element = PathEl{
            .move_to = Point{
                .x = 1.0,
                .y = 2.0,
            },
        };
        try testing.expect(move_to_element.isMoveTo());

        const close_path_element = PathEl{ .close_path = void{} };
        try testing.expect(!close_path_element.isMoveTo());
    }
};

test {
    std.testing.refAllDecls(@This());
}
