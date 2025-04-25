if sprite != noone {
	var subimg = 0;
	var caption_color = global.colors.light_blue;
	if (!toggle and click) or (toggle and on) { subimg = 2; caption_color = c_ltgray }
	else if hover { subimg = 1; caption_color = global.colors.light_blue_50 }
	draw_sprite(sprite,subimg,x,y)
	
	draw_set_font(font)
	draw_set_halign(fa_center)
	draw_set_valign(fa_top)
	draw_set_color(caption_color)
	draw_text(x+(sprite_width/2),y+sprite_get_height(sprite),text)
	
	exit
}

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
