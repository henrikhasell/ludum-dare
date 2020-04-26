require("physics")
-- require("levels")

Exit = {}
    setmetatable(Exit, { __index = PhysicsObject })

    Exit.metaTable = {}
        Exit.metaTable.__index = Exit

    function Exit:new(tileMap, x, y)
        local instance = {}
            setmetatable(instance, self.metaTable)

            instance.body    = love.physics.newBody(tileMap.world, x, y, "static")
            instance.shape   = love.physics.newRectangleShape(32, 32)
            instance.fixture = love.physics.newFixture(instance.body, instance.shape)

            instance.fixture:setFilterData(collision.exit, collision.player, 0)
            instance.fixture:setSensor(true)
            instance.fixture:setUserData(instance)

        return instance
    end

    function Exit:collision(tileMap, object)
        currentLevel = currentLevel + 1
        loadLevel(currentLevel)
        sound_manager:playLevelUpSound()
    end
