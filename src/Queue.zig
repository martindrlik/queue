const std = @import("std");
const assert = std.debug.assert;

pub fn Queue(comptime T: type, capacity: usize) type {
    return struct {
        const Self = @This();

        items: [capacity]T = undefined,
        head: usize = 0,
        tail: usize = 0,
        size: usize = 0,

        pub fn add(self: *Self, item: T) !void {
            if (self.size == self.items.len) {
                return error.Full;
            }
            self.size += 1;
            self.items[self.head] = item;
            self.head = (self.head + 1) % self.items.len;
        }

        pub fn remove(self: *Self) !T {
            if (self.size == 0) {
                return error.Empty;
            }
            self.size -= 1;
            const item = self.items[self.tail];
            self.tail = (self.tail + 1) % self.items.len;
            return item;
        }
    };
}

test Queue {
    var queue = Queue(u8, 2){};
    try queue.add(1);
    try queue.add(2);
    try std.testing.expectError(error.Full, queue.add(3));
    try std.testing.expectEqual(1, try queue.remove());
    try queue.add(3);
    try std.testing.expectEqual(2, try queue.remove());
    try std.testing.expectEqual(3, try queue.remove());
    try std.testing.expectError(error.Empty, queue.remove());
}
