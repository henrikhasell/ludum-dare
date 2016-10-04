utilities = {}
    -- Derive position of object from x/y coordinates.
    function utilities.getPosition(x, y)
        return (x - 0.5) * 32, (y - 0.5) * 32
    end