Snake = Class {}

function Snake:init(x, y, len)
    self.x = x
    self.y = y
    self.len = len
    --self.next_x = x
    --self.next_y = y
    self.head = {
        eye1 = {x = 1, y = 1, w = 2, h = 2, color = {R = 0.5, G = 0.5, B = 0.5}},
        eye2 = {x = 1, y = 1, w = 2, h = 2, color = {R = 0.5, G = 0.5, B = 0.5}},
        mouth = {x = 4, y = 1, w = 2, h = 2, color = {R = 0.5, G = 0.5, B = 0.5}}
    }

    self.body = {}

    for i = 1, len do
        table.insert(self.body, {x = x, y = y})
    end
end

function Snake:render()
    love.graphics.setFont(font_snake)

    -- draw body
    for i = 2, #self.body do
        if #self.body - 1 == level then --
            love.graphics.setColor(60 / 255, 180 / 255, 200 / 255, 255)
        else
            love.graphics.setColor(0.7, 0.5, 0.2, 255)
        end

        --love.graphics.setColor(0.7, 0.5, 0.2, 255)
        love.graphics.rectangle("fill", self.body[i].x + 5, self.body[i].y + 5, 30, 30, 4, 4)

        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.printf(i - 1, self.body[i].x, self.body[i].y + 10, 40, "center")
    end

    love.graphics.setColor(0.3, 0.3, 0.8, 255)
    love.graphics.rectangle("fill", self.body[1].x + 5, self.body[1].y + 5, 30, 30, 4, 4)

    if #self.body - 1 == level then --
        next_level_open = true
    end
end

function Snake:move(x, y)
    self.x = x
    self.y = y

    table.insert(self.body, 1, {x = x, y = y})
    table.remove(self.body, #self.body)
    --print("x: " .. self.x .. " y: " .. self.y)
    if game_sound then
        if sound_move:isPlaying() then
            sound_move:stop()
        end
        sound_move:play()
    end
end

function Snake:grow(steps)
    for i = 1, steps do
        table.insert(self.body, {x = self.body[#self.body].x, y = self.body[#self.body].y})
    end

    if #self.body - 1 == level then
        sound_next:play()
    end
end

function Snake:shrink(steps)
    if #self.body <= steps then
        steps = #self.body - 1
    end

    for i = 1, steps do
        table.remove(self.body, #self.body)
    end

    if #self.body - 1 == level then
        sound_next:play()
    end
end
