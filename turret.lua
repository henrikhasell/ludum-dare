require("bullet")

Turret = {}

    Turret.metaTable = {}
        Turret.metaTable.__index = Turret

    Turret.cooldown = 0.2
    Turret.rotation = 0

    function Turret:new(tileMap, x, y)
        local instance = {}
            setmetatable(instance, self.metaTable)

            instance.body    = love.physics.newBody(tileMap.world, x, y, "static")
            instance.shape   = love.physics.newRectangleShape(32, 32)
            instance.fixture = love.physics.newFixture(instance.body, instance.shape)

        return instance
    end

    function Turret:fireBullet(tileMap)
        local bullet = Bullet:new(self, tileMap)
        table.insert(tileMap.bullets, bullet)
    end

    function Turret:observe(target)

        local function callback()

        end

        return false
    end

    function Turret:update(tileMap, dt)

        local target = tileMap.player

        local relativePosition = {}
            relativePosition.x = target.body:getX() - self.body:getX()
            relativePosition.y = target.body:getY() - self.body:getY()

        self.rotation = math.atan2(relativePosition.y, relativePosition.x)

        if self.cooldown <= 0 then
            if self.observe(target) then
                self.cooldown = Turret.cooldown
                self:fireBullet(tileMap)
            end
        else
            self.cooldown = self.cooldown - dt
        end
    end
