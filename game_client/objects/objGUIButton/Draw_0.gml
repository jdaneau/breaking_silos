var border_color, inside_color;

if (!toggle and click) or (toggle and on) {
	if hover { inside_color = global.colors.magenta_25 }
	else inside_color = global.colors.light_blue_25 
} else {
	inside_color = c_white
}

if hover {
	border_color = global.colors.magenta
} else border_color = global.colors.light_blue

if inverted {
	draw_gui_button(x,y,x+sprite_width,y+sprite_height,inside_color,border_color,text,font)
} else draw_gui_button(x,y,x+sprite_width,y+sprite_height,border_color,inside_color,text,font)
