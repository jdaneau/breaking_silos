if room != home_room {
	surface_free(chat_surface)
	instance_destroy()
	exit
}

if global.mouse_depth >= depth and mouse_wheel_up() and mouse_on {
	if chat_scroll < sprite_height { chat_scroll += sep }	
}
if global.mouse_depth >= depth and mouse_wheel_down() and mouse_on {
	if chat_scroll > 0 { chat_scroll -= sep }	
}