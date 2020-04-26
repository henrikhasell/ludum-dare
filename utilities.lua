require('vector')

utilities = {}
    function utilities.getDirection(a, b)
        local relativePosition = {
            x = a.body:getX() - b.body:getX(),
            y = a.body:getY() - b.body:getY()
        }
        return vector.normalise(relativePosition)
    end

    -- Derive position of object from x/y coordinates.
    function utilities.getPosition(x, y)
        return (x - 0.5) * 32, (y - 0.5) * 32
    end
