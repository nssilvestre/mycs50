Level = Class {}
require "items"
require "snake"

function Level:init(walls, doors, items, snakes)
    self.coiso = 0
    self.walls = walls
    self.items = items
    self.snakes = snakes
    self.doors = doors    
end

function Level:play()
    love.graphics.setColor(40 / 255, 45 / 255, 52 / 255, 1)

    --draw borders walls
    for _, wall in ipairs(mainBox) do
        love.graphics.rectangle("fill", wall.x, wall.y, wall.width, wall.height)
    end
    -- draw walls
    for i, wall in ipairs(self.walls) do
        love.graphics.rectangle("fill", wall.x, wall.y, wall.width, wall.height)
    end

    -- draw itemns
    for i, item in ipairs(self.items) do
        item:render()
    end

    -- draw snakes
    next_level_open = false
    for i, snake in ipairs(self.snakes) do
        snake:render()
    end

    -- draw doors
    for i, door in ipairs(self.doors) do
        if door.active then
            love.graphics.setColor(40 / 255, 45 / 255, 52 / 255, 1)
            love.graphics.rectangle("fill", door.x, door.y, door.width, door.height)
        else
            love.graphics.setColor(40 / 255, 45 / 255, 52 / 255, 0.6)
            love.graphics.rectangle("fill", door.x, door.y, door.width, door.height)
        end
    end

    --draw lvl number, etc
    if next_level_open then
        love.graphics.setColor(60 / 255, 180 / 255, 200 / 255, 255)
    else
        love.graphics.setColor(0.7, 0.5, 0.2, 255)
    end
    love.graphics.rectangle("fill", VIRTUAL_WIDTH / 2 - 50, 10, 100, 80, 4, 4)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setFont(font_snake)
    love.graphics.printf("Goal", VIRTUAL_WIDTH / 2 - 50, 15, 100, "center")
    love.graphics.setFont(font_level)
    love.graphics.printf(level, VIRTUAL_WIDTH / 2 - 50, 30, 100, "center")

    --restart button
    love.graphics.rectangle("fill", VIRTUAL_WIDTH / 2 + 45, 20, 60, 60, 4, 4)
    love.graphics.setColor(0, 0, 0, 0.6)
    love.graphics.draw(btn_restart, VIRTUAL_WIDTH / 2 + 52, 25, 0, 0.09)

    --next and previous buttons
    love.graphics.rectangle("fill", 120, 10, 60, 35, 4, 4)
    if level < lvl_unlock then
        love.graphics.rectangle("fill", 190, 10, 60, 35, 4, 4)
    end
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setFont(font_snake)
    love.graphics.printf("<<", 120, 15, 60, "center")
    if level < lvl_unlock then
        love.graphics.printf(">>", 190, 15, 60, "center")
    end
end

function Level:update()
    for i, snake in ipairs(self.snakes) do
        for i, item in ipairs(self.items) do
            local shrink_food_distance = math.sqrt((snake.x - item.x) ^ 2 + (snake.y - item.y) ^ 2)
            if shrink_food_distance < 5 and item.visible then
                item:action(snake)
            end
        end
    end
end

