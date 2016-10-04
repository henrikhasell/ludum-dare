map = {}

require("turret")

collisionMasks = {
    walls = 1
    bullet = 2,
    player = 4
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
        turret.update = function(this, dt)
            if this.cooldown <= 0 then
                this.cooldown = 1
                this:fireBullet()
            else
                this.cooldown = this.cooldown - dt
            end
        end
        function turret.fireBullet()
            local bullet = {}
            -- TODO: Define bullet.
            table.insert(map.bullets, bullet)
        end

    table.insert(map.turrets, turret)
end

function map.update(dt)
    for key, value in pairs(map.turrets) do
        value:update(dt)
    end

    for key, value in pairs(map.bullets) do
        -- value:update(dt)
    end
end