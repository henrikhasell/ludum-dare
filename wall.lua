require("physics")

Wall = PhysicsObject:new()

    Wall.metaTable = {}
        Wall.metaTable.__index = Wall 

    function Wall:new(tileMap, x, y)
        local instance = {}
            setmetatable(instance, self.metaTable)

            instance.body    = love.physics.newBody(tileMap.world, x, y, "static")
            instance.shape   = love.physics.newRectangleShape(32, 32)
            instance.fixture = love.physics.newFixture(instance.body, instance.shape)

            instance.fixture:setFilterData(collision.door, collision.player + collision.fire, 0)
            instance.fixture:setUserData(instance)

        return instance
    end

    function Wall:getName()
        return "Wall"
    end
