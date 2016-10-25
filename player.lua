require("physics")

Player = PhysicsObject:new()

    Player.metaTable = {}
        Player.metaTable.__index = Player

    Player.speed = 200

    function Player:new(tileMap, x, y)
        local instance = {}
            setmetatable(instance, self.metaTable)
            instance.body    = love.physics.newBody(tileMap.world, x, y, "dynamic")
            instance.shape   = love.physics.newCircleShape(16)
            instance.fixture = love.physics.newFixture(instance.body, instance.shape)
            -- So that the player collides with everything:
            instance.fixture:setFilterData(collision.player, 0xff, 0)
            -- So that the player does not move slowly in tight spaces:
            instance.fixture:setFriction(0)
            -- Used for collision handling logic:
            instance.fixture:setUserData(instance)

        return instance
    end

    function Player:draw()
        local x = self.body:getX()
        local y = self.body:getY()
        local radius = self.shape:getRadius()
        love.graphics.draw(textures.spriteSheet, textures.quads.player, x, y, 0, 1, 1, radius, radius)
    end

    function Player:update()
        local velocity = {}
            velocity.x = 0
            velocity.y = 0

        if input.key.up then
            velocity.y = velocity.y - self.speed
        end
        if input.key.down then
            velocity.y = velocity.y + self.speed
        end
        if input.key.left then
            velocity.x = velocity.x - self.speed
        end
        if input.key.right then
            velocity.x = velocity.x + self.speed
        end

        self.body:setLinearVelocity(velocity.x, velocity.y)
    end

    function Player:getName()
        return "Player"
    end
