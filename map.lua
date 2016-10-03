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
        map.tiles[k1] = {}
        for k2,v2 in pairs(v1) do
            if v2 == 1 then
                    local x, y = map.getPosition(k2, k1)
                    map.tiles[k1][k2] = {}
                    map.tiles[k1][k2].body = love.physics.newBody(world, x, y, "static")
                    map.tiles[k1][k2].shape = love.physics.newRectangleShape(32, 32)
                    map.tiles[k1][k2].fixture = love.physics.newFixture(map.tiles[k1][k2].body, map.tiles[k1][k2].shape)
                    map.tiles[k1][k2].fixture:setUserData("Tile")
                    -- map.addTile(k2, k1)
            end
        end
    end
end

function map.addTile(x, y)
    local worldX, worldY = map.getPosition(x, y)
    local index = #map.tiles + 1
    map.tiles[index] = {}
    map.tiles[index].body = love.physics.newBody(world, worldX, worldY, "static")
    map.tiles[index].shape = love.physics.newRectangleShape(32, 32)
    map.tiles[index].fixture = love.physics.newFixture(map.tiles[index].body, map.tiles[index].shape)
    map.tiles[index].fixture:setUserData("Tile")
end