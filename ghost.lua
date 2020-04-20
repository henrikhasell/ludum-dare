require("bullet")
require('health')
require("key")
require("physics")
require("turret")
require("vector")

Ghost = {}
setmetatable(Ghost, { __index = Turret })

Ghost.rotation = 0
Ghost.speed = 100
Ghost.stage_lengths = {1.5, 3.0, 1.0, 3.0}

function Ghost:new(tileMap, x, y)
    local instance = {}
    setmetatable(instance, { __index = Ghost })
    instance.body    = love.physics.newBody(tileMap.world, x, y, "dynamic")
    instance.shape   = love.physics.newCircleShape(16)
    instance.fixture = love.physics.newFixture(instance.body, instance.shape)
    instance.fixture:setFilterData(collision.ghost, collision.bullet + collision.wall + collision.player + collision.door + collision.ghost, 0)
    instance.fixture:setUserData(instance)
    instance.stage = 0
    instance.bullet_cooldown = 0
    instance.health_bar_display = 0
    instance:resetCooldown()

    return instance
end

function getDirection(a, b)
    local relativePosition = {
        x = a.body:getX() - b.body:getX(),
        y = a.body:getY() - b.body:getY()
    }
    return vector.normalise(relativePosition)
end

function Ghost:fireBullet(tileMap)
    local direction = getDirection(tileMap.player, self)
    local angle = math.atan2(direction.y, direction.x)
    local bullet = Bullet:new(self, tileMap)
    bullet:setRotation(angle)
end

function Ghost:fireBulletSpread(tileMap)
    local direction = getDirection(tileMap.player, self)
    local angle = math.atan2(direction.y, direction.x)
    local spread = 0.2
    local b1 = Bullet:new(self, tileMap)
    local b2 = Bullet:new(self, tileMap)
    local b3 = Bullet:new(self, tileMap)
    b1:setRotation(angle)
    b2:setRotation(angle - spread)
    b3:setRotation(angle + spread)
end

function Ghost:nextStage()
    self.stage = self.stage % #self.stage_lengths + 1
    self:resetCooldown()
end

function Ghost:resetCooldown()
    self.cooldown = self.stage_lengths[self.stage]
end

function Ghost:draw()
    local x = self.body:getX()
    local y = self.body:getY()
    local radius = self.shape:getRadius()
    love.graphics.draw(textures.spriteSheet, textures.quads.player, x, y, 0, 1, 1, radius, radius)
    if self.health_bar_display > 0 then
        draw_health_bar(x, y - 25, 0.5)
    end
end

function Ghost:damage()
    self.health_bar_display = 2
end

function Ghost:update(tileMap, dt)
    local direction = getDirection(tileMap.player, self)
    self.body:setLinearVelocity(direction.x * self.speed, direction.y * self.speed)

    self.cooldown = self.cooldown - dt
    self.bullet_cooldown = self.bullet_cooldown - dt
    self.health_bar_display = self.health_bar_display - dt

    if self.cooldown <= 0 then
        self:nextStage()
    end
    if self.bullet_cooldown <= 0 then
        if self.stage == 2 then
            self:fireBullet(tileMap)
        end
        if self.stage == 4 then
            self:fireBulletSpread(tileMap)
        end
        self.bullet_cooldown = 0.1
    end
end

GhostKiller = {}
setmetatable(GhostKiller, { __index = Bullet})

function GhostKiller:new(tileMap, player, ghost)
    local instance = Bullet:new(player, tileMap)
    local direction = getDirection(ghost, player)
    local rotation = math.atan2(direction.y, direction.x)
    setmetatable(instance, { __index = GhostKiller })
    instance.fixture:setFilterData(collision.bullet, collision.ghost, 0)
    instance:setRotation(rotation)
    return instance
end

function GhostKiller:collision(tileMap, object)
    tileMap:removeBullet(self)
    print('Ghost killer hit ' .. object:getName())
    object:damage()
end

GhostKey = {}
setmetatable(GhostKey, { __index = Key })

function GhostKey:new(tileMap, manager, x, y)
    local instance = Key:new(tileMap, x, y)
    instance.manager = manager
    instance.triggered = false
    setmetatable(instance, { __index = GhostKey })
    return instance
end

function GhostKey:collision(object)
    self.triggered = true
    self.manager.key_exists = false
end

function GhostKey:spawnGhostKiller()
    if #tileMap.ghosts <= 0 then
        return
    end
    GhostKiller:new(tileMap, tileMap.player, tileMap.ghosts[1])
end

function GhostKey:update(dt)
    if self.triggered then
        self:spawnGhostKiller()
        tileMap:removeObject(self)
    end
end

GhostKeyManager = {
    spawn_interval = 1
}
setmetatable(GhostKeyManager, { __index = PhysicsObject })

function GhostKeyManager:new(tileMap, positions)
    local instance = {
        cooldown = self.spawn_interval,
	key_exists = false,
        positions = positions
    }
    setmetatable(instance, { __index = GhostKeyManager })
    return instance
end

function GhostKeyManager:spawnKey(tileMap)
    self.key_exists = true
    local index = math.random(#self.positions)
    local position = self.positions[index]
    tileMap:addGhostKey(self, position.x, position.y)
end

function GhostKeyManager:update(tileMap, dt)
    if not self.key_exists then
        self.cooldown = self.cooldown - dt
        if self.cooldown <= 0 then
            self:spawnKey(tileMap)
            self.cooldown = self.spawn_interval
        end
    end
end
