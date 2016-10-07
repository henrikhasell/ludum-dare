Bullet = {}

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
            -- Set the linear velocity of the bullet:
            instance.body:setLinearVelocity(velocity.x, velocity.y)
            -- Set the bullet to only collide with the player:
            instance.fixture:setFilterData(collision.bullet, collision.player, 0)
            -- Used for collision handling logic:
            instance.fixture:setUserData("Bullet")

        return instance
    end

    function Bullet:finished()
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

    function Bullet:draw()
        local x = self.body:getX()
        local y = self.body:getY()
        local r = self.shape:getRadius()

        love.graphics.setColor(0, 0, 255)
        love.graphics.circle("line", x, y, r)
        love.graphics.setColor(255, 255, 255)
    end
