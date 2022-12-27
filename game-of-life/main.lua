-- imports
local game = require "game"

-- variables
local game_state = 'menu'
local menus = {'Play', 'How To Play', 'Quit'}
local selected_menu_item = 1
local window_width
local window_height
local spacing

-- functions
local draw_menu
local menu_keypressed
local draw_how_to_play
local how_to_play_keypressed
local game_keypressed


function love.load()

    love.window.setTitle("Game of Life")
    love.graphics.setBackgroundColor(.15, .15, .15)

    cell_size = 10

    grid_x_count = 80
    grid_y_count = 60

    -- create grid
    grid = {}
    for y = 1, grid_y_count do
        grid[y] = {} -- create row
        for x = 1, grid_x_count do
            grid[y][x] = false
        end
    end

    -- get the width and height of the game window in order to center menu items
    window_width, window_height = love.graphics.getDimensions()

    -- value to calculate vertical positions of menu items
    spacing = 45

    -- with this set to true, holding a key down will call love.keypressed repeatedly
    love.keyboard.setKeyRepeat(true)

end


function love.update(dt)

    if game_state == 'game' then
        game.update()
    end

end


function love.draw()

    if game_state == 'menu' then
        draw_menu()
    elseif game_state == 'how-to-play' then
        draw_how_to_play()
    else -- game_state == 'game'
        game.draw()
    end

end


function draw_menu()

    local horizontal_center = window_width / 2
    local vertical_center = window_height / 2
    local start_y = vertical_center - (spacing * (#menus / 2))

    -- use the game grid as background
    game.draw()
    
    -- draw game title
    love.graphics.setNewFont("JetBrainsMono-ExtraBold.ttf", 40)
    love.graphics.setColor(0, 1, 1, 1)
    love.graphics.printf("Conway's Game of Life", 0, 150, window_width, 'center')

    -- set smaller font for the menu items
    love.graphics.setNewFont("JetBrainsMono-Bold.ttf", 30)

    -- draw menu items
    for i = 1, #menus do

        -- currently selected menu item is yellow
        if i == selected_menu_item then 
            love.graphics.setColor(1, 1, 0, 1)
        else -- other menu items are white
            love.graphics.setColor(1, 1, 1, 1)
        end

        -- draw this menu item centered
        love.graphics.printf(menus[i], 0, start_y + spacing * (i - 1), window_width, 'center')

    end

end


function draw_how_to_play()
    
    -- use the game grid as background
    game.draw()

    local intro = "The Game of Life is a cellular automaton devised by the British " ..
    "mathematician John Horton Conway in 1970. It is a zero-player game, meaning that " ..
    "its evolution is determined by its initial state, requiring no further input. " ..
    "One interacts with the Game of Life by creating an initial configuration and " ..
    "observing how it evolves. The status of each cell changes each turn of the game " ..
    "(also called a generation) depending on the statuses of that cell's 8 neighbors.\n\n"

    local text = "== CONTROLS ==\n" ..
    "> Left click to set a cell to alive\n" ..
    "> Right click to set a cell to dead\n" ..
    "> Press Esc to return to the menu\n" ..
    "> Press Delete to reset the game\n" ..
    "> Press any other key to step foward in time\n"

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setNewFont("JetBrainsMono-Bold.ttf", 20)
    love.graphics.printf(
        intro .. text,
        0,
        80,
        window_width,
        'center'
    )

    love.graphics.setColor(1, 1, 0, 1)
    love.graphics.setNewFont("JetBrainsMono-ExtraBold.ttf", 20)
    love.graphics.printf(
        "Press Esc to return",
        0,
        500,
        window_width,
        'center'
    )

end


function love.keypressed(key, scan_code, is_repeat)

    if game_state == 'menu' then
        menu_keypressed(key)
    elseif game_state == 'how-to-play' then
        how_to_play_keypressed(key)
    else -- game_state == 'game'
        game_keypressed(key)
    end

end


function menu_keypressed(key)

    -- pressing Esc on the main menu quits the game
    if key == 'escape' then
        love.event.quit()

    -- pressing up selects the previous menu item (if existing)
    elseif key == 'up' then
        if selected_menu_item >= 2 then
            selected_menu_item = selected_menu_item - 1
        end

    -- pressing down selects the next menu item (if existing) 
    elseif key == 'down' then
        if selected_menu_item < #menus then
            selected_menu_item = selected_menu_item + 1
        end

    -- pressing enter changes the game state (or quits the game)
    elseif key == 'return' or key == 'kpenter' then
        if menus[selected_menu_item] == 'Play' then
            game_state = 'game'
        elseif menus[selected_menu_item] == 'How To Play' then
            game_state = 'how-to-play'
        elseif menus[selected_menu_item] == 'Quit' then
            love.event.quit()
        end

    end

end


function how_to_play_keypressed(key)

    if key == 'escape' then
        game_state = 'menu'
    end

end


function game_keypressed(key)

    if key == 'escape' then
        game.reset()
        game_state = 'menu'
    elseif key == 'delete' then
        game.reset()
    else
        game.keypressed()
    end

end