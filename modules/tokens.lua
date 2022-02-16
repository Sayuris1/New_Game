local utils = require "modules.utils"
local token_types = require "modules.token_types"

local M = {}

-- Need to remember all effects to all tiles
local tile_effects = {}
for i = -150, 150 do
    tile_effects[i] = {}
    for n = -150, 150 do
        tile_effects[i][n] = {effect_reload = 0, effect_dmg = 0}
    end
end

-- Only has x, y
local placed_tokens = {}

-- Using tile positions as index. Can be negative.
-- So we are holding lowest and highest positions to easily iterate.
local placed_borders = {high = {x = 0, y = 0}, low = {x = 0, y = 0}}

local function notify_listeners(tile, token_type)
    for i = #placed_borders.low.x, #placed_borders.high.x do
        local token_x = placed_tokens[i]
        if token_x then
            for n = #placed_borders.low.y, #placed_borders.high.y do
                if token_x[n] and token_x[n].type.listens == token_type then
                    local own_tile = {x = i, y = n}
                    token_x[n].type.notify(tile_effects, placed_tokens, placed_borders,
                        tile, own_tile)
                end
            end
        end
    end
end

function M.place(tile, token_type)
    -- Check if lowest or highest
    if tile.x > placed_borders.high.x then
        placed_borders.high.x = tile.x
    elseif tile.x < placed_borders.low.x then
        placed_borders.low.x = tile.x
    end

    if tile.y > placed_borders.high.y then
        placed_borders.high.y = tile.y
    elseif tile.y < placed_borders.low.y then
        placed_borders.low.y = tile.y
    end

    -- Create tile.x table if not exist
    if not placed_tokens[tile.x] then
        placed_tokens[tile.x] = {}
    end

    -- Place tile to placed_tokens table
    local token_type = token_types[token_type]
    placed_tokens[tile.x][tile.y] = {
        type = token_type,
        active_hp = token_type.base_hp, current_hp = token_type.base_hp,
        active_dmg = token_type.base_dmg,
        active_reload = token_type.base_reload
    }

    -- Sends a referance to placed_tokens. Not a copy
    token_type.ability(tile_effects, placed_tokens, placed_borders, tile)
    -- Notify listener tokens
    notify_listeners(tile, token_type)

    return placed_tokens[tile.x][tile.y]
end

-- Return true if a token is in tile
-- Else return false
function M.is_placed(tile)
    local middle = placed_tokens[tile.x]
    if middle and middle[tile.y] then
        return true
    end

    return false
end

-- Return true if tile is a placeable tile
-- Else return false
function M.is_placable(tile)
    local middle = placed_tokens[tile.x]
    if middle then
        -- If a token placed to that tile
        if middle[tile.y] then
            return false

        elseif middle[tile.y + 1] or middle[tile.y - 1] then
            return true
        end
    end

    local right = placed_tokens[tile.x + 1]
    if right and right[tile.y] then
        return true
    end

    local left = placed_tokens[tile.x - 1]
    if left and left[tile.y] then
        return true
    end

    return false
end

return M