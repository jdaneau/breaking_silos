//panning
if mouse_check_button_pressed(mb_left) {
	mouse_xstart = window_views_mouse_get_x()
	mouse_ystart = window_views_mouse_get_y()
}
if mouse_check_button(mb_left) {
	view_xview += mouse_xstart - window_views_mouse_get_x()
	view_yview += mouse_ystart - window_views_mouse_get_y()
}


//zooming
if mouse_wheel_up() and view_wview > window_min_w {
	prev_view_x = view_wview
	prev_view_y = view_hview
	view_hview -= window_max_h/zoom_speed
	view_wview -= window_max_w/zoom_speed
	if view_wview < window_min_w {
		view_hview = window_min_h
		view_wview = window_min_w	
	}
	view_xview += abs(view_wview-prev_view_x)/2
	view_yview += abs(view_hview-prev_view_y)/2
}

//and just repeat the same code for zooming out only reverse the math.
if mouse_wheel_down() and view_wview < window_max_w {
	prev_view_x = view_wview
	prev_view_y = view_hview
	view_hview += window_max_h/zoom_speed
	view_wview += window_max_w/zoom_speed
	if view_wview > window_max_w { 
		view_hview = window_max_h
		view_wview = window_max_w
	}
	view_xview -= abs(view_wview-prev_view_x)/2
	view_yview -= abs(view_hview-prev_view_y)/2
}

view_xview = clamp(view_xview,0,room_width-view_wview)
view_yview = clamp(view_yview,0,room_height-view_hview)
	
camera_set_view_pos(camera,view_xview,view_yview)
camera_set_view_size(camera,view_wview,view_hview)
