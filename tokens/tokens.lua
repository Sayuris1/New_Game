local M = {}

-- Only has x, y
local placed_tokens = {}

function M.place(x, y)
    placed_tokens[#placed_tokens + 1] = {x = x, y = y}
end

-- Return true if no token in x, y
-- Else return false
function M.is_free(x, y)
    for i = 1, #placed_tokens do
        if placed_tokens[i].x == x and placed_tokens[i].y == y then
            return false
        end
    end

    return true
end

return M