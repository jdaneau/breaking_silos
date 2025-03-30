var dist = sprite_width / (array_length(ticks)-1);

draw_line_width_color(x,y+(sprite_height/2),x+sprite_width,y+(sprite_height/2), 3, global.colors.dark_blue_75, global.colors.dark_blue_75)

for(var i=0; i<array_length(ticks); i++) {
	var _x = x + i*dist;
	draw_line_width_color(_x,y+(sprite_height/4),_x,y+(3*sprite_height/4),3, global.colors.dark_blue_75, global.colors.dark_blue_75)
	draw_set_font(fMyriad12)
	draw_set_halign(fa_center)
	draw_set_valign(fa_top)
	draw_text(_x,y+sprite_height+4,string(ticks[i]))
}

var selected_x = x + (selected * dist);
draw_circle_color(selected_x,y+(sprite_height/2),(sprite_height/2)-4,c_white,c_white,false)
draw_circle_color(selected_x,y+(sprite_height/2),(sprite_height/2)-5,global.colors.light_blue,global.colors.light_blue,false)