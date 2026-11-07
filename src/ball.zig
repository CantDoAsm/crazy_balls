const std = @import("std");
const rl = @import("raylib");
const util = @import("./util.zig");
const defs = @import("./defs.zig");
pub fn applyCollisionBalls(b1: *Ball, b2: *Ball) void {
    if (rl.checkCollisionCircles(b1.pos, b1.radius, b2.pos, b2.radius)) {
        const dx = b2.pos.x - b1.pos.x;
        const dy = b2.pos.y - b1.pos.y;
        const distance_squared = dx * dx + dy * dy;
        const distance = @sqrt(distance_squared);
        const normal_x = if (distance > 0) dx / distance else 1;
        const normal_y = if (distance > 0) dy / distance else 0;
        const overlap = b1.radius + b2.radius - distance + defs.COLLISION_SLOP;

        b1.pos.x -= normal_x * overlap / 2;
        b1.pos.y -= normal_y * overlap / 2;
        b2.pos.x += normal_x * overlap / 2;
        b2.pos.y += normal_y * overlap / 2;

        const relative_velocity_x = b2.vel.x - b1.vel.x;
        const relative_velocity_y = b2.vel.y - b1.vel.y;
        const normal_velocity = relative_velocity_x * normal_x + relative_velocity_y * normal_y;
        if (normal_velocity < 0) {
            b1.vel.x += normal_velocity * normal_x - defs.COLLISION_BOOST * normal_x;
            b1.vel.y += normal_velocity * normal_y - defs.COLLISION_BOOST * normal_y;
            b2.vel.x -= normal_velocity * normal_x - defs.COLLISION_BOOST * normal_x;
            b2.vel.y -= normal_velocity * normal_y - defs.COLLISION_BOOST * normal_y;
            b1.push = -b1.push;
            b2.push = -b2.push;
            b1.color = util.makeRandomColor();
            b2.color = util.makeRandomColor();
        }
    }
}
pub const Ball = struct {
    radius: f32, //
    push: f32,
    pos: rl.Vector2,
    vel: rl.Vector2,
    color: rl.Color,

    fn applyGravity(self: *Ball, dt: f32) void {
        self.vel.y += util.i32ToF32(defs.GRAVITY) * dt;
    }
    fn applyPush(self: *Ball, dt: f32) void {
        self.vel.x += self.push * dt;
    }
    fn applyVelocityX(self: *Ball, dt: f32) void {
        self.pos.x += self.vel.x * dt;
    }
    fn applyVelocityY(self: *Ball, dt: f32) void {
        self.pos.y += self.vel.y * dt;
    }
    pub fn reverseX(self: *Ball) void {
        self.vel.x = -self.vel.x;
        self.push = -self.push;
        self.color = util.makeRandomColor();
    }
    pub fn reverseY(self: *Ball) void {
        self.vel.y = -self.vel.y; ////////////
        self.color = util.makeRandomColor();
    }
    pub fn update(self: *Ball, dt: f32) void {
        applyGravity(self, dt);
        applyPush(self, dt);
        applyVelocityX(self, dt);
        applyVelocityY(self, dt);

        const screenWidth = util.i32ToF32(rl.getScreenWidth());
        const screenHeight = util.i32ToF32(rl.getScreenHeight());

        if (self.pos.y + self.radius >= screenHeight) {
            self.pos.y = screenHeight - self.radius;
            if (self.vel.y > 0) {
                self.reverseY();
            }
        }

        if (self.pos.x + self.radius >= screenWidth) {
            self.pos.x = screenWidth - self.radius;
            if (self.vel.x > 0) {
                self.reverseX();
            }
        } else if (self.pos.x - self.radius <= 0) {
            self.pos.x = self.radius;
            if (self.vel.x < 0) {
                self.reverseX();
            }
        }
    }
};
