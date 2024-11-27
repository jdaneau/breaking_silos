/// @description DEMO: Click-n-drag

// Follow mouse movement when dragged
if (move == true) {
	x += (global.device_mouse_scaled_x - global.device_mouse_scaled_xprevious);
	y += (global.device_mouse_scaled_y - global.device_mouse_scaled_yprevious);
}

// Clamp position to keep ruler inside the view it started in
if (xstart >= 3840) and (ystart >= 2160) {
	// Splitscreen view
	x = clamp(x, 3840, 5120 + camera_get_view_width(view_camera[1]));
	y = clamp(y, 2160, 2880 + camera_get_view_height(view_camera[1]));
} else {
	// Main view
	x = clamp(x, -1280, 3840);
	y = clamp(y, -720, 2160);
}