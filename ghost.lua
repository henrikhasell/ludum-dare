require("bullet")
require('health')
require("key")
require("physics")
require("missile")
require("turret")
require("vector")

Ghost = {
    speed = 100,
    stage_lengths = {1.5, 3.0, 1.0, 3.0},
    hitpoints = 6,
    stage = 0,
    bullet_cooldown = 0,
    health_bar_display = 0,
    stun_duration = 0
}

setmetatable(Ghost, { __index = Turret })


function Ghost:new(tileMap, x, y)
    local instance = {}
    setmetatable(instance, { __index = Ghost })
    instance.body    = love.physics.newBody(tileMap.world, x, y, "dynamic")
    instance.shape   = love.physics.newCircleShape(16)
    instance.fixture = love.physics.newFixture(instance.body, instance.shape)
    instance.fixture:setFilterData(collision.ghost, collision.bullet + collision.wall + collision.player + collision.door + collision.ghost, 0)
    instance.fixture:setUserData(instance)
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
    local bullet = Bullet:new(tileMap, self.body:getX(), self.body:getY())
    bullet:setRotation(angle)
    sound_manager:playRocketSound()
end

function Ghost:fireMissile(tileMap)
    local x = self.body:getX()
    local y = self.body:getY()
    Missile:new(tileMap, x, y, tileMap.player)
    sound_manager:playRocketSound()
end

function Ghost:fireBulletSpread(tileMap)
    local direction = getDirection(tileMap.player, self)
    local angle = math.atan2(direction.y, direction.x)
    local spread = 0.2
    local b1 = Bullet:new(tileMap, self.body:getX(), self.body:getY())
    local b2 = Bullet:new(tileMap, self.body:getX(), self.body:getY())
    local b3 = Bullet:new(tileMap, self.body:getX(), self.body:getY())
    b1:setRotation(angle)
    b2:setRotation(angle - spread)
    b3:setRotation(angle + spread)
    sound_manager:playGhostSpreadAttackSound()
end

function Ghost:nextStage()
    self.stage = self.stage % #self.stage_lengths + 1
    self:resetCooldown()
    if self.hitpoints <= 3 and (self.stage == 1 or self.stage == 3) then
        self:fireMissile(tileMap)
    end
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
        draw_health_bar(x, y - 25, self.hitpoints / Ghost.hitpoints)
    end
end

function Ghost:damage(tileMap)
    self.health_bar_display = 1
    self.hitpoints = self.hitpoints - 1
    self.stun_duration = 2
    sound_manager:playGhostHitSound()
    if self.hitpoints <= 0 then
        tileMap:removeGhost(self)
    end
end

function Ghost:moveTowardsObject(object)
    local direction = getDirection(object, self)
    self.body:setLinearVelocity(direction.x * self.speed, direction.y * self.speed)
end

function Ghost:update(tileMap, dt)
    local is_stunned = self.stun_duration > 0
    self.stun_duration = self.stun_duration - dt

    if self.stun_duration <= 0 then
        self:moveTowardsObject(tileMap.player)
        self.cooldown = self.cooldown - dt
        self.bullet_cooldown = self.bullet_cooldown - dt
        self.health_bar_display = self.health_bar_display - dt

        if is_stunned or self.cooldown <= 0 then
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
end

GhostKiller = {}
setmetatable(GhostKiller, { __index = Bullet})

function GhostKiller:new(tileMap, player, ghost)
    local x = player.body:getX()
    local y = player.body:getY()
    local instance = Bullet:new(tileMap, x, y)
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
    object:damage(tileMap)
end

GhostKey = {}
setmetatable(GhostKey, { __index = Key })

function GhostKey:new(tileMap, manager, x, y)
    local instance = Key:new(tileMap, x, y)
    instance.manager = manager
    setmetatable(instance, { __index = GhostKey })
    return instance
end

function GhostKey:collision(tileMap, object)
    self.manager.key_exists = false
    tileMap:removeObject(self)
    table.insert(tileMap.updateTasks, function () self:spawnGhostKiller(tileMap, object) end)
    sound_manager:playPickupKeySound()
end

function GhostKey:spawnGhostKiller(tileMap, player)
    if #tileMap.ghosts <= 0 then
        return
    end
    GhostKiller:new(tileMap, player, tileMap.ghosts[1])
end

GhostKeyManager = {
    spawn_interval = 2
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
