map = {}

require("turret")

collisionMasks = {
    walls  = 0x10000000,
    bullet = 0x01000000,
    player = 0x00100000
}

map.spriteSheet = love.graphics.newImage("Assets/Exported/SpriteSheet.png")
map.spriteSheet:setFilter("nearest")
map.world = love.physics.newWorld()
map.tiles = {}
map.turrets = {}
map.bullets = {}
map.player = {}
map.exit = {}

function map.getPosition(x, y)
    return (x - 0.5) * 32, (y - 0.5) * 32
end

function map.load(tileMapData)
    print("Loading map " .. #tileMapData[1] .. " by " .. #tileMapData)

    map.spriteBatch = love.graphics.newSpriteBatch(map.spriteSheet, 400)

    for k1,v1 in pairs(tileMapData) do
        for k2,v2 in pairs(v1) do
            if v2 == 0 then
                map.addFloor(k2, k1)
            end
            if v2 == 1 then
                map.addTile(k2, k1)
            end
            if v2 == 2 then
                map.addFloor(k2, k1)
                map.addPlayer(k2, k1)
            end
            if v2 == 3 then
                map.addFloor(k2, k1)
                map.addExit(k2, k1)
            end
            if v2 == 4 then
                map.addFloor(k2, k1)
                map.addTurret(k2, k1)
            end
        end
    end

    return map
end

function map.addFloor(x, y)
    local worldX, worldY = map.getPosition(x, y)

    local graphicsQuad = love.graphics.newQuad(32 * 1, 32 * 0, 32, 32, 32 * 4, 32 * 1)
    map.spriteBatch:add(graphicsQuad, worldX - 16, worldY - 16)
end

function map.addTile(x, y)
    local worldX, worldY = map.getPosition(x, y)

    local tile = {}
        tile.body = love.physics.newBody(map.world, worldX, worldY, "static")
        tile.shape = love.physics.newRectangleShape(32, 32)
        tile.fixture = love.physics.newFixture(tile.body, tile.shape)
        tile.fixture:setUserData("Tile")

    table.insert(map.tiles, tile)

    local graphicsQuad = love.graphics.newQuad(32 * 0, 32 * 0, 32, 32, 32 * 4, 32 * 1)
    map.spriteBatch:add(graphicsQuad, worldX - 16, worldY - 16)
end

function map.addPlayer(x, y)
    local worldX, worldY = map.getPosition(x, y)

    local player = {}
        player.body = love.physics.newBody(map.world, worldX, worldY, "dynamic")
        player.shape = love.physics.newCircleShape(16)
        player.fixture = love.physics.newFixture(player.body, player.shape)
        player.fixture:setUserData("Player")

    map.player = player
end

function map.addExit(x, y)
    local worldX, worldY = map.getPosition(x, y)
    local graphicsQuad = love.graphics.newQuad(32 * 2, 32 * 0, 32, 32, 32 * 4, 32 * 1)
    map.spriteBatch:add(graphicsQuad, worldX - 16, worldY - 16)
end

function map.addTurret(x, y)
    local worldX, worldY = map.getPosition(x, y)

    local turret = {}
        turret.position = {
            x = worldX, y = worldY
        }
        turret.rotation = 0
        turret.cooldown = 0
        function turret.update(dt)
            local relativePosition = {}
                relativePosition.x = map.player.body:getX() - turret.position.x
                relativePosition.y = map.player.body:getY() - turret.position.y

            turret.rotation = math.atan2(relativePosition.y, relativePosition.x)

            if turret.cooldown <= 0 then
                turret.cooldown = 1
                local playerVisible = turret:canSeePlayer()
                if playerVisible == true then
                    turret:fireBullet()
                end
            else
                turret.cooldown = turret.cooldown - 0.2
            end
        end
        function turret.canSeePlayer()
            local playerVisible = true
            function callback(fixture, x, y, xn, yn, fraction)
                local userData = fixture:getUserData()
                if userData == "Tile" then
                    playerVisible = false
                    return 0
                else
                    return -1
                end
            end
            map.world:rayCast(turret.position.x, turret.position.y, map.player.body:getX(), map.player.body:getY(), callback)
            return playerVisible
        end
        function turret.fireBullet()
            local bulletVelocity = {}
                bulletVelocity.x = math.cos(turret.rotation) * 320
                bulletVelocity.y = math.sin(turret.rotation) * 320
            local bullet = {}
                bullet.body = love.physics.newBody(map.world, turret.position.x, turret.position.y, "dynamic")
                bullet.shape = love.physics.newCircleShape(8)
                bullet.fixture = love.physics.newFixture(bullet.body, bullet.shape)
                bullet.fixture:setFilterData(collisionMasks.bullet, collisionMasks.player, 0)
                bullet.fixture:setUserData("Bullet")
                function bullet.isOffScreen()
                    if bullet.body:getX() < 0 or bullet.body:getX() > 32 * 20 then
                        return true
                    end
                    if bullet.body:getY() < 0 or bullet.body:getY() > 32 * 20 then
                        return true
                    end
                    return false
                end
                function bullet.destroy()
                    table.remove(map.bullets, bullet)
                    bullet.body:destroy()
                end
            bullet.body:setLinearVelocity(bulletVelocity.x, bulletVelocity.y)
            table.insert(map.bullets, bullet)
        end

    table.insert(map.turrets, turret)
end

function map.update(dt)
    map.world:update(dt)

    for key, value in pairs(map.turrets) do
        value:update(dt)
    end

    for key, value in pairs(map.bullets) do
        if value:isOffScreen() then
            table.remove(map.bullets, key)
        end
    end
end