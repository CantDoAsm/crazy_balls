const rl = @import("raylib");
const ball = @import("ball.zig");
const defs = @import("defs.zig");
pub fn i32ToF32(value: i32) f32 {
    return @floatFromInt(value);
}

pub fn f32ToI32(value: f32) i32 {
    return @intFromFloat(value);
}

pub fn makeRandomColor() rl.Color {
    const color: rl.Color = .{
        .r = @intCast(rl.getRandomValue(0, 255)), //
        .g = @intCast(rl.getRandomValue(0, 255)),
        .b = @intCast(rl.getRandomValue(0, 255)),
        .a = 255,
    };
    return color;
}
pub fn makeRandomVec2(min_x: i32, max_x: i32, min_y: i32, max_y: i32) rl.Vector2 {
    return .{ .x = i32ToF32(rl.getRandomValue(min_x, max_x)), .y = i32ToF32(rl.getRandomValue(min_y, max_y)) };
}
pub fn makeRandomBall() ball.Ball {
    return .{
        .radius = i32ToF32(rl.getRandomValue(defs.MIN_RAD, defs.MAX_RAD)),
        .pos = makeRandomVec2(20, 300, 20, 300), //
        .push = i32ToF32(rl.getRandomValue(defs.MIN_PUSH, defs.MAX_PUSH)),
        .vel = .{ .x = 0, .y = 0 },
        .color = makeRandomColor(),
    };
}
