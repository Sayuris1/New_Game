local M = {}

-- Searches key inside table
-- Works if table only contais index
function M.find_array(table, key)
    for i = 1, #table do
        if table[i] == key then

            return i
        end
    end

    return false
end

return M