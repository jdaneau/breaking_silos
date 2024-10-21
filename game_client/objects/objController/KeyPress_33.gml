role_id_index += 1
if role_id_index >= array_length(role_ids) { role_id_index = 0 }

global.state.role = role_ids[role_id_index]

with objMapGUI reset_info_layers()
room_restart()