function Level:snakeMove(stepx, stepy)
    qwr = {}

    for k, snake in ipairs(self.snakes) do
        next_x = snake.x + stepx
        next_y = snake.y + stepy
        collide = false

        -- check wall collision mainBOx
        for _, wall in ipairs(mainBox) do
            if
                next_x < wall.x + wall.width and next_x + 40 > wall.x and next_y < wall.y + wall.height and
                    next_y + 40 > wall.y
             then
                collide = true
            end
        end

        -- check wall collision
        for i, wall in ipairs(self.walls) do
            if
                next_x < wall.x + wall.width and next_x + 40 > wall.x and next_y < wall.y + wall.height and
                    next_y + 40 > wall.y
             then
                collide = true
            end
        end

        -- check doors collision
        for i, door in ipairs(self.doors) do
            if
                next_x < door.x + door.width and next_x + 40 > door.x and next_y < door.y + door.height and
                    next_y + 40 > door.y and
                    door.active
             then
                collide = true
            end
        end

        -- check for others snakes collisions / check body snake collision
        for i = 1, #self.snakes do
            for l = 1, #self.snakes[i].body - 1 do
                if self.snakes[i].body[l].x == next_x and self.snakes[i].body[l].y == next_y then
                    collide = true
                end
            end
            if i ~= k then -- se omitir if, a cobra pode se atravessar a si propria, e apenas
                if
                    self.snakes[i].body[#self.snakes[i].body].x == next_x and
                        self.snakes[i].body[#self.snakes[i].body].y == next_y
                 then
                    qwr[#qwr + 1] = k
                    collide = true
                end
            end
        end
        if not collide then
            snake:move(next_x, next_y)
        end
    end
    for iiii = 1, #qwr do
        next_x = self.snakes[qwr[iiii]].x + stepx
        next_y = self.snakes[qwr[iiii]].y + stepy

        colliderr = false
        for kl, snake in ipairs(self.snakes) do
            for l = 1, #snake.body do
                if snake.body[l].x == next_x and snake.body[l].y == next_y then
                    colliderr = true
                end
            end
        end
        if not colliderr then
            self.snakes[qwr[iiii]]:move(next_x, next_y)
        end
    end
end

function Level:restart()
    levels[level] = genLevel(levels_toLoad[level])
end

mainBox = {
    {x = 0, y = 0, width = VIRTUAL_WIDTH, height = 40},
    {x = 0, y = VIRTUAL_HEIGHT - 40, width = VIRTUAL_WIDTH, height = 40},
    {x = 0, y = 0, width = 40, height = VIRTUAL_HEIGHT - 10},
    {x = VIRTUAL_WIDTH - 40, y = 0, width = 40, height = VIRTUAL_HEIGHT}
}



-- Levels:

lvl_1 = {
    walls = {
        {x = 40, y = 280, width = 360, height = 80},
        {x = 0, y = 360, width = 160, height = 120},
        {x = 280, y = 360, width = 120, height = 80},
        {x = 0, y = 480, width = 640, height = 120},
        {x = 440, y = 120, width = 200, height = 320},
            --
        {x = 40, y = 40, width = 1000, height = 40},
        {x = 760, y = 200, width = 280, height = 40},
        {x = 640, y = 360, width = 320, height = 80},
        {x = 400, y = 80, width = 280, height = 40}
    },

    doors = {
        {x = 440, y = 440, width = 200, height = 40, active = true}
    },

    items = {
        ItemGrow(720, 120, 2),
        ItemGrow(920, 120, 5),
        ItemGrow(920, 480, 15),
        ItemGrow(400, 320, 7),
        ItemShrink(920, 280, 6),
        ItemShrink(720, 280, 3),
        ItemKey(240, 400, 1),
        ItemNextlvl(80, 120)
    },

    snakes = {
        Snake(80, 200, 1)
    }
}

lvl_2 = {
    walls = {
        {x = 40, y = 40, width = 840, height = 80},
        {x = 40, y = 80, width = 40, height = 520},
        {x = 80, y = 520, width = 800, height = 40},
        {x = 840, y = 80, width = 40, height = 160},
        {x = 840, y = 400, width = 40, height = 120},
        {x = 120, y = 160, width = 680, height = 40}, -- 6
        {x = 120, y = 440, width = 680, height = 40},
        {x = 760, y = 200, width = 40, height = 240},
        {x = 120, y = 200, width = 40, height = 80},
        {x = 120, y = 360, width = 40, height = 80}, -- 10
        {x = 240, y = 240, width = 400, height = 40},
        {x = 240, y = 280, width = 40, height = 80},
        {x = 240, y = 360, width = 400, height = 40},
        {x = 120, y = 360, width = 40, height = 80}
    },

    doors = {
        {x = 880, y = 440, width = 160, height = 40, active = true},
        {x = 880, y = 160, width = 160, height = 40, active = true}
    },

    items = {
        ItemGrow(240, 120, 2),
        ItemShrink(440, 120, 3),
        ItemGrow(640, 120, 8),
        ItemShrink(640, 480, 1),
        ItemGrow(440, 480, 3),
        ItemShrink(240, 480, 7),
        ItemGrow(320, 400, 3),
        ItemShrink(560, 200, 7),
        ItemNextlvl(920, 80),
        ItemKey(1000, 360, 1),
        ItemKey(880, 520, 2)
    },

    snakes = {
        Snake(480, 320, 4)
    }
}

lvl_3 = {
    walls = {
        {x = 120, y = 360, width = 40, height = 80},
        {x = 520, y = 320, width = 160, height = 40},
        {x = 720, y = 160, width = 80, height = 80},
        {x = 880, y = 440, width = 80, height = 120},
        {x = 240, y = 400, width = 240, height = 80},
        {x = 120, y = 80, width = 80, height = 40},
        {x = 320, y = 200, width = 40, height = 120},
        {x = 880, y = 240, width = 40, height = 240},
        {x = 720, y = 400, width = 80, height = 80},
        {x = 520, y = 120, width = 40, height = 40}
    },

    doors = {},

    items = {
        ItemGrow(240, 120, 2),
        ItemShrink(120, 200, 3),
        ItemGrow(640, 120, 8),
        ItemShrink(640, 480, 1),
        ItemGrow(440, 480, 3),
        ItemShrink(240, 480, 7),
        ItemGrow(960, 360, 3),
        ItemShrink(560, 200, 7),
        ItemNextlvl(120, 280)
    },

    snakes = {
        Snake(240, 320, 2),
        Snake(720, 80, 4),
        Snake(360, 240, 4),
        Snake(440, 320, 7)
    }

}

lvl_4 = {
    walls = {
        {x = 80, y = 80, width = 120, height = 40},
        {x = 120, y = 120, width = 40, height = 160},
        {x = 240, y = 80, width = 40, height = 200},
        {x = 280, y = 160, width = 80, height = 40},
        {x = 320, y = 200, width = 40, height = 80},
        {x = 400, y = 80, width = 40, height = 40},
        {x = 400, y = 160, width = 40, height = 120},
        {x = 520, y = 80, width = 80, height = 40},
        {x = 480, y = 120, width = 40, height = 40},
        {x = 520, y = 160, width = 40, height = 40},
        {x = 560, y = 200, width = 40, height = 40},
        {x = 480, y = 240, width = 80, height = 40},
        {x = 760, y = 80, width = 80, height = 40},
        {x = 720, y = 120, width = 40, height = 120},
        {x = 760, y = 240, width = 80, height = 40},
        {x = 920, y = 80, width = 80, height = 40},
        {x = 880, y = 120, width = 40, height = 40},
        {x = 920, y = 160, width = 40, height = 40},
        {x = 960, y = 200, width = 40, height = 40},
        {x = 880, y = 240, width = 80, height = 40},
        {x = 80, y = 320, width = 40, height = 160},
        {x = 120, y = 480, width = 40, height = 40},
        {x = 160, y = 440, width = 40, height = 40},
        {x = 200, y = 480, width = 40, height = 40},
        {x = 240, y = 320, width = 40, height = 160},
        {x = 320, y = 360, width = 40, height = 160},
        {x = 360, y = 320, width = 40, height = 40},
        {x = 400, y = 360, width = 40, height = 160},
        {x = 360, y = 400, width = 40, height = 40},
        {x = 520, y = 320, width = 80, height = 40},
        {x = 480, y = 360, width = 40, height = 40},
        {x = 520, y = 400, width = 40, height = 40},
        {x = 560, y = 440, width = 40, height = 40},
        {x = 480, y = 480, width = 80, height = 40},
        {x = 720, y = 320, width = 120, height = 40},
        {x = 720, y = 360, width = 40, height = 80},
        {x = 760, y = 400, width = 40, height = 40},
        {x = 800, y = 440, width = 40, height = 40},
        {x = 720, y = 480, width = 80, height = 40},
        {x = 880, y = 320, width = 120, height = 40},
        {x = 880, y = 360, width = 40, height = 120},
        {x = 880, y = 480, width = 120, height = 40},
        {x = 960, y = 360, width = 40, height = 120}
    },

    doors = {
        {x = 40, y = 40, width = 600, height = 280, active = true},
        {x = 40, y = 320, width = 600, height = 240, active = true},
        {x = 640, y = 40, width = 400, height = 280, active = true},
        {x = 640, y = 320, width = 400, height = 200, active = true}
    },

    items = {
        ItemKey(800, 520, 1),
        ItemKey(840, 520, 2),
        ItemKey(920, 520, 3),
        ItemKey(960, 520, 4)
    },

    snakes = {
        Snake(680, 520, 3)
    },

}


levels_toLoad = { lvl_1, lvl_2, lvl_3, lvl_4 }


