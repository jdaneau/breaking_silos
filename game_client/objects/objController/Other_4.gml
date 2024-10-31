if room == rInit {
	global.maps = ds_map_create()
	room_goto(rMap01) //init map data
}

global.mouse_depth = 0;

if os_browser != browser_not_a_browser {
	camera_set_view_size(view_camera[0],bw,bh)
	camera_set_view_pos(view_camera[0],((-bw)/2)+camera_get_view_width(view_camera[0])/2,((-bh)/2)+camera_get_view_height(view_camera[0])/2)
	surface_resize(application_surface,view_wport[0],view_hport[0])
}