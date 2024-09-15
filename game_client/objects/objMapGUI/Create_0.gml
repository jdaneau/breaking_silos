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

//placing mode
placing = false
selected_measure = noone