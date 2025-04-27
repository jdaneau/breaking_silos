if h > 1 and w > 1 {
	draw_gui_border(x+sprite_width,y,x+sprite_width+w,y+h,c_white,false)
	draw_surface_part(surf, 0,0,w,h,x+sprite_width,y)
}