//determine if the mouse is over the map
if coords_in(mouse_x,mouse_y,map_x,map_y,map_x+map_w,map_y+map_h) {
	mouse_map_x = map_camera_x + (mouse_x-map_x)*map_gui_scale*(1/map_zoom)
	mouse_map_y = map_camera_y + (mouse_y-map_y)*map_gui_scale*(1/map_zoom)
	mouse_in_map = true
} else {
	mouse_in_map = false
	mouse_map_x = -1
	mouse_map_y = -1
}

//don't allow using the map if the calculator is open (random polish)
if instance_exists(objGUICalculator) and objGUICalculator.open {
	mouse_in_map = false	
}

//handle map zooming in/out
if mouse_in_map and mouse_wheel_up() and map_zoom<3 {
	map_zoom += 0.2
	var _old_w = map_camera_w;
	var _old_h = map_camera_h;
	map_camera_w = global.map.width * (1/map_zoom)
	map_camera_h = global.map.height * (1/map_zoom)
	map_camera_x += (_old_w - map_camera_w) / 2
	map_camera_y += (_old_w - map_camera_h) / 2
	map_camera_x = clamp(map_camera_x,0,global.map.width-map_camera_w)
	map_camera_y = clamp(map_camera_y,0,global.map.height-map_camera_h)
}
else if mouse_in_map and mouse_wheel_down() and map_zoom>1 {
	map_zoom -= 0.2
	var _old_w = map_camera_w;
	var _old_h = map_camera_h;
	map_camera_w = global.map.width * (1/map_zoom)
	map_camera_h = global.map.height * (1/map_zoom)
	map_camera_x += (_old_w - map_camera_w) / 2
	map_camera_y += (_old_w - map_camera_h) / 2
	map_camera_x = clamp(map_camera_x,0,global.map.width-map_camera_w)
	map_camera_y = clamp(map_camera_y,0,global.map.height-map_camera_h)
}

//handle map scrolling
if mouse_last_x != -1 {
	var _scale = global.map.width / map_w;
	var _dx = (mouse_last_x - mouse_x) * map_gui_scale * (1/map_zoom)
	var _dy = (mouse_last_y - mouse_y) * map_gui_scale * (1/map_zoom)
	map_camera_x = clamp(map_camera_x+_dx,0,global.map.width-map_camera_w)
	map_camera_y = clamp(map_camera_y+_dy,0,global.map.height-map_camera_h)
}

if mouse_in_map and mouse_check_button(mb_left) {
	mouse_last_x = mouse_x
	mouse_last_y = mouse_y
} else if mouse_last_x != -1 and mouse_check_button(mb_left) {
	mouse_last_x = mouse_x
	mouse_last_y = mouse_y
} else if mouse_last_x != -1 and !mouse_check_button(mb_left) {
	mouse_last_x = -1
	mouse_last_y = -1
}

//handle map pinging
if mouse_in_map and mouse_check_button_pressed(mb_right) {
	var _x = mouse_map_x div 64;
	var _y = mouse_map_y div 64;
	var _mark = instance_create_depth(_x,_y,-1,objMarker);
	var _square = coords_to_grid(mouse_map_x,mouse_map_y)
	with objSidebarGUIChat chat_add(string("{0} has highlighted square {1}!","Player1",_square))
}