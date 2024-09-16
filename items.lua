ItemGrow = Class {}
ItemShrink = Class {}
ItemNextlvl = Class {}
ItemKey = Class {}

-----------------------------
-----------------------------

function ItemGrow:init(x, y, growSteps)
    self.x = x
    self.y = y
    self.width = 30
    self.height = 30
    self.visible = true
    self.growSteps = growSteps
end

function ItemGrow:render()
    if self.visible then
        love.graphics.setColor(0.3, 0.8, 0.3, 255)
        love.graphics.rectangle("fill", self.x + 5, self.y + 5, self.width, self.height, 4, 4)

        love.graphics.setColor(40 / 255, 45 / 255, 52 / 255, 255 / 255, 255)
        love.graphics.setFont(font_snake)
        love.graphics.printf(self.growSteps, self.x, self.y + 10, 40, "center")
    end
end

function ItemGrow:action(snakess)
    snakess:grow(self.growSteps)

    self.visible = false

    if game_sound then
        sound_grow:stop()
        sound_grow:play()
    end
end
----------------------------------------------------------------SHRINK-------------
function ItemShrink:init(x, y, shrinkSteps)
    self.x = x
    self.y = y
    self.width = 30
    self.height = 30
    self.visible = true
    self.shrinkSteps = shrinkSteps
end

function ItemShrink:render()
    if self.visible then
        love.graphics.setColor(0.8, 0.4, 0.3, 255)
        love.graphics.rectangle("fill", self.x + 5, self.y + 5, self.width, self.height, 4, 4)

        love.graphics.setColor(40 / 255, 45 / 255, 52 / 255, 255 / 255, 255)
        love.graphics.setFont(font_snake)
        love.graphics.printf(self.shrinkSteps, self.x, self.y + 10, 40, "center")
    end
end

function ItemShrink:action(snakess)
    snakess:shrink(self.shrinkSteps)

    self.visible = false

    if game_sound then
        sound_shrink:stop()
        sound_shrink:play()
    end
end
----------------------------------------------------------------NEXT LEVEL-------------
function ItemNextlvl:init(x, y)
    self.x = x
    self.y = y
    self.width = 30
    self.height = 30
    self.visible = true
end

function ItemNextlvl:render()
    if self.visible then
        love.graphics.setColor(60 / 255, 180 / 255, 200 / 255, 255)
        love.graphics.rectangle("fill", self.x + 5, self.y + 5, self.width, self.height, 4, 4)

        love.graphics.setColor(40 / 255, 45 / 255, 52 / 255, 255 / 255, 255)
        love.graphics.setFont(font_snake)
        love.graphics.printf("N", self.x, self.y + 10, 40, "center")
    end
end

function ItemNextlvl:action(snake)
    if #snake.body - 1 == level then
        level = level + 1
        if level > lvl_unlock then
            love.filesystem.write(levelFile, level)
        end
        lvl_unlock = level
        self.visible = false

        if game_sound then
            sound_next:stop()
            sound_next:play()
        end
    end
end
----------------------------------------------------------------KEY-------------
function ItemKey:init(x, y, doorID)
    self.x = x
    self.y = y
    self.width = 30
    self.height = 30
    self.visible = true
    self.doorID = doorID
end

function ItemKey:render()
    if self.visible then
        love.graphics.setColor(113 / 255, 85 / 255, 28 / 255, 255)
        love.graphics.rectangle("fill", self.x + 5, self.y + 5, self.width, self.height, 4, 4)

        love.graphics.setColor(40 / 255, 45 / 255, 52 / 255, 255 / 255, 255)
        love.graphics.setFont(font_snake)
        love.graphics.printf("K", self.x, self.y + 10, 40, "center")
    end
end

function ItemKey:action()
    levels[level].doors[self.doorID].active = false

    self.visible = false
    if game_sound then
        sound_key:stop()
        sound_key:play()
    end
end
