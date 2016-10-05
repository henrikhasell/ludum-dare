function love.load()

    require("map") -- require

    love.physics.setMeter(128) -- 128 pixels is equal to one meter
    love.graphics.setDefaultFilter( "nearest", "nearest") -- To prevent bleeding

    keyPressed = {
        ["up"] = false, ["down"] = false, ["left"] = false, ["right"] = false
    }

    tileData = {
        w = 32, h = 32
    }

    -- 0: Empty space.
    -- 1: Wall.
    -- 2: Starting point.
    -- 3: Finishing point.
    -- 4: Turret.
    tileMapData = {
        {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
        {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
        {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 1},
        {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
        {1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
        {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
        {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
        {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
        {1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1},
        {1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
        {1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
        {1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
        {1, 0, 0, 0, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1},
        {1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1},
        {1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 4, 0, 1, 0, 0, 0, 1},
        {1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1},
        {1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1},
        {1, 0, 4, 0, 1, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 4, 0, 1},
        {1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1},
        {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}
    }

    map.load(tileMapData)

    movementForce = 300
end

function love.update(dt)
    map.update(dt)
    map.world:update(dt)

    for key, value in pairs(keyPressed) do
        if love.keyboard.isDown(key) then
            keyPressed[key] = true
        else
            keyPressed[key] = false
        end
    end

    currentVelocity = {}
    currentVelocity.x, currentVelocity.y = map.player.body:getLinearVelocity()

    desiredVelocity = { x = 0, y = 0 }

    if keyPressed["up"] == true then
        desiredVelocity.y = desiredVelocity.y - movementForce
    end
    if keyPressed["down"] == true then
        desiredVelocity.y = desiredVelocity.y + movementForce
    end
    if keyPressed["left"] == true then
        desiredVelocity.x = desiredVelocity.x - movementForce
    end
    if keyPressed["right"] == true then
        desiredVelocity.x = desiredVelocity.x + movementForce
    end

    velocityChange = {
        x = desiredVelocity.x - currentVelocity.x,
        y = desiredVelocity.y - currentVelocity.y
    }

    impulse = {
        x = velocityChange.x * map.player.body:getMass(),
        y = velocityChange.y * map.player.body:getMass()
    }

    map.player.body:applyLinearImpulse(impulse.x, impulse.y)
end

function love.draw()
    love.graphics.draw(map.spriteBatch)

    local playerQuad = love.graphics.newQuad(32 * 3, 32 * 0, 32, 32, 32 * 4, 32 * 1)
    love.graphics.draw(map.spriteSheet, playerQuad, map.player.body:getX(), map.player.body:getY(), 0, 1, 1, map.player.shape:getRadius(), map.player.shape:getRadius())

    for key, value in pairs(map.turrets) do
        local turretQuad = love.graphics.newQuad(32 * 0, 32 * 0, 32, 32, 32 * 4, 32 * 1)
        love.graphics.draw(map.spriteSheet, turretQuad, value.position.x, value.position.y, 0, 1, 1, 16, 16)
    end

    love.graphics.setColor(0, 0, 255)
    for key, value in pairs(map.bullets) do
        local turretQuad = love.graphics.newQuad(32 * 0, 32 * 0, 32, 32, 32 * 4, 32 * 1)
        love.graphics.circle("line", value.body:getX(), value.body:getY(), value.shape:getRadius())
    end
    love.graphics.setColor(255, 255, 255)
end

function beginContact(a, b, collision)
end

function endContact(a, b, collision)
end

function preSolve(a, b, collision)
end

function postSolve(a, b, collision, normalImpulse, tangentImpulse)
end