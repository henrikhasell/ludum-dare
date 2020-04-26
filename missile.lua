require("bullet")
require("health")
require("utilities")

Missile = {
    speed = 120,
    speed_increase = 15,
    speed_increase_cooldown = 1,
    time_remaining = 8
}
setmetatable(Missile, {__index = Bullet})

function Missile:new(tileMap, x, y, target)
    local instance = Bullet:new(tileMap, x, y)
    instance.target = target
    setmetatable(instance, {__index = Missile})
end

function Missile:draw()
    Bullet.draw(self)
    draw_health_bar(self.body:getX(), self.body:getY() - 16, self.time_remaining / Missile.time_remaining)
end

function Missile:moveTowards(object)
    local direction = utilities.getDirection(object, self)
    self.body:setLinearVelocity(direction.x * self.speed, direction.y * self.speed)
    self.body:setAngle(math.atan2(direction.y, direction.x))

end

function Missile:update(dt)
    self:moveTowards(self.target)
    self.speed_increase_cooldown = self.speed_increase_cooldown - dt
    self.time_remaining = self.time_remaining - dt
    if self.speed_increase_cooldown <= 0 then
        self.speed = self.speed + self.speed_increase
	self.speed_increase_cooldown = self.speed_increase_cooldown + Missile.speed_increase_cooldown
    end
end

function Missile:destroy()
    sound_manager:playMissileDieSound()
end

function Missile:finished()
    return self.time_remaining <= 0
end
