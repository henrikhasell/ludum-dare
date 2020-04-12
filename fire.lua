require("physics")

Fire = {}
    setmetatable(Fire, { __index = PhysicsObject })

    Fire.metaTable = {}
        Fire.metaTable.__index = Fire 

    Fire.speed = 100

    Fire.direction = {}
        Fire.direction.up    = 0x01
        Fire.direction.down  = 0x02
        Fire.direction.left  = 0x04
        Fire.direction.right = 0x08

    Fire.leeway = 1.4

    function Fire:new(tileMap, x, y, direction)
        local instance = {}
            setmetatable(instance, self.metaTable)
            -- Create the Box2D bullet object:
            instance.body    = love.physics.newBody(tileMap.world, x, y, "dynamic")
            instance.shape   = love.physics.newRectangleShape(32 - instance.leeway, 32 - instance.leeway)
            instance.fixture = love.physics.newFixture(instance.body, instance.shape)
            -- Must collide with walls and player:
            instance.fixture:setFilterData(collision.fire, collision.wall + collision.player + collision.door, 0)
            -- Must not lose velocity on collision:
            instance.fixture:setRestitution(1)
            -- Must not be slowed by perpendicular objects:
            instance.fixture:setFriction(0)
            -- Floating point errors require this:
            instance.body:setFixedRotation(true)
            -- Used for collision handling logic:
            instance.fixture:setUserData(instance)
            -- Set the linear velocity:
            instance:setDirection(direction)
        return instance
    end

    function Fire:setDirection(direction)
        local velocity = {}

        if direction == Fire.direction.up then
            velocity.x = 0 * self.speed
            velocity.y =-1 * self.speed
        end
        if direction == Fire.direction.down then
            velocity.x = 0 * self.speed
            velocity.y = 1 * self.speed
        end
        if direction == Fire.direction.left then
            velocity.x =-1 * self.speed
            velocity.y = 1 * self.speed
        end
        if direction == Fire.direction.right then
            velocity.x = 1 * self.speed
            velocity.y = 0 * self.speed
        end

        self.body:setLinearVelocity(velocity.x, velocity.y)
        self.direction = direction
    end

    function Fire:finished()
        -- Get the current position:
        local x = self.body:getX()
        local y = self.body:getY()

        if x < 64 or x > 32 * 18 then
            return true
        end
        if y < 64 or y > 32 * 18 then
            return true
        end

        return false
    end

    function Fire:draw()
        local x = self.body:getX()
        local y = self.body:getY()


        love.graphics.setColor(255, 0, 0)
        love.graphics.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
        love.graphics.setColor(255, 255, 255)
    end

    function Fire:collision(tileMap, object)
        if object:getName() == "Player" then
            tileMap:destroy()
	    loadLevel(currentLevel)
        end
    end
