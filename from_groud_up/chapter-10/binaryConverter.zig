const std = @import("std");

pub fn main() !void {
    try convert(19);
}

pub fn convert(mut_number: u64) !void {
    var number = mut_number;

    if (number == 0) {
        std.debug.print("0\n", .{});
        return;
    }

    // We'll store bits into a fixed buffer (64 bits max for u64)
    var bits: [64]u8 = undefined;
    var len: usize = 0;

    while (number > 0) {
        bits[len] = @intCast(number % 2);
        number = number / 2;
        len += 1;
    }

    // Now print in reverse (because we collected LSB → MSB)
    for (bits[0..len], 0..) |_, i| {
        std.debug.print("{d}", .{bits[len - 1 - i]});
    }
    std.debug.print("\n", .{});
}

