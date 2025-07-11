if room != home_room {
	exit
}

if locked {
	draw_sprite_ext(sprite_index,0,x,y,1,1,0,c_gray,0.7)
}
else draw_self()

if !surface_exists(surf) {
	if max_w > 0 and max_h > 0 {
		surf = surface_create(max_w,max_h)
	}
}
	
if h > 1 and w > 1 and surface_exists(surf) {
	surface_set_target(surf)
	draw_color_rectangle(0,0,max_w,max_h,c_white,false)
	draw_set_font(fSidebar)
	draw_set_halign(fa_center)
	draw_set_valign(fa_top)
	draw_set_color(c_black)
	draw_text(max_w/2,8,name)
	draw_set_font(fTooltipBold)
	draw_text(max_w/4,48,string("Time: {0}",capitalize(time)))
	draw_text(max_w*(3/4),48,string("Cost: {0} coins/{1}",cost,unit))
	draw_set_halign(fa_left)
	draw_set_valign(fa_top)
	draw_set_font(fDescriptionBold)
	draw_text_ext(8,80,key_info,16,max_w-16)
	var info_height = string_height_ext(key_info,16,max_w-16);
	draw_set_font(fDescription)
	draw_text_ext(8,80+info_height+16,text,16,max_w-16)
	draw_set_color(c_white)
	surface_reset_target()
}

if selected {
	draw_gui_border(x,y,x+sprite_width,y+sprite_height,c_ltgray,true)
}