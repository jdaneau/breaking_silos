/// @description DEMO: Draw UI elements

// Draw logo
draw_sprite_scaled(spr_logo_xtend, 0, view_xcenter, 32, 0.33, 0.15, 0.5);

// Get button state
if (device_mouse_check_button(0, mb_left)) {
	window_set_cursor(cr_size_all);
}

// Reset cursor state
if (device_mouse_check_button_released(0, mb_left)) {
	window_set_cursor(cr_default);
}