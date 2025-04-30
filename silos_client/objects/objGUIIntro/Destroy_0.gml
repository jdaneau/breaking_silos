with my_button instance_destroy()

global.mouse_depth = old_depth

if room == rInGame and global.state.current_phase == "introduction" {
	with objController
	event_user(0) // trigger old room start event from controller	
}