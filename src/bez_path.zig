const std = @import("std");
const Allocator = std.mem.Allocator;

const Point = @import("Point.zig");

/// A Bézier path. It is represented as a list of `PathEl`s.
///
/// For an introduction of Bézier path,
/// refer to [A Primer on Bézier Curves](https://pomax.github.io/bezierinfo/).
pub const BezPath = struct {
    /// Elements in the path.
    elements: std.ArrayList(PathEl),

    /// Creates a `BezPath` with empty path elements.
    pub fn init(allocator: Allocator) BezPath {
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
    pub fn push(self: *BezPath, el: PathEl) Allocator.Error!void {
        try self.elements.append(el);
        self.panicIfNotBeginWithMoveTo();
    }

    /// Pushes a `PathEl.move_to` element onto the path.
    pub fn moveTo(self: *BezPath, p: Point) Allocator.Error!void {
        try self.push(PathEl{ .move_to = p });
    }

    /// Pushes a `PathEl.line_to` element onto the path. It panics if the path is empty.
    pub fn lineTo(self: *BezPath, p: Point) Allocator.Error!void {
        self.panicIfPathIsEmpty();
        try self.push(PathEl{ .line_to = p });
    }

    /// Pushes a `PathEl.quad_to` element onto the path. It panics if the path is empty.
    pub fn quadTo(self: *BezPath, p1: Point, p2: Point) Allocator.Error!void {
        self.panicIfPathIsEmpty();
        try self.push(PathEl{ .quad_to = [2]Point{ p1, p2 } });
    }

    /// Pushes a `PathEl.curve_to` element onto the path. It panics if the path is empty.
    pub fn curveTo(self: *BezPath, p1: Point, p2: Point, p3: Point) Allocator.Error!void {
        self.panicIfNotBeginWithMoveTo();
        try self.push(PathEl{ .curve_to = [3]Point{ p1, p2, p3 } });
    }

    /// Pushes a `PathEl.close_path` element onto the path. It panics if the path is empty.
    pub fn closePath(self: *BezPath) Allocator.Error!void {
        self.panicIfNotBeginWithMoveTo();
        try self.push(PathEl{ .close_path = void{} });
    }

    fn panicIfNotBeginWithMoveTo(self: BezPath) void {
        if (self.elements.items.len > 0) {
            const first = self.elements.items[0];
            if (!first.isMoveTo()) {
                @panic("BezPath must begin with move_to");
            }
        }
    }

    fn panicIfPathIsEmpty(self: BezPath) void {
        if (self.elements.items.len == 0) {
            @panic("Empty subpath. A subpath must begin with move_to");
        }
    }

    // Unit tests below
    const testing = @import("std").testing;

    test pop {
        var bez_path = BezPath.init(testing.allocator);
        defer bez_path.deinit();

        try testing.expectEqual(null, bez_path.pop());

        const move_to = PathEl{ .move_to = Point{
            .x = 1.0,
            .y = 2.0,
        } };
        try bez_path.push(move_to);

        try testing.expectEqual(move_to, bez_path.pop());
        try testing.expectEqual(0, bez_path.elements.items.len);
    }

    test push {
        var bez_path = BezPath.init(testing.allocator);
        defer bez_path.deinit();

        const move_to = PathEl{ .move_to = Point{
            .x = 1.0,
            .y = 2.0,
        } };
        try bez_path.push(move_to);

        try testing.expectEqual(1, bez_path.elements.items.len);
        try testing.expectEqual(move_to, bez_path.pop());
    }

    test "push should fail when it's out of memory" {
        var bez_path = BezPath.init(testing.failing_allocator);
        defer bez_path.deinit();

        const move_to = PathEl{ .move_to = Point{
            .x = 1.0,
            .y = 2.0,
        } };

        try testing.expectError(error.OutOfMemory, bez_path.push(move_to));
    }

    test moveTo {
        var bez_path = BezPath.init(testing.allocator);
        defer bez_path.deinit();

        const p = Point{
            .x = 1.0,
            .y = 2.0,
        };
        try bez_path.moveTo(p);

        try testing.expectEqual(PathEl{ .move_to = p }, bez_path.elements.items[0]);
    }

    test lineTo {
        var bez_path = BezPath.init(testing.allocator);
        defer bez_path.deinit();

        const origin = Point{
            .x = 1.0,
            .y = 2.0,
        };
        try bez_path.moveTo(origin);

        const p = Point{
            .x = 3.0,
            .y = 4.0,
        };
        try bez_path.lineTo(p);

        try testing.expectEqual(PathEl{ .line_to = p }, bez_path.elements.items[1]);
    }

    test quadTo {
        var bez_path = BezPath.init(testing.allocator);
        defer bez_path.deinit();

        const origin = Point{
            .x = 1.0,
            .y = 2.0,
        };
        try bez_path.moveTo(origin);

        const p1 = Point{
            .x = 3.0,
            .y = 4.0,
        };
        const p2 = Point{
            .x = 5.0,
            .y = 6.0,
        };
        try bez_path.quadTo(p1, p2);

        try testing.expectEqual(PathEl{ .quad_to = [2]Point{ p1, p2 } }, bez_path.elements.items[1]);
    }

    test curveTo {
        var bez_path = BezPath.init(testing.allocator);
        defer bez_path.deinit();

        const origin = Point{
            .x = 1.0,
            .y = 2.0,
        };
        try bez_path.moveTo(origin);

        const p1 = Point{
            .x = 3.0,
            .y = 4.0,
        };
        const p2 = Point{
            .x = 5.0,
            .y = 6.0,
        };
        const p3 = Point{
            .x = 7.0,
            .y = 8.0,
        };
        try bez_path.curveTo(p1, p2, p3);

        try testing.expectEqual(PathEl{ .curve_to = [3]Point{ p1, p2, p3 } }, bez_path.elements.items[1]);
    }

    test closePath {
        var bez_path = BezPath.init(testing.allocator);
        defer bez_path.deinit();

        const p = Point{
            .x = 1.0,
            .y = 2.0,
        };
        try bez_path.moveTo(p);

        try bez_path.closePath();

        try testing.expectEqual(PathEl{ .close_path = void{} }, bez_path.elements.items[1]);
    }

    test "elements should include all added path elements" {
        var bez_path = BezPath.init(testing.allocator);
        defer bez_path.deinit();

        const origin = Point{
            .x = 1.0,
            .y = 2.0,
        };
        try bez_path.moveTo(origin);

        const p = Point{
            .x = 3.0,
            .y = 4.0,
        };
        try bez_path.lineTo(p);

        try bez_path.closePath();

        try testing.expectEqualSlices(PathEl, &[_]PathEl{
            .{ .move_to = Point{
                .x = 1.0,
                .y = 2.0,
            } },
            .{ .line_to = Point{
                .x = 3.0,
                .y = 4.0,
            } },
            .{ .close_path = void{} },
        }, bez_path.elements.items);
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
