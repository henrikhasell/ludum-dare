require("tilemap")

function love.load()

    textures = {}
        -- Load the main sprite sheet.
        textures.spriteSheet = love.graphics.newImage("Assets/Exported/SpriteSheet.png")
        textures.spriteSheet:setFilter("nearest")
        -- Define quads for each sprite on the sheet.
        textures.quads = {}
            textures.quads.tile   = love.graphics.newQuad(32 * 0, 32 * 0, 32, 32, 32 * 4, 32 * 1)
            textures.quads.floor  = love.graphics.newQuad(32 * 1, 32 * 0, 32, 32, 32 * 4, 32 * 1)
            textures.quads.exit   = love.graphics.newQuad(32 * 2, 32 * 0, 32, 32, 32 * 4, 32 * 1)
            textures.quads.player = love.graphics.newQuad(32 * 3, 32 * 0, 32, 32, 32 * 4, 32 * 1)

    collision = {}
        collision.player = 1
        collision.bullet = 2
        collision.turret = 4
        collision.wall   = 8

    input = {}
        input.key = {}
            input.key.up    = false
            input.key.down  = false
            input.key.left  = false
            input.key.right = false

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

    tileMap = TileMap:new(tileMapData)
end

function love.update(dt)
    for key, value in pairs(input.key) do
        input.key[key] = love.keyboard.isDown(key)
    end

    tileMap:update(dt)
end

function love.draw()
    tileMap:draw()
end
