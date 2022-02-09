local M = {}

-- Only has vec3 as pos
local placed_enemies = {}

function M.place(pos)
    placed_enemies[#placed_enemies + 1] = {pos = pos} 
end

function M.get_closest_enemy(self_pos)
    if not placed_enemies[1] then
        return false
    end

    local closest_enemy_pos = placed_enemies[1].pos
    for i = 2, #placed_enemies do
        local enemy_pos = placed_enemies[i].pos
        if vmath.length_sqr(enemy_pos) < vmath.length_sqr(closest_enemy_pos) then
            closest_enemy_pos = enemy_pos
        end
    end

    return closest_enemy_pos
end

function M.move_to(speed, to, dt)
    local current_pos = go.get_position()

    local direction = vmath.normalize(current_pos - to)
    direction.x = direction.x * -1
    direction.y = direction.y * -1

    local move_distance = direction * speed * dt
    local new_pos = current_pos + move_distance
    go.set_position(new_pos)
end

function M.rotate_to(to)
    local current_pos = go.get_position()
    local atan = math.atan2(current_pos.x - to.x, -current_pos.y + to.x)

    local rotation = vmath.quat_rotation_z(atan)
    go.set_rotation(rotation)
end

return M