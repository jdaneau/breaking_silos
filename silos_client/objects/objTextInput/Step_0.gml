t++

if t >= (game_get_speed(gamespeed_fps) / 2) {
	t=0
	line_flash = !line_flash
}

if mouse_check_pressed(mb_left) {
	if coords_in(mouse_x, mouse_y, x, y, x+sprite_width, y+sprite_height) {
		keyboard_string = ""
		active = true
	} else active = false
}