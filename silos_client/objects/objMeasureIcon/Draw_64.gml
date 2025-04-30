if room != home_room {
	exit
}

var y_offset = 0;
if draw_y + h > room_height {
	y_offset = draw_y + h - room_height
}


if h > 1 and w > 1 and surface_exists(surf) {
	draw_surface_part(surf,max_w-w,0,w,h,draw_x-w,draw_y-y_offset)
	draw_gui_border(draw_x-w,draw_y-y_offset,draw_x,draw_y-y_offset+h)
}