require("physics")
require("bullet")

Turret = {}
    setmetatable(Turret, {
        __index = PhysicsObject
    })

    Turret.cooldown = 0.1
    Turret.rotation = 0

    function Turret:new(tileMap, x, y)
        local instance = {}
            setmetatable(instance, {
                __index = Turret
	    })

            instance.body    = love.physics.newBody(tileMap.world, x, y, "static")
            instance.shape   = love.physics.newRectangleShape(32, 32)
            instance.fixture = love.physics.newFixture(instance.body, instance.shape)
	    instance.nozzle_blast = false

            instance.fixture:setFilterData(collision.turret, collision.player, 0)
            instance.fixture:setUserData(instance)

        return instance
    end

    function Turret:fireBullet(tileMap)
        local bullet = Bullet:new(self, tileMap)
	local nozzle_length = 20
	local position = {
            x = self.body:getX() + math.cos(self.rotation) * nozzle_length,
            y = self.body:getY() + math.sin(self.rotation) * nozzle_length
	}
	bullet.body:setPosition(position.x, position.y)
	bullet:setRotation(self.rotation)
	self.nozzle_blast = true
    end

    function Turret:observe(tileMap, target)
        local visible = true

        local function callback(fixture)

            visible = fixture:getUserData().metaTable ~= Wall.metaTable
                  and fixture:getUserData().metaTable ~= Door.metaTable
            return visible and -1 or 0
        end

        local x1 = self.body:getX()
        local y1 = self.body:getY()

        local x2 = target.body:getX()
        local y2 = target.body:getY()

        tileMap.world:rayCast(x1, y1, x2, y2, callback)

        return visible
    end

    function Turret:update(tileMap, dt)
        local target = tileMap.player

        local relativePosition = {
            x = target.body:getX() - self.body:getX(),
            y = target.body:getY() - self.body:getY()
	}

        self.rotation = math.atan2(relativePosition.y, relativePosition.x)

        if self.cooldown <= 0 then
            if self:observe(tileMap, target) then
                self.cooldown = Turret.cooldown
                self:fireBullet(tileMap)
            end
        else
            self.cooldown = self.cooldown - dt
        end
    end

    function Turret:draw()
        local x = self.body:getX()
	local y = self.body:getY()
        love.graphics.draw(textures.turret, x, y, 0, 1, 1, 16, 16)
        love.graphics.draw(textures.nozzle, x, y, self.rotation + math.pi / 2, 1, 1, 16, 16)
	if self.nozzle_blast then
	    self.nozzle_blast = false
            local nozzle_length = 30
	    local position = {
                x = self.body:getX() + math.cos(self.rotation) * nozzle_length,
                y = self.body:getY() + math.sin(self.rotation) * nozzle_length
	    }
            love.graphics.draw(textures.nozzle_blast, position.x, position.y, self.rotation + math.pi / 2, 1, 1, 16, 16)
	end
    end
