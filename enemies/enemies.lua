local M = {}

function M.move_to_base(speed, dt)
    local current_pos = go.get_position()

    local direction = vmath.normalize(current_pos)
    direction.x = direction.x * -1
    direction.y = direction.y * -1

    local move_distance = direction * speed * dt
    local new_pos = current_pos + move_distance
    go.set_position(new_pos)
end

function M.rotate_to_base()
    local current_pos = go.get_position()
    local atan = math.atan2(current_pos.x, -current_pos.y)

    local rotation = vmath.quat_rotation_z(atan)
    go.set_rotation(rotation)
end

return M