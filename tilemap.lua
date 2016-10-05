require("textures")
require("utilities")
require("player")
require("turret")

TileMap = {}

    TileMap.metaTable = {}
        TileMap.metaTable.__index = TileMap

    function TileMap:new(tileMapData)
        local instance = {}
            setmetatable(instance, self.metaTable)

            -- Calculate the width/height of the map:
            local w = #tileMapData[1]
            local h = #tileMapData

            -- Variables for rendering:
            instance.spriteBatch = love.graphics.newSpriteBatch(textures.spriteSheet, w * h)

            -- Variables for physical world:
            instance.world = love.physics.newWorld()
            instance.turrets = {}
            instance.bullets = {}
            instance.tiles = {}

            -- Load tiles:
            instance:initialise(tileMapData)

        -- Return new TileMap instance:
        return instance
    end

    function TileMap:initialise(tileMapData)
        for k1,v1 in pairs(tileMapData) do
            for k2,v2 in pairs(v1) do
                -- World position derived from coordinates:
                x, y = utilities.getPosition(k2, k1)

                if v2 == 0 then
                    self:addFloor(x, y)
                end
                if v2 == 1 then
                    self:addTile(x, y)
                end
                if v2 == 2 then
                    self:addFloor(x, y)
                    self:addPlayer(x, y)
                end
                if v2 == 3 then
                    self:addFloor(x, y)
                    self:addExit(x, y)
                end
                if v2 == 4 then
                    self:addTurret(x, y)
                end
            end
        end
    end

    function TileMap:addTile(x, y)
        self.spriteBatch:add(textures.quads.tile, x - 16, y - 16)
        
        local tile = {}
            tile.body    = love.physics.newBody(self.world, x, y, "static")
            tile.shape   = love.physics.newRectangleShape(32, 32)
            tile.fixture = love.physics.newFixture(tile.body, tile.shape)

        table.insert(self.tiles, tile)
    end

    function TileMap:addFloor(x, y)
        self.spriteBatch:add(textures.quads.floor, x - 16, y - 16)
    end

    function TileMap:addPlayer(x, y)
        print("Adding player at " .. x .. ", " .. y)
        self.player = Player:new(self, x, y)
    end

    function TileMap:addExit(x, y)
        print("Adding exit at " .. x .. ", " .. y)
    end

    function TileMap:addTurret(x, y)
        print("Adding turret at " .. x .. ", " .. y)
        local turret = Turret:new(self, x, y)
        table.insert(self.turrets, turret)
    end

    function TileMap:draw()
        love.graphics.draw(self.spriteBatch)
        for key, value in pairs(self.turrets) do
            -- TODO: Render turrets.
        end

        for key, value in pairs(self.bullets) do
            -- TODO: Render bullets.
        end
        
        self.player:draw()
    end

    function TileMap:update(dt)
        self.world:update(dt)
        self.player:update()
    end

    function TileMap:speak()
        print("Bark!")
    end
