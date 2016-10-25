PhysicsObject = {}

    PhysicsObject.metaTable = {}
        PhysicsObject.metaTable.__index = PhysicsObject 

    function PhysicsObject:new()
        local instance = {}
            setmetatable(instance, self.metaTable)
        return instance
    end

    function PhysicsObject:draw()

    end

    function PhysicsObject:update(dt)

    end

    function PhysicsObject:collision(tileMap, object)

    end

    function PhysicsObject:getName()
        return "PhysicsObject"
    end
