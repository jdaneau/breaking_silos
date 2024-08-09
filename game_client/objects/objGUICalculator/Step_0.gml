if open {
	if calc_cur_w < (calc_width-1) { calc_cur_w = lerp(calc_cur_w, calc_width, 0.1) }
	if calc_cur_h < (calc_height-1) { calc_cur_h = lerp(calc_cur_h, calc_height, 0.1) }	

	if coords_in(mouse_x, mouse_y, calc_x, calc_y, (calc_x+calc_cur_w), (calc_y+calc_cur_h)) {
		mouse_calc_x = mouse_x - calc_x
		mouse_calc_y = mouse_y - calc_y
	}

	//calculator buttons
	if mouse_check_button_pressed(mb_left) {
		//check for x button
		if coords_in(mouse_calc_x,mouse_calc_y,calc_width-row_height,0,calc_width,row_height) {
			open = false
		}
	
		//check for add/subtract buttons
		var _select_col_x = column_widths[0]+column_widths[1]+column_widths[2]+column_widths[3];
		var _select_row_y;
		for(var i=0; i<ds_map_size(global.measures); i++) {
			_select_row_y = row_height*(2+i)
			// subtract button
			if coords_in(mouse_calc_x,mouse_calc_y,_select_col_x,_select_row_y,_select_col_x+32,_select_row_y+row_height) {
				if selected[i] > 0 {
					selected[i] -= 1
					total -= ds_map_find_value(global.measures,i).cost 
				}
			}
			// add button
			if coords_in(mouse_calc_x,mouse_calc_y,_select_col_x+column_widths[4]-32,_select_row_y,_select_col_x+column_widths[4],_select_row_y+row_height) {
				var _cost = ds_map_find_value(global.measures,i).cost;
				if total+_cost <= global.state.state_budget {
					selected[i] += 1
					total += _cost 
				}
			}
		}
	}
}
else {
	mouse_calc_x = -1
	mouse_calc_y = -1 
	
	calc_cur_w = lerp(calc_cur_w, 0, 0.1) 
	calc_cur_h = lerp(calc_cur_h, 0, 0.1) 	
	if calc_cur_w < 1 or calc_cur_h < 1 { 
		calc_cur_w = 0
		calc_cur_h = 0
	}
}