if h > 1 and w > 1 {
	draw_sprite_part_ext(info_spr,0,0,0,w,h,x+sprite_width+8,y-8,scale,scale,c_white,1)	
	draw_gui_border(x+sprite_width+8,y-8,x+sprite_width+8+(w*scale),y-8+(h*scale))
}