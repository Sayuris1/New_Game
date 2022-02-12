local M = {}

-- Only has x, y
local placed_tokens = {}

function M.place(x, y)
    placed_tokens[#placed_tokens + 1] = {x = x, y = y}
end

-- Return true if x, y is a placeable pos
-- Else return false
function M.is_placable(x, y)
    -- If adjacent to one
    for i = 1, #placed_tokens do
        local distance = math.abs(placed_tokens[i].x - x) + math.abs(placed_tokens[i].y - y)
        if distance < 2 then

            -- If not on top of any
            for n = 1, #placed_tokens do
                print(x, y)
                print(placed_tokens[n].x, placed_tokens[n].y)
                if placed_tokens[n].x == x and placed_tokens[n].y == y then
                    return false
                end
            end

            return true
        end
    end

    return false
end

return M