Door = {}

    Door.metaTable = {}
        Door.metaTable.__index = Door



    function Door:new(tileMap, x, y)
        local instance = {}
            setmetatable(instance, self.metaTable)

            instance.body    = love.physics.newBody(tileMap.world, x, y, "static")
            instance.shape   = love.physics.newRectangleShape(32, 32)
            instance.fixture = love.physics.newFixture(instance.body, instance.shape)

            instance.fixture:setFilterData(collision.door, collision.player + collision.fire, 0)
            instance.fixture:setUserData("Door")

        return instance
    end

    function Door:draw()
        local x = self.body:getX()
        local y = self.body:getY()
        love.graphics.draw(textures.spriteSheet, textures.quads.door, x, y, 0, 1, 1, 16, 16)
    end
