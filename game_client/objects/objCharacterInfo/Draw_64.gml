if h > 1 and w > 1 {
	draw_sprite_part(info_spr,0,0,0,w,h,x+sprite_width+8,y-8)	
	draw_gui_border(x+sprite_width+8,y-8,x+sprite_width+8+w,y-8+h)
}