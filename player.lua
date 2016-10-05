require("textures")

Player = {}

    Player.metaTable = {}
        Player.metaTable.__index = Player

    Player.speed = 200

    function Player:new(tileMap, x, y)
        local instance = {}
            setmetatable(instance, self.metaTable)
            instance.body    = love.physics.newBody(tileMap.world, x, y, "dynamic")
            instance.shape   = love.physics.newCircleShape(16)
            instance.fixture = love.physics.newFixture(instance.body, instance.shape)

            instance.fixture:setFilterData(collision.player, collision.wall, 0)
            instance.fixture:setFriction(0)
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
