/// @description DEMO: Click-n-drag cameras

// Get view to drag based on mouse position
if (device_mouse_check_button_pressed(0, mb_left)) {
	if (mouse_x > 3840) and (mouse_y > 2160) {
		view_move = 1;
	} else {
		view_move = 0;
	}
	
	// Set drag start position
	event_perform(ev_step, ev_step_begin);
	event_perform(ev_step, ev_step_end);
}

// Skip if ruler is dragged
for (var i = 0; i < instance_number(obj_demo_ruler); i++) {
	if (instance_find(obj_demo_ruler, i).move == true) {
		exit;
	}
}

// Drag camera
camera_set_view_pos( 
	view_camera[view_move],
	camera_get_view_x(view_camera[view_move]) - (global.device_mouse_scaled_x - global.device_mouse_scaled_xprevious),
	camera_get_view_y(view_camera[view_move]) - (global.device_mouse_scaled_y - global.device_mouse_scaled_yprevious)
);

// Clamp cameras to prevent overlapping views
var view_cam_x = clamp(camera_get_view_x(view_camera[0]), -1280, 3840 - view_width);
var view_cam_y = clamp(camera_get_view_y(view_camera[0]), -720, 3840 - view_height);
camera_set_view_pos(view_camera[0], view_cam_x, view_cam_y);

var view_cam_x = clamp(camera_get_view_x(view_camera[1]), 3840, 5120);
var view_cam_y = clamp(camera_get_view_y(view_camera[1]), 2160, 2880);
camera_set_view_pos(view_camera[1], view_cam_x, view_cam_y);