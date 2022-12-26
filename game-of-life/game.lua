function update()

    -- calculate the cell where the cursor is at;
    -- math.min sets a maximum value for the selected x/y (so it stays within the grid)
    selected_x = math.min(math.floor(love.mouse.getX() / cell_size) + 1, grid_x_count)
    selected_y = math.min(math.floor(love.mouse.getY() / cell_size) + 1, grid_y_count)

    -- if cell is left clicked  --> set to alive
    -- if cell is right clicked --> set to dead
    if love.mouse.isDown(1) then
        grid[selected_y][selected_x] = true
    elseif love.mouse.isDown(2) then
        grid[selected_y][selected_x] = false
    end

end


-- if any key is pressed, creates a new grid
function keypressed()

    local next_grid = {}

    -- create next grid
    for y = 1, grid_y_count do
        next_grid[y] = {}
        for x = 1, grid_x_count do
            local neighbor_count = 0

            for dy = -1, 1 do
                for dx = -1, 1 do
                    if not (dy == 0 and dx == 0)
                    and grid[y + dy] -- check if cell is within grid
                    and grid[y + dy][x + dx] then
                        neighbor_count = neighbor_count + 1
                    end
                end
            end
            
            -- if any cell has exactly 3 neighbors alive --> set to alive
            -- if cell was alive and has 2 neighbors alive --> set to alive
            -- else --> set to dead (false)
            next_grid[y][x] = neighbor_count == 3 or (grid[y][x] and neighbor_count == 2)
        end
    end

    grid = next_grid

end


function reset()

    grid = {}
    for y = 1, grid_y_count do
        grid[y] = {} -- create row
        for x = 1, grid_x_count do
            grid[y][x] = false
        end
    end

end


function draw()

    for y = 1, grid_y_count do -- draws all the cells (every cell in every row)
        for x = 1, grid_x_count do -- draws a row of cells
            local cell_draw_size = cell_size - 1

            if x == selected_x and y == selected_y then -- highlights selected cell
                love.graphics.setColor(1, 1, 0)
            elseif grid[y][x] == true then -- cell is alive -> color
                love.graphics.setColor(1, 0, 1)
            else
                love.graphics.setColor(0, 0, 0) -- default color
            end
        
            love.graphics.rectangle(
                'fill',              --mode
                (x - 1) * cell_size, -- top-left corner x
                (y - 1) * cell_size, -- top-left corner y
                cell_draw_size,      -- width
                cell_draw_size       -- height
            )
        end
    end

end


return { 
    update = update,
    keypressed = keypressed,
    reset = reset,
    draw = draw,
}