require("physics")

Key = {}
setmetatable(Key, { __index = PhysicsObject })

function Key:new(tileMap, x, y)
    local instance = {}
    setmetatable(instance, { __index = Key })

    instance.body    = love.physics.newBody(tileMap.world, x, y, "static")
    instance.shape   = love.physics.newRectangleShape(32, 32)
    instance.fixture = love.physics.newFixture(instance.body, instance.shape)

    instance.fixture:setFilterData(collision.key, collision.player, 0)
    instance.fixture:setUserData(instance)
    instance.fixture:setSensor(true)

    return instance
end

function Key:draw()
    local x = self.body:getX()
    local y = self.body:getY()

    love.graphics.draw(textures.spriteSheet, textures.quads.key, x, y, 0, 1, 1, 16, 16)
end

function Key:collision(object)
    tileMap:removeKey(self)
end
