if calc_cur_w == 0 or calc_cur_h == 0 { exit }

var i, _x;

surface_set_target(calc_surface)

draw_color_rectangle(0,0,calc_width,calc_height,c_white,false)

/////////////////////////////////////////////////
//                calculator               [x] //
// measure  | cost  | ...					   //
// hospital | 3,000 | ...					   //
// ...										   //
// -------------------------------			   //
// calculated total : x  | national budget : x //
//                       | money left :      x //
/////////////////////////////////////////////////

//title and X button
draw_set_color(make_color_hsv(color_get_hue(c_red),50,255))
draw_rectangle(calc_width-row_height,0,calc_width,row_height,false)
draw_set_color(c_black)
draw_line_color(0,row_height,calc_width,row_height,c_black,c_black)
draw_line_color(calc_width-row_height, 0, calc_width-row_height, row_height, c_black, c_black)
draw_set_font(fTooltipBold)
draw_set_color(c_black)
draw_set_valign(fa_middle)
draw_set_halign(fa_center)
draw_text(calc_width/2,row_height/2,"Calculator")
draw_text(calc_width-(row_height/2),(row_height/2),"X")


//headers           
_x = 0;
draw_line_color(0,row_height*2,calc_width,row_height*2,c_black,c_black)
for(i=0; i<array_length(column_headers); i++) {
	if i > 0 draw_line_color(_x,row_height,_x,row_height*2,c_black,c_black)
	draw_text(_x+(column_widths[i]/2),row_height+(row_height/2),column_headers[i])
	_x += column_widths[i]
}

//main rows
var row_content, measure, subtotal, row_y, text_x;
for(i=0; i<ds_map_size(global.measures); i++) {
	row_y = row_height*(2+i)
	draw_line_color(0,row_y+row_height,calc_width,row_y+row_height,c_black,c_black)
	measure = ds_map_find_value(global.measures,i)
	subtotal = measure.cost * selected[i]
	row_content = [measure.name, measure.cost, "/"+measure.unit, measure.min_cell, selected[i], subtotal, measure.time]
	_x = 0
	for(var j=0; j<array_length(column_headers); j++) {
		if j == 0 { // draw measure titles in bold, all others non-bolded
			draw_set_font(fTooltipBold)
		} else draw_set_font(fTooltip)
		if j == 3 or j == 4 { // draw single digits in the center instead of left-justified
			draw_set_halign(fa_center) 
			text_x = _x+(column_widths[j]/2)
		} else { 
			draw_set_halign(fa_left) 
			text_x = _x+8
		}
		if j == 4 { // draw selection buttons
			draw_line_color(_x+32,row_y,_x+32,row_y+row_height,c_black,c_black)
			draw_text(_x+16,row_y+(row_height/2),"-")
			draw_line_color(_x+column_widths[j]-32,row_y,_x+column_widths[j]-32,row_y+row_height,c_black,c_black)
			draw_text(_x+column_widths[j]-16,row_y+(row_height/2),"+")
		}
		if j > 0 draw_line_color(_x,row_y,_x,row_y+row_height,c_black,c_black)
		draw_text(text_x,row_y+(row_height/2),string(row_content[j]))
		_x += column_widths[j]
	}
}

//end lines
var end_y = calc_height - (row_height*2);
draw_line_color(0, end_y, calc_width, end_y, c_black,c_black)
draw_set_font(fSidebar)
draw_set_halign(fa_left)
draw_text(16, end_y+(row_height/2), "Calculated Total: "+string(total))
draw_line_color(calc_width/2, end_y, calc_width/2, calc_height, c_black,c_black)
draw_text(calc_width/2 + 16, end_y+(row_height/2),            "National Budget: "+string(global.state.state_budget))
draw_text(calc_width/2 + 16, end_y+row_height+(row_height/2), "Money Left:      "+string(global.state.state_budget-total))

draw_set_color(c_white)
surface_reset_target()

draw_surface_part(calc_surface,0,0,calc_cur_w,calc_cur_h,calc_x,calc_y)
draw_gui_border(calc_x,calc_y,calc_x+calc_cur_w,calc_y+calc_cur_h)