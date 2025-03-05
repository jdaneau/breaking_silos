tutorial_popup(room_width/2-200,room_height/2-100,TUTORIAL.USE_CALCULATOR)

calc_width = room_width * (3/4)
calc_height = room_height * (3/4)

calc_x = room_width/8
calc_y = room_height/8

calc_cur_w = 0
calc_cur_h = 0

open = true

calc_surface = surface_create(calc_width,calc_height)

selected = array_create(ds_map_size(global.measures), 0)
total = 0
budget = global.state.state_budget

mouse_calc_x = -1
mouse_calc_y = -1

// 5 rows for extra stuff, rest reserved for measures
row_height = calc_height / (ds_map_size(global.measures) + 5)
// column details for drawing calculator
column_headers = ["Measure","Cost","Unit","# Selected","Subtotal","Timespan"]
column_widths_relative = [0.25, 0.15, 0.125, 0.15, 0.125, 0.15]
for(var i=0; i<array_length(column_widths_relative); i++) {
	column_widths[i] = 	column_widths_relative[i] * calc_width
}

old_depth = global.mouse_depth
global.mouse_depth = depth