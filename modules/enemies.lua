local status = require "modules.status"

local M = {}

-- Only has vec3 as pos
M.placed_enemies = {}

function M.place(id, speed)
    M.placed_enemies[id] = {pos = go.get_position(id), speed = speed}
end

function M.update_pos(id)
    M.placed_enemies[id].pos = go.get_position(id)
end

function M.remove(id)
    M.placed_enemies[id] = nil

    status.enemies_remaining = status.enemies_remaining - 1
    if status.enemies_remaining == 0 then
        msg.post("/wave_controller#script", hash("wave_ended"))
    end
end

function M.get_closest_enemy_id(self_pos)
    local closest_enemy_id
    local closest_enemy_pos = vmath.vector3(math.huge, math.huge, 0)

    for key, value in pairs(M.placed_enemies) do
        local enemy_pos = value.pos

        if vmath.length_sqr(enemy_pos - self_pos) <
            vmath.length_sqr(closest_enemy_pos - self_pos) then

            closest_enemy_id = key
            closest_enemy_pos = enemy_pos
        end
    end

    -- If no enemy found
    if closest_enemy_pos.x == math.huge then
        return false
    end

    return closest_enemy_id
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
    local atan = math.atan2(current_pos.x - to.x, to.y - current_pos.y)

    local rotation = vmath.quat_rotation_z(atan)
    go.set_rotation(rotation)
end

return M