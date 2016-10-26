require("utilities")
require("wall")
require("player")
require("turret")
require("exit")
require("door")
require("fire")
require("key")

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
            instance.world   = love.physics.newWorld()
            instance.turrets = {}
            instance.bullets = {}
            instance.walls   = {}
            instance.doors   = {}
            instance.fires   = {}
            instance.keys    = {}

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

                if v2 == 0 or v2 == 2 or v2 == 3 or v2 == 5 or v2 == 6 or v2 == 7 or v2 == 8 then
                    self:addFloor(x, y)
                end
                if v2 == 1 then
                    self:addWall(x, y)
                end
                if v2 == 2 then
                    self:addPlayer(x, y)
                end
                if v2 == 3 then
                    self:addExit(x, y)
                end
                if v2 == 4 then
                    self:addTurret(x, y)
                end
                if v2 == 5 then
                    self:addDoor(x, y)
                end
                if v2 == 6 then
                    self:addKey(x, y)
                end
                if v2 == 7 then
                    self:addFire(x, y, Fire.direction.up)
                end
                if v2 == 8 then
                    self:addFire(x, y, Fire.direction.right)
                end
            end
        end
    end

    function TileMap:addWall(x, y)
        self.spriteBatch:add(textures.quads.tile, x - 16, y - 16)
        local wall = Wall:new(self, x, y)
        table.insert(self.walls, wall)
    end

    function TileMap:addFloor(x, y)
        self.spriteBatch:add(textures.quads.floor, x - 16, y - 16)
    end

    function TileMap:addPlayer(x, y)
        self.player = Player:new(self, x, y)
    end

    function TileMap:addExit(x, y)
        self.spriteBatch:add(textures.quads.exit, x - 16, y - 16)
        local exit = Exit:new(self, x, y)
    end

    function TileMap:addTurret(x, y)
        local turret = Turret:new(self, x, y)
        table.insert(self.turrets, turret)
    end

    function TileMap:addDoor(x, y)
        local door = Door:new(self, x, y)
        table.insert(self.doors, door)
    end

    function TileMap:addKey(x, y)
        local key = Key:new(self, x, y)
        table.insert(self.keys, key)
    end

    function TileMap:addFire(x, y, horizontal)
        local fire = Fire:new(self, x, y, horizontal)
        table.insert(self.fires, fire);
    end

    function TileMap:draw()
        love.graphics.draw(self.spriteBatch)

        for key, value in pairs(self.turrets) do
            -- TODO: Render turrets.
        end

        for key, value in pairs(self.doors) do
            value:draw()
        end

        for key, value in pairs(self.keys) do
            value:draw()
        end

        for key, value in pairs(self.bullets) do
            value:draw()
        end

        for key, value in pairs(self.fires) do
            value:draw()
        end

        if self.player then
            self.player:draw()
        end
    end

    function TileMap:update(dt)
        -- Update the player's velocity.
        if self.player then
            self.player:update()
        end
        -- Perform logic on all turrets.
        for key, value in pairs(self.turrets) do
            value:update(self, dt)
        end
        -- Perform logic on all bullets.
        local count = 1
        while count <= #self.bullets do
            -- Fetch the bullet at the current index:
            local bullet = self.bullets[count]
            -- If the bullet is finished then remove it:
            if bullet:finished() then
                table.remove(self.bullets, count)
            else
                count = count + 1
            end
        end
        -- Perform physics time-step.
        if not self.world:isDestroyed() then
            self.world:update(dt)
        end
    end

    function TileMap:removeKey(key)
        -- Perform a linear search for the key:
        for index, value in pairs(tileMap.keys) do
            if key == value then
                -- Remove the key from the tile map:
                local key = table.remove(tileMap.keys, index)
                -- Destroy the key body:
                key.body:destroy()
                break
            end
        end

        -- Check if all of the keys have been collected:
        if #tileMap.keys == 0 then
            -- Remove every door from the level:
            while #tileMap.doors ~= 0 do
                local door = table.remove(tileMap.doors)
                door.body:destroy()
            end
        end

    end

    function TileMap:destroy()
        -- Clear the background.
        self.spriteBatch:clear()
        -- Destroy the physics.
        self.world:destroy();
        -- Remove the player.
        self.player = null
        -- Remove all objects.
        self.turrets = {}
        self.bullets = {}
        self.walls = {}

    end

    function TileMap:speak()
        print("Bark!")
    end
