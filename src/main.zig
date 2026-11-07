const rl = @import("raylib");
const balls = @import("./balls.zig");
const std = @import("std");
pub fn main() anyerror!void {
    const screenWidth = 800;
    const screenHeight = 450;
    rl.setConfigFlags(.{ .window_resizable = true });
    rl.initWindow(screenWidth, screenHeight, "ball inspector");
    defer rl.closeWindow();
    rl.setTargetFPS(60);

    //var ball: Ball = .{ .radius = 20, .push = 25, .pos = .{ .x = 150, .y = 50 }, .vel = .{ .x = 0, .y = 0 }, .color = .red };
    //var ball2: Ball = .{ .radius = 20, .push = -50, .pos = .{ .x = 200, .y = 50 }, .vel = .{ .x = 0, .y = 0 }, .color = .red };
    var all_balls: balls.Balls = std.mem.zeroes(balls.Balls);
    defer all_balls.balls.deinit(std.heap.page_allocator);
    for (0..2) |_| {
        all_balls.addBall() catch unreachable;
    }
    while (!rl.windowShouldClose()) {
        all_balls.update(rl.getFrameTime()) catch unreachable;
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.black);
        all_balls.draw();
    }
}
