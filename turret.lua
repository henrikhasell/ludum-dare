Turret = {}

    Turret.metaTable = {}
        Turret.metaTable.__index = Turret

    Turret.rotation = 0

    function Turret:new(tileMap, x, y)
        local instance = {}
            setmetatable(instance, self.metaTable)
            instance.body = love.physics.newBody(tileMap.world, x, y, "static")
            instance.shape = love.physics.newRectangleShape(32, 32)
            instance.fixture = love.physics.newFixture(instance.body, instance.shape)
        return instance
    end

    function Turret:update()
        
    end
