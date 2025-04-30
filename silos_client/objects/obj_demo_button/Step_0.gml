/// @description DEMO: Interact button

// Mouse hover
if  (device_mouse_x_to_gui(0) > x - sprite_xoffset)
and (device_mouse_x_to_gui(0) < x + sprite_xoffset)
and (device_mouse_y_to_gui(0) > y - sprite_yoffset)
and (device_mouse_y_to_gui(0) < y + sprite_yoffset) {
	window_set_cursor(cr_handpoint);
	image_index = 1;
} else {
	// Reset on unhover
	image_index = 0;
	
	// Also reset cursor if no other buttons are hovered
	var button_hovered = false;
	with (obj_demo_button) {
		if (image_index == 1) {
			button_hovered = true;
		}
	}
	
	if (!button_hovered) {
		if (window_get_cursor() == cr_handpoint) {
			window_set_cursor(cr_default);
		}
	}
}

// Mouse select
if (device_mouse_check_button_pressed(0, mb_left)) {
	if (image_index == 1) {
		// Perform action
		action();
		
		// Flash button on press
		image_index = 0;
	}
}