map_x = x
map_y = y
map_w = sprite_width
map_h = sprite_height
map_gui_scale = global.map.width/map_w

map_zoom = 1
map_camera_x = 0
map_camera_y = 0
map_camera_w = global.map.width
map_camera_h = global.map.height

mouse_map_x = 0
mouse_map_y = 0
mouse_in_map = false
mouse_last_x = -1
mouse_last_y = -1
tooltip = ""

map_surface = surface_create(global.map.width,global.map.height)

//information layers
show_drought_hazard = false
show_flood_hazard = false
show_cyclone_hazard = false
show_watersheds = false
show_agriculture = false
show_population = false
show_flood_history = false
show_drought_history = false
layer_caption = ""

reset_info_layers = function() { 
	show_drought_hazard = false
	show_flood_hazard = false
	show_cyclone_hazard = false
	show_watersheds = false
	show_agriculture = false
	show_population = false
	show_flood_history = false
	show_drought_history = false
	layer_caption = ""
	
	with objGUIButton if toggle { on=false }
}

coords_to_grid = function(_i,_j,real_coords=true) {
	if real_coords {
		_i = _i div 64;
		_j = _j div 64;
	}
	var _alpha = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	return (string_char_at(_alpha,_i+1) + string(_j+1))
}
grid_to_coords = function(_square,real_coords=true) {
	var _alpha = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	var _i = string_pos(string_char_at(_square,1),_alpha) - 1; //string indices in GM start at 1, not 0
	var _j = real(string_char_at(_square,2)) - 1
	if real_coords return [_i*64,_j*64] else return [_i,_j]
}

//placing mode
placing = false
selected_measure = noone