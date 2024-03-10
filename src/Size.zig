/// A 2D size.
pub const Size = @This();

/// A size with zero width and height.
pub const ZERO = Size{
    .width = 0.0,
    .height = 0.0,
};

/// The width.
width: f64,
/// The height.
height: f64,

/// Returns the area covered by this size.
pub fn area(self: Size) f64 {
    return self.width * self.height;
}

/// Adds the size with another size.
pub fn add(self: Size, other: Size) Size {
    return Size{
        .width = self.width + other.width,
        .height = self.height + other.height,
    };
}

/// Substracts the size from another size.
pub fn sub(self: Size, other: Size) Size {
    return Size{
        .width = self.width - other.width,
        .height = self.height - other.height,
    };
}

/// Multiplies the size by a scalar.
pub fn mul(self: Size, multiplier: f64) Size {
    return Size{
        .width = self.width * multiplier,
        .height = self.height * multiplier,
    };
}

/// Divides the size by a scalar.
pub fn div(self: Size, divisor: f64) Size {
    return Size{
        .width = self.width / divisor,
        .height = self.height / divisor,
    };
}

// Unit tests below
const testing = @import("std").testing;

test area {
    const s = Size{
        .width = 3.0,
        .height = 7.0,
    };
    try testing.expectEqual(21.0, s.area());
}

test add {
    const s1 = Size{
        .width = 3.0,
        .height = 7.0,
    };
    const s2 = Size{
        .width = 1.0,
        .height = 2.5,
    };
    try testing.expectEqual(Size{ .width = 4.0, .height = 9.5 }, s1.add(s2));
}

test sub {
    const s1 = Size{
        .width = 3.0,
        .height = 7.0,
    };
    const s2 = Size{
        .width = 1.0,
        .height = 2.5,
    };
    try testing.expectEqual(Size{ .width = 2.0, .height = 4.5 }, s1.sub(s2));
}

test mul {
    const s = Size{
        .width = 3.0,
        .height = 7.0,
    };
    try testing.expectEqual(Size{ .width = 6.0, .height = 14.0 }, s.mul(2.0));
}

test div {
    const s = Size{
        .width = 3.0,
        .height = 7.0,
    };
    try testing.expectEqual(Size{ .width = 1.5, .height = 3.5 }, s.div(2.0));
}
