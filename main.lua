function love.load()

    require("map") -- require

    love.physics.setMeter(128) -- 128 pixels is equal to one meter

    world = love.physics.newWorld()
        world:setCallbacks(beginContact, endContact, preSolve, postSolve)

    keyPressed = {
        ["up"] = false, ["down"] = false, ["left"] = false, ["right"] = false
    }

    ball = {}
        ball.body = love.physics.newBody(world, 400,200, "dynamic")
        ball.body:setMass(10)
        ball.shape = love.physics.newCircleShape(16)
        ball.fixture = love.physics.newFixture(ball.body, ball.shape)
        ball.fixture:setRestitution(0.4)    -- make it bouncy
        ball.fixture:setUserData("Ball")

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

    text       = ""   -- we'll use this to put info text on the screen later
    persisting = 0    -- we'll use this to store the state of repeated callback calls

    movementForce = 500
end
 
function love.update(dt)
    world:update(dt)

    for key, value in pairs(keyPressed) do
        if love.keyboard.isDown(key) then
            keyPressed[key] = true
        else
            keyPressed[key] = false
        end
    end

    currentVelocity = {}
    currentVelocity.x, currentVelocity.y = ball.body:getLinearVelocity()

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
        x = velocityChange.x * ball.body:getMass(),
        y = velocityChange.y * ball.body:getMass()
    }

    ball.body:applyLinearImpulse(impulse.x, impulse.y)

    -- if love.keyboard.isDown("right") then
    --     ball.body:applyForce(movementForce, 0)
    -- elseif love.keyboard.isDown("left") then
    --     ball.body:applyForce(-movementForce, 0)
    -- end
    -- if love.keyboard.isDown("up") then
    --     ball.body:applyForce(0, -movementForce)
    -- elseif love.keyboard.isDown("down") then
    --     ball.body:applyForce(0, movementForce)
    -- end
 


    if string.len(text) > 768 then    -- cleanup when 'text' gets too long
        text = ""
    end
end
 
function love.draw()
    love.graphics.circle("line", ball.body:getX(),ball.body:getY(), ball.shape:getRadius(), 20)

    for key, value in pairs(map.tiles) do
        love.graphics.polygon("line", value.body:getWorldPoints(value.shape:getPoints()))
    end

    love.graphics.print(text, 10, 10)
end
 
function beginContact(a, b, coll)
    x,y = coll:getNormal()
    text = text.."\n"..a:getUserData().." colliding with "..b:getUserData().." with a vector normal of: "..x..", "..y
end
 
function endContact(a, b, coll)
    persisting = 0
    text = text.."\n"..a:getUserData().." uncolliding with "..b:getUserData()
end
 
function preSolve(a, b, coll)
    if persisting == 0 then    -- only say when they first start touching
        text = text.."\n"..a:getUserData().." touching "..b:getUserData()
    elseif persisting < 20 then    -- then just start counting
        text = text.." "..persisting
    end
    persisting = persisting + 1    -- keep track of how many updates they've been touching for
end
 
function postSolve(a, b, coll, normalimpulse, tangentimpulse)
end
