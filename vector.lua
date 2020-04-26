vector = {}

function vector.normalise(v)
    length = math.sqrt(v.x * v.x + v.y * v.y)
    return {
        x = v.x / length,
	y = v.y / length
    }
end

function vector.distance(v1, v2)
    local x_diff = v1.x - v2.x
    local y_diff = v1.y - v2.y
    return math.sqrt(x_diff * x_diff - y_diff * y_diff)
end

