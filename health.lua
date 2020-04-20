health_bar_w = 50
health_bar_h = 10
health_bar_p = 2


function draw_health_bar(x, y, amount)
    x = x - health_bar_w / 2
    y = y - health_bar_h / 2
    local p = health_bar_p
    local inner_w = health_bar_w - p * 2
    local inner_h = health_bar_h - p * 2
    love.graphics.rectangle('fill', x, y, health_bar_w, health_bar_h)
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle('line', x, y, health_bar_w, health_bar_h)
    love.graphics.rectangle('fill', x + p, y + p, inner_w, inner_h)
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle('fill', x + p, y + p, amount * inner_w, inner_h)
    love.graphics.setColor(1, 1, 1)
end
