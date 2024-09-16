## **My CS50x final project 2023**
# **Smake it**
#### Video Demo:  https://www.youtube.com/watch?v=Ol_-oAL9j9w
#### Description: Snake game
### Welcome to Smake it Game! A fun and challenging game where you control a snake and navigate through different levels while collecting items, opening doors and matching the rigth size of your snake to progress to the next level.

### A simple Snake game built using the LÖVE framework and Lua programming language.
#
## **Getting Started**
### For PC:
    1. Download the source code from this repository.
    2. Install Love2D game engine on your computer.
    3. Open the terminal/command prompt and navigate to the directory where the source code is located.
    4. Run the command `love .` to start the game.

### For android:
    1. Download the source code from this repository.
    2. Install Love2D for android
    3. Open game_file.love file from a file browser

## Game Instructions
    • Use the arrow keys or touch gestures to move the snake around the level
    • Tap and hold to keep the snake moving
    • Collect items to grow or shrink the snake, indicated by the number of 'steps' shown on the item
    • Collect the "key" item to open locked doors, allowing to move the snake into differente areas.
    • The goal is to match the size of the snake to the number indicated on the level, 
    • If you reach that goal, it allows you to collect the ‘next level’ item 
    • Collect the "next level" item to progress to the next level ‘N’
    • Use the restart button to start the level over.
    • Use the << and >> buttons to navigate between levels.
    • Press M to mute/unmute, ESC to go to menu and exit the game. SPACE to start and R to restart the game

## Features
    • Multiple levels
    • Items to collect
    • Sound effects and music
    • Restart and level navigation buttons
    • Shrink and grow items to change the snake's size
    • Next level item
    • Key item to open doors
    • On-screen gestures
#
## In the main.lua file:
Initialization of main variables, including references to fonts, sounds and images used in the game. And loads the current level from a file, if it exists.

It loads all the levels for the game. (from levels.lua)

Implementation of controls, including keyboard keys and button clicks, as well as on-screen gestures such as tap and hold to keep the snake moving.

Menu implementation, including options for starting the game, navigating between levels, and adjusting settings such as sound and music. Smooth transition effect between the menu and play part of the game.

Obtaining the direction in which the snake intends to move, based on user input.

#
## In the levels.lua file:
The game features different tables for game objects, each level table stores the walls, items, doors and snakes specific to that level. Each table includes information on the object's coordinates and dimensions. 

The game also includes collision detection between different snakes, collision detection with walls and doors, and checks to see if the snake can advance in the direction it intends to move. 

Also it draws the objects from the different tables on the screen.

When the snake reaches an item, the game performs accordingly depending on the item's type. 

When the snake reaches the required size for the current level, its body changes color to indicate that it can move to the next level.

We can easily add more levels to the game following the same structure.
#
## In the items.lua file:
Implementation of different types of items, including items for growing, shrinking, door keys, and portals to the next level.

Items for growing are green and contain the number of steps the snake will grow.
Items for shrinking are red and contain the number of steps the snake will shrink.
Key items are brown and open locked doors.

Next level items are blue and contain an 'N'. They can only be collected when the snake has the required size for the current level. 

When collected, the game automatically saves the current level in a file.

Each item plays a sound when collected by the snake.
#
## In the snake.lua file:
Finally, in the snake.lua file, each snake is created with a unique position, head, body, and length
Methods for rendering the snake on the screen, moving the snake in the intended direction and growing or shrinking the snake.
#
## Challenges
Understand the use of the `love.update()` and `love.draw()` functions which are executed every frame.
And how to use the delta time **dt** variable to control the speed of transitions of the game and to make the long touch or long key press work as I intended.

Figuring out how to work with different screen sizes and resolutions to make the game look good and play well on different devices, by using the push library to handle the different screen sizes.

Collision detection was fun :) 
#
## Acknowledgments
Inspiration for this game comes from the classic Snake game that can be found on various mobile devices and game consoles. And has been enjoyed by millions of people all over the world.

This was my first game, and my first program in Love2D, so it was a great learning experience for me.
##
    • This was CS50!
## Author
 Nelson Stanga Silvestre
