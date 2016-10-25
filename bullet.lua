require("physics")

Bullet = PhysicsObject:new()

    Bullet.metaTable = {}
        Bullet.metaTable.__index = Bullet

    Bullet.speed = 320

    function Bullet:new(turret, tileMap)

        local x = turret.body:getX()
        local y = turret.body:getY()

        local velocity = {}
            velocity.x = math.cos(turret.rotation) * self.speed
            velocity.y = math.sin(turret.rotation) * self.speed

        local instance = {}
            setmetatable(instance, self.metaTable)
            -- Create the Box2D bullet object:
            instance.body    = love.physics.newBody(tileMap.world, x, y, "dynamic")
            instance.shape   = love.physics.newCircleShape(8)
            instance.fixture = love.physics.newFixture(instance.body, instance.shape)
            -- Configure the Box2D bullet:
            instance.body:setLinearVelocity(velocity.x, velocity.y)
            instance.fixture:setFilterData(collision.bullet, collision.player, 0)
            instance.fixture:setSensor(true)
            instance.fixture:setUserData(instance)

        return instance
    end

    function Bullet:finished()
        -- Get the current position:
        local x = self.body:getX()
        local y = self.body:getY()

        if x < 0 or x > 32 * 20 then
            return true
        end
        if y < 0 or y > 32 * 20 then
            return true
        end

        return false
    end

    function Bullet:draw()
        local x = self.body:getX()
        local y = self.body:getY()
        local r = self.shape:getRadius()

        love.graphics.setColor(0, 0, 255)
        love.graphics.circle("line", x, y, r)
        love.graphics.setColor(255, 255, 255)
    end
