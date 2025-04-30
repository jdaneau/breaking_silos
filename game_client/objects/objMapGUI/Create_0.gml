home_room = room

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

pulse_timer = 0
pulse_length = game_get_speed(gamespeed_fps) * 2

map_surface = surface_create(global.map.width,global.map.height)

//information layers
show_drought_risk = false
show_flood_risk = false
show_cyclone_risk = false
show_watersheds = false
show_agriculture = false
show_population = false
show_flood_history = false
show_drought_history = false
layer_caption = ""

reset_info_layers = function() { 
	show_drought_risk = false
	show_flood_risk = false
	show_cyclone_risk = false
	show_watersheds = false
	show_agriculture = false
	show_population = false
	show_flood_history = false
	show_drought_history = false
	if placing {
		layer_caption = "Click on the measures to mark them on the map.\nLeft click = add, Right click = remove"
	} else layer_caption = ""
	
	with objGUIButton if toggle { on=false }
}

//placing mode
placing = false
selected_measure = -1

//list of projects for every tile (for tooltip)
tile_projects = {}
for(var i=0; i<array_length(global.map.land_tiles); i++) {
	var tile = global.map.land_tiles[i];
	var tx = tile.x div 64;
	var ty = tile.y div 64;
	var projects = [];
	for(var n=0; n<array_length(tile.implemented); n++) {
		var measure = tile.implemented[n];
		array_push(projects, {
			measure:measure, 
			days_remaining:0, 
			original_days_remaining:1, 
			time_string:""
		})
	}
	for(var n=0; n<array_length(tile.in_progress); n++) {
		var struct = tile.in_progress[n];
		var time = struct.days_remaining;
		var amount = "";
		if time > 730 { 
			time = time / 365
			time = string_format(time, 1, 2)
			amount = "years"
		} else if time > 60 {
			time = time / 30
			time = string_format(time, 1, 2)
			amount = "months"
		} else {
			amount = "days"
		}
		var time_string = string("{0} {1}",time,amount);
		array_push(projects, {
			measure:struct.measure, 
			days_remaining:struct.days_remaining, 
			original_days_remaining:struct.original_days_remaining, 
			time_string:time_string
		})
	}
	tile_projects [$ coords_to_grid(tx,ty,false)] = projects
}