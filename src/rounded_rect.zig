const Rect = @import("Rect.zig");

/// Radii for the corners of a rounded retangle.
pub const RoundedRectRadii = struct {
    /// The radius of the top-left corner.
    top_left: f64,
    /// The radius of the top-right corner.
    top_right: f64,
    /// The radius of the bottom-left corner.
    bottom_left: f64,
    /// The radius of the bottom-right corner.
    bottom_right: f64,
};

/// A rounded rectangle.
pub const RoundedRect = struct {
    /// The rectangle.
    rect: Rect,
    /// The radii of the four corners.
    radii: RoundedRectRadii,
};
