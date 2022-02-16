local M = {}

-- Returns tokens if exist
-- Else returns false
local function is_token_exist(tokens, x, y)
    local token_x = tokens[x]
    if not token_x then
        return false
    end

    local token = token_x[y]
    if not token then
        return false
    end

    return token
end

M.red_tower = {
    base_hp = 30, base_dmg = 10, base_reload = 0.5,
    listens = nil,

    -- Decrease the reload time of the all tokens by 0.1
    -- In the same row or line
    ability = function (tile_effect, tokens, borders, placed_tile)
        for i = -150, 150 do
            local tile = tile_effect[placed_tile.x][i]
            tile.effect_reload = tile.effect_reload - 0.1
        end

        for i = -150, 150 do
            local tile = tile_effect[i][placed_tile.y]
            tile.effect_reload = tile.effect_reload - 0.1
        end

        local tile = tile_effect[placed_tile.x][placed_tile.y]
        tile.type = "red_tower"
        tile.effect_reload = tile.effect_reload + 0.2

        for i = borders.low.x, borders.high.x do
            local token = is_token_exist(tokens, i, placed_tile.y)
            if token then
                local tile_effect = tile_effect[i][placed_tile.y].effect_reload

                token.active_reload = token.type.base_reload
                token.active_reload = token.active_reload + tile_effect
            end
        end

        for i = borders.low.y, borders.high.y do
            local token = is_token_exist(tokens, placed_tile.x, i)
            if token then
                local tile_effect = tile_effect[placed_tile.x][i].effect_reload

                token.active_reload = token.type.base_reload
                token.active_reload = token.active_reload + tile_effect
            end
        end
    end
}

M.red_tower_leader = {
    base_hp = 30, base_dmg = 10, base_reload = 0.5,
    listens = "red_tower",

    -- Increase self dmg by 5
    -- for every red_tower in the same row or line
    ability = function(tile_effect, tokens, borders, placed_tile)
        local own_tile_effect = tile_effect[placed_tile.x][placed_tile.y]
        for i = borders.low.x, borders.high.x do
            local token = is_token_exist(tokens, i, placed_tile.y)
            if token and token.type == M.red_tower then
                own_tile_effect.effect_dmg = own_tile_effect.effect_dmg + 5
            end
        end

        for i = borders.low.y, borders.high.y do
            local token = is_token_exist(tokens, placed_tile.x, i)
            if token and token.type == M.red_tower then
                own_tile_effect.effect_dmg = own_tile_effect.effect_dmg + 5
            end
        end

        local dmg = tokens[placed_tile.x][placed_tile.y].active_dmg
        tokens[placed_tile.x][placed_tile.y].active_dmg = dmg + own_tile_effect.effect_dmg
    end
}

return M