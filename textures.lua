textures = {}
    -- Load the main sprite sheet.
    textures.spriteSheet = love.graphics.newImage("Assets/Exported/SpriteSheet.png")
    textures.spriteSheet:setFilter("nearest")
    -- Define quads for each sprite on the sheet.
    textures.quads = {
        tile   = love.graphics.newQuad(32 * 0, 32 * 0, 32, 32, 32 * 4, 32 * 1),
        floor  = love.graphics.newQuad(32 * 1, 32 * 0, 32, 32, 32 * 4, 32 * 1),
        exit   = love.graphics.newQuad(32 * 2, 32 * 0, 32, 32, 32 * 4, 32 * 1),
        player = love.graphics.newQuad(32 * 3, 32 * 0, 32, 32, 32 * 4, 32 * 1)
    }
