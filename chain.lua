require("physics")

Chain = {}
setmetatable(Chain, { __index = PhysicsOject })

    Chain.linkRotation = 0
    Chain.linkRotationSpeed = 2.3

    Chain.linkRadius = 16

    Chain.linkArray = {}

    function Chain:new(tileMap, x, y)
        local instance = {}
        setmetatable(instance, { __index = Chain })

        instance.body    = love.physics.newBody(tileMap.world, x, y, "static")
        instance.shape   = love.physics.newRectangleShape(32, 32)
        instance.fixture = love.physics.newFixture(instance.body, instance.shape)

        instance.fixture:setFilterData(collision.wall, collision.player, 0)
        instance.fixture:setUserData(instance)

        instance.linkArray = {}
        instance:addLink(tileMap)
        instance:addLink(tileMap)
        instance:addLink(tileMap)
        instance:addLink(tileMap)

        return instance
    end

    function Chain:addLink(_tileMap)
        local link = { __index = PhysicsObject }
        link.body    = love.physics.newBody(_tileMap.world, 0, 0, "static")
        link.shape   = love.physics.newCircleShape(self.linkRadius)
        link.fixture = love.physics.newFixture(link.body, link.shape)
        link.fixture:setFilterData(collision.bullet, collision.player, 0)
        link.fixture:setUserData(instance)

        function link:draw()
            local x = self.body:getX()
            local y = self.body:getY()
            local r = self.shape:getRadius()
            love.graphics.setColor(255, 0, 0)
            love.graphics.circle("fill", x, y, r)
            love.graphics.setColor(255, 255, 255)
        end

        function link:collision(tileMap, object)
            tileMap:destroy()
	    loadLevel(currentLevel)
        end

        link.fixture:setUserData(link)
        table.insert(self.linkArray, link)
    end

    function Chain:update(dt)
        self.linkRotation = self.linkRotation + (dt * self.linkRotationSpeed)

        local x = self.body:getX()
        local y = self.body:getY()

        for index, value in pairs(self.linkArray) do
            local offset = index * self.linkRadius * 2
            local chainX = x + math.sin(self.linkRotation) * offset
            local chainY = y - math.cos(self.linkRotation) * offset
            value.body:setPosition(chainX, chainY)
        end
    end

    function Chain:draw()
        for index, value in pairs(self.linkArray) do
            value:draw()
        end
    end

    function Chain:collision(tileMap, other)
        -- Empty.
    end
