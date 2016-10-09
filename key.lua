Key = {}

    Key.metaTable = {}
        Key.metaTable.__index = Key



    function Key:new(tileMap, x, y)
        local instance = {}
            setmetatable(instance, self.metaTable)

            instance.body    = love.physics.newBody(tileMap.world, x, y, "static")
            instance.shape   = love.physics.newRectangleShape(32, 32)
            instance.fixture = love.physics.newFixture(instance.body, instance.shape)

            instance.fixture:setFilterData(collision.key, collision.player, 0)
            instance.fixture:setUserData("Key")

        return instance
    end

    function Key:draw()
        local x = self.body:getX()
        local y = self.body:getY()

        love.graphics.draw(textures.spriteSheet, textures.quads.key, x, y, 0, 1, 1, 16, 16)
    end