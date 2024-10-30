if room != home_room {
	exit
}

if h > 1 and w > 1 and surface_exists(surf) {
	draw_surface_part(surf,max_w-w,0,w,h,draw_x-w,draw_y)
	draw_gui_border(draw_x-w,draw_y,draw_x,draw_y+h)
}