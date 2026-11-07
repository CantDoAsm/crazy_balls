const std = @import("std");
const rl = @import("raylib");
const defs = @import("./defs.zig");
const ball = @import("./ball.zig");
const util = @import("./util.zig");

pub const Balls = struct {
    balls: std.ArrayList(ball.Ball),
    pub fn addBall(self: *Balls) !void {
        try self.balls.append(std.heap.page_allocator, util.makeRandomBall());
    }
    pub fn update(self: *Balls, dt: f32) !void {
        if (rl.isMouseButtonPressed(rl.MouseButton.left)) {
            try self.balls.append(std.heap.page_allocator, //
                .{
                    .radius = util.i32ToF32(rl.getRandomValue(defs.MIN_RAD, defs.MAX_RAD)), //
                    .push = util.i32ToF32(rl.getRandomValue(defs.MIN_PUSH, defs.MAX_PUSH)),
                    .pos = rl.getMousePosition(),
                    .vel = .{ .x = 0, .y = 0 },
                    .color = util.makeRandomColor(),
                });
        }
        if (self.balls.items.len == 0) return;

        var min_radius = self.balls.items[0].radius;
        var max_displacement: f32 = 0;
        for (self.balls.items) |_ball| {
            min_radius = @min(min_radius, _ball.radius);
            const speed = @sqrt(_ball.vel.x * _ball.vel.x + _ball.vel.y * _ball.vel.y);
            const acceleration = @sqrt(_ball.push * _ball.push + util.i32ToF32(defs.GRAVITY) * util.i32ToF32(defs.GRAVITY));
            max_displacement = @max(max_displacement, speed * dt + acceleration * dt * dt);
        }

        const substeps = util.f32ToI32(@max(1, @ceil(max_displacement / (min_radius / 2))));
        const step_dt = dt / util.i32ToF32(substeps);
        for (0..@intCast(substeps)) |_| {
            for (0..self.balls.items.len) |i| {
                self.balls.items[i].update(step_dt);
            }
            for (0..self.balls.items.len) |i| {
                for (i + 1..self.balls.items.len) |j| {
                    ball.applyCollisionBalls(&self.balls.items[i], &self.balls.items[j]);
                }
            }
        }
    }
    pub fn draw(self: *Balls) void {
        for (self.balls.items) |_ball| {
            rl.drawCircle(util.f32ToI32(_ball.pos.x), util.f32ToI32(_ball.pos.y), _ball.radius, _ball.color);
        }
    }
};
