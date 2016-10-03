map = {}

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

map.world = love.physics.newWorld()
map.tiles = {}
map.player = {}
map.exit = {}

function map.getPosition(x, y)
    return (x - 0.5) * 32, (y - 0.5) * 32
end

function map.load(tileMapData)
    print("Loading map " .. #tileMapData[1] .. " by " .. #tileMapData)

    for k1,v1 in pairs(tileMapData) do
        for k2,v2 in pairs(v1) do
            if v2 == 1 then
                 map.addTile(k2, k1)
            end
            if v2 == 2 then
                 map.addPlayer(k2, k1)
            end
        end
    end
end

function map.addTile(x, y)
    local worldX, worldY = map.getPosition(x, y)

    local tile = {}
        tile.body = love.physics.newBody(map.world, worldX, worldY, "static")
        tile.shape = love.physics.newRectangleShape(32, 32)
        tile.fixture = love.physics.newFixture(tile.body, tile.shape)
        tile.fixture:setUserData("Tile")

    table.insert(map.tiles, tile)
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