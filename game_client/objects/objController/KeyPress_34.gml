role_id_index -= 1
if role_id_index < 0 { role_id_index = array_length(role_ids)-1 }

global.state.role = role_ids[role_id_index]

room_restart()