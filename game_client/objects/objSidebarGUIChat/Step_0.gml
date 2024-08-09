if mouse_wheel_up() and mouse_on {
	if chat_scroll < sprite_height { chat_scroll += sep }	
}
if mouse_wheel_down() and mouse_on {
	if chat_scroll > 0 { chat_scroll -= sep }	
}