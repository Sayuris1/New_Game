local M = {}

-- Only has x, y
local placed_tokens = {}

function M.place(x, y)
    placed_tokens[#placed_tokens + 1] = {x = x, y = y}
end

return M