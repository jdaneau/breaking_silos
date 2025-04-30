if selector != noone {
	draw_roundrect_color(x-4,y-4,x+sprite_width+4,y+sprite_height+4,global.colors.dark_blue_75,global.colors.dark_blue_75,false)
	draw_sprite(sprites[selector.index], 0, x, y)	
}