require("physics")

Bullet = {}
    setmetatable(Bullet, {
        __index = PhysicsObject
    })

    Bullet.speed = 320

    function Bullet:new(tileMap, x, y)

        local instance = {i = 1}
        setmetatable(instance, {__index = Bullet})

        -- Create the Box2D bullet object:
        instance.body    = love.physics.newBody(tileMap.world, x, y, "dynamic")
        instance.shape   = love.physics.newCircleShape(8)
        instance.fixture = love.physics.newFixture(instance.body, instance.shape)
        -- Configure the Box2D bullet:
        instance.fixture:setFilterData(collision.bullet, collision.player, 0)
        instance.fixture:setUserData(instance)
        instance.fixture:setSensor(true)

	table.insert(tileMap.bullets, instance)

        return instance
    end

    function Bullet:setRotation(value)
        local velocity = {
            x = math.cos(value) * self.speed,
            y = math.sin(value) * self.speed
        }
        self.body:setLinearVelocity(velocity.x, velocity.y)
        self.body:setAngle(value)
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

	      love.graphics.draw(textures.rocket, textures.quads.rocketAnimation[self.i], x, y, self.body:getAngle() + math.pi / 2, 1, 1, 16, 16)
        self.i = self.i % #textures.quads.rocketAnimation + 1
        -- print ('i is ' .. i)
    end

    function Bullet:collision(tileMap, object)
        tileMap:resetLevel()
    end

    function Bullet:update(tileMap, dt)
        -- Do nothing.
    end
