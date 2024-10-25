var dist = sprite_width / (array_length(ticks)-1);

draw_gui_line(x,y+(sprite_height/2),x+sprite_width,y+(sprite_height/2))

for(var i=0; i<array_length(ticks); i++) {
	var _x = x + i*dist;
	draw_gui_line(_x,y+(sprite_height/4),_x,y+(3*sprite_height/4))
	draw_set_font(fTooltip)
	draw_set_halign(fa_center)
	draw_set_valign(fa_top)
	draw_text(_x,y+sprite_height+4,string(ticks[i]))
}

var selected_x = x + (selected * dist);
draw_color_rectangle(selected_x-4,y,selected_x+4,y+sprite_height,c_white,false)
draw_color_rectangle(selected_x-4,y,selected_x+4,y+sprite_height,c_black,true)