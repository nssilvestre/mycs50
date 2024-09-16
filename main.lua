Class = require "class"
push = require "push"

font_level = love.graphics.setNewFont(55)
font_rstquit = love.graphics.setNewFont(40)
font_snake = love.graphics.setNewFont(15)

title_logo = love.graphics.newImage("/graphics/title1.png")
btn_play = love.graphics.newImage("/graphics/play.png")
btn_restart = love.graphics.newImage("/graphics/restart3.png")
btn_menu = love.graphics.newImage("/graphics/menu1.png")
btn_sound_on = love.graphics.newImage("/graphics/sound.png")
btn_sound_off = love.graphics.newImage("/graphics/sound_off.png")
btn_music_on = love.graphics.newImage("/graphics/music.png")
btn_music_off = love.graphics.newImage("/graphics/music_off.png")

sound_grow = love.audio.newSource("/sounds/grow.mp3", "static")
sound_shrink = love.audio.newSource("/sounds/shrink.mp3", "static")
sound_key = love.audio.newSource("/sounds/door.mp3", "static")
sound_next = love.audio.newSource("/sounds/next.mp3", "static")
sound_move = love.audio.newSource("/sounds/move.mp3", "static")
music_bg = love.audio.newSource("/sounds/music.mp3", "stream")

game_sound = true
game_music = true

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 1080
VIRTUAL_HEIGHT = 600

levels = {}
require "levels"

gameState = "menu"


function love.load()   ----------------------
    levelFile = "lvl.txt"
    local levelData = love.filesystem.read(levelFile) or 1

    level = tonumber(levelData)
    lvl_unlock = level
    
    --love.graphics.setDefaultFilter('nearest', 'nearest')

    if love.system.getOS() == "Android" then
        push:setupScreen(
            VIRTUAL_WIDTH,
            VIRTUAL_HEIGHT,
            WINDOW_WIDTH,
            WINDOW_HEIGHT,
            {
                fullscreen = true,
                resizable = false,
                vsync = true
            }
        )
    else
        push:setupScreen(
            VIRTUAL_WIDTH,
            VIRTUAL_HEIGHT,
            WINDOW_WIDTH,
            WINDOW_HEIGHT,
            {
                fullscreen = false,
                resizable = true,
                vsync = true
            }
        )
    end

    love.window.setTitle("Smake it - v.0.1")

    setlevels()
    
    move_step = 40

    music_bg:play()
end

function genLevel(lvl_)
    local cloneTable = deepcopy(lvl_)
    return Level(cloneTable.walls, cloneTable.doors, cloneTable.items, cloneTable.snakes)
end

function setlevels()
    for ii = 1, #levels_toLoad do
        table.insert(levels, genLevel(levels_toLoad[ii]))
    end
end

function love.resize(w, h)
    push:resize(w, h)
end

direction = ""

local touching = false
local touching_time = 0
local long_touching = false
local pressing_time = 0

move = true
toplay = false
transition = 1

function love.update(dt)
    if toplay then
        transition = transition - dt / 0.25
        if transition < -1 then
            gameState = "play"
            toplay = false
        end
    end

    if gameState == "menu" then
    elseif gameState == "play" then
        --print("level: " .. level)
        levels[level]:update()

        -- touch control
        if validDirection then
            if touching then
                touching_time = touching_time + dt
                if touching_time > 0.5 then
                    move = true
                    long_touching = true
                    touching_time = 0.3
                else
                    move = false --
                end
            else
            end
        end

        -- keyboard control
        if love.keyboard.isDown("w", "a", "s", "d") then
            pressing_time = pressing_time + dt
            if pressing_time > 0.5 then
                move = true
                pressing_time = 0.4
            else
                move = false --
            end

            if love.keyboard.isDown("w") then
                direction = "w"
            end
            if love.keyboard.isDown("a") then
                direction = "a"
            end
            if love.keyboard.isDown("s") then
                direction = "s"
            end
            if love.keyboard.isDown("d") then
                direction = "d"
            end
        end
    end

    if game_music then
        if not music_bg:isPlaying() then
            love.audio.play(music_bg)
        end
        music_bg:setVolume(0.4)
    else
        music_bg:setVolume(0)
    end
end

function love.draw()
    love.graphics.clear(40 / 255, 45 / 255, 52 / 255, 255 / 255)
    push:start()

    if gameState == "menu" then
        displayMenu()
    elseif gameState == "play" then
        love.graphics.setColor(220 / 255, 220 / 255, 220 / 255, 255, transition)
        love.graphics.rectangle("fill", 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT, transition)

        levels[level]:play()
        if move then
            if direction == "d" then
                levels[level]:snakeMove(move_step, 0)
            end
            if direction == "a" then
                levels[level]:snakeMove(-move_step, 0)
            end
            if direction == "w" then
                levels[level]:snakeMove(0, -move_step)
            end
            if direction == "s" then
                levels[level]:snakeMove(0, move_step)
            end
        end
        if not long_touching then
            move = false
        end
    elseif gameState == "options" then
        displayOptions()
    end

    push:finish()
end

function displayMenu()
    --love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 10, 10)
    --ove.graphics.print(score, 20, 20)

    love.graphics.setColor(180 / 255, 200 / 255, 220 / 255, transition)
    love.graphics.rectangle("fill", 40, 40, VIRTUAL_WIDTH - 80, VIRTUAL_HEIGHT - 80, 10, 10)

    -- linha cobra superior
    --love.graphics.setColor(0.7, 0.5, 0.2, transition)
    --for i = 1, 12 do
    --love.graphics.rectangle("fill", 280 + i*40, 280, 30, 30, 4, 4)
    --end
    --love.graphics.setColor(0.3, 0.3, 0.8, transition)
    --love.graphics.rectangle("fill", 280, 280, 30, 30, 4, 4)

    --linha cobra inferior
    love.graphics.setColor(0.7, 0.5, 0.2, transition)
    for i = 1, 12 do
        love.graphics.rectangle("fill", 240 + i * 40, 460, 30, 30, 4, 4)
    end
    love.graphics.setColor(0.3, 0.3, 0.8, transition)
    love.graphics.rectangle("fill", 760, 460, 30, 30, 4, 4)

    -- title
    love.graphics.setColor(1, 1, 1, transition)
    love.graphics.draw(title_logo, VIRTUAL_WIDTH / 2 - 260, 120, 0.0, 1.6)

    --button play, music, sound
    love.graphics.draw(btn_play, 320, 280, 0, 0.7)

    if game_music then
        love.graphics.draw(btn_music_on, 600, 370, 0, 0.3)
    else
        love.graphics.draw(btn_music_off, 600, 370, 0, 0.3)
    end
    if game_sound then
        love.graphics.draw(btn_sound_on, 680, 370, 0, 0.3)
    else
        love.graphics.draw(btn_sound_off, 680, 370, 0, 0.3)
    end
end

function love.keyreleased(key)
    if key == "w" or key == "a" or key == "s" or key == "d" then
        move = true
        pressing_time = 0
    end
end

function love.keypressed(key)
    if key == "m" then
        game_music = not game_music
    end
    if gameState == "menu" then
        if key == "escape" then
            love.event.quit()
        elseif key == "space" then
            toplay = true
        end
    elseif gameState == "play" then
        if key == "w" or key == "a" or key == "s" or key == "d" then
            move = true
        end

        if key == "escape" then
            gameState = "menu"
            toplay = false
            transition = 1
        end

        if key == "r" then
            levels[level]:restart() 
        end
    end
end

local touch_id = nil
local touch_start_x = nil
local touch_start_y = nil
local isButtonPressed = false

function love.touchpressed(id, x, y, dx, dy, pressure)
    touch_start_x = x
    touch_start_y = y
    touch_id = id
    touching = true

    local x, y = push:toGame(x, y)

    if x and y then
        if gameState == "menu" then
            if x > 605 and x < 660 and y > 371 and y < 428 then
                music = false
            end
            if x > 682 and x < 740 and y > 374 and y < 426 then
                music = true
            end
            if x > 328 and x < 460 and y > 283 and y < 423 then
                toplay = true
            end
        elseif gameState == "play" then
            if x > 589 and x < 638 and y > 21 and y < 72 then
                levels[level]:restart() 
            end
        end
    end
end

validDirection = false
function love.touchmoved(id, x, y, dx, dy, pressure)
    --local x, y = push:toGame(x, y)
    if x and y then
        xx = math.abs(x - touch_start_x)
        yy = math.abs(y - touch_start_y)

        if xx > 25 or yy > 25 then
            if id == touch_id then
                if xx > yy then
                    if touch_start_x < x then -- RIGHT
                        direction = "d"
                    elseif touch_start_x > x then -- LEFT
                        direction = "a"
                    end
                elseif xx < yy then
                    if touch_start_y < y then -- UP
                        direction = "s"
                    elseif touch_start_y > y then -- DOWN
                        direction = "w"
                    end
                end
            end
            validDirection = true
        else
            validDirection = false
        end
    else
        --validDirection = false
    end
end

function love.touchreleased(id, x, y, dx, dy, pressure)
    if gameState == "play" then
        if long_touching then
            move = false
        elseif validDirection then
            move = true
        end

        long_touching = false
        touching = false
        touching_time = 0
    end
end

function love.mousepressed(x, y, button, istouch)
    local x, y = push:toGame(x, y)
    if x and y then
        if gameState == "menu" and button == 1 then
            if x > 328 and x < 460 and y > 283 and y < 423 then
                toplay = true
            end

            if x > 605 and x < 660 and y > 371 and y < 428 then
                game_music = not game_music
            end

            if x > 682 and x < 740 and y > 374 and y < 426 then
                game_sound = not game_sound
            end
        elseif gameState == "play" and button == 1 then
            if x > 589 and x < 638 and y > 21 and y < 72 then --restart
                levels[level]:restart()    -- = levels[level]:restart() --levels = setlevels()
                
                --table.remove(levels, level)
                --table.insert(levels, level, genLevel(levels_toLoad[level]))
            
            end
            if x > 121 and x < 177 and y > 10 and y < 43 then
                if level > 1 then
                    level = level - 1
                    levels[level]:restart() 
                end
            end
            if x > 191 and x < 247 and y > 10 and y < 43 then
                if level < #levels_toLoad and level < lvl_unlock then
                    level = level + 1
                end
            end
        end
    print("x: " .. x .. " y: " .. y)
    end
end


function deepcopy(orig, visited)
    visited = visited or {}
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        if visited[orig] then
            return visited[orig]
        end
        copy = {}
        visited[orig] = copy
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key, visited)] = deepcopy(orig_value, visited)
        end
        setmetatable(copy, deepcopy(getmetatable(orig), visited))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end