if h > 1 and w > 1 {
	var index = 0;
	if objOnline.lobby_settings.climate_type == "Tropical" { index = 1 }
	if objOnline.lobby_settings.climate_type == "Boreal" { index = 2 }
	draw_sprite_part(sprMapLegend,index,0,0,w,h,x+sprite_width+8,y-8)	
	draw_gui_border(x+sprite_width+8,y-8,x+sprite_width+8+w,y-8+h)
}