//draw main border
draw_color_rectangle(x,y,x+sprite_width,y+sprite_height,make_color_hsv(color_get_hue(c_blue),100,200),false)
draw_gui_border(x,y,x+sprite_width,y+sprite_height)

//draw lobbies
var row_height = round((h-64) / 3);
var row_sep = 16;
var header_height = round(row_height/4);
var join_width = round(w/4);
var n = array_length(lobbies);

for(var i=0; i<n; i++) {
	var row_x = x + 16;
	var row_y = y + 16 + (row_height * i) + (row_sep * i);
	draw_color_rectangle(row_x,row_y,row_x+w,row_y+row_height,c_white,false)
	draw_color_rectangle(row_x,row_y,row_x+w,row_y+header_height,make_color_hsv(color_get_hue(global.colors.myriad_light_blue),180,255),false)

	draw_gui_line(row_x+join_width,row_y+header_height,row_x+join_width,row_y+row_height)
	draw_gui_line(row_x,row_y+header_height,row_x+w,row_y+header_height)
	draw_gui_border(row_x,row_y,row_x+w,row_y+row_height)
	
	var lobby = lobbies[i];
	draw_set_font(fSidebar)
	draw_set_halign(fa_left)
	draw_set_valign(fa_top)
	draw_text(row_x+8,row_y+8,lobby.name)
	
	draw_set_font(fTooltip)
	draw_set_halign(fa_center)
	draw_text(row_x+w-(join_width/2),row_y+8,string("Connected players: {0}/8",array_length(lobby.players)))
	draw_set_color(c_red)
	draw_set_valign(fa_bottom)
	if lobby.open draw_set_color(c_lime)
	draw_text(row_x+w-(join_width/2),row_y+header_height-8,lobby.open? "Lobby open":"In-game")
	
	var icon_size = row_height - header_height - 16;
	var icon_scale = icon_size / sprite_get_width(sprIconIsland);
	var climate_sprite = sprIconTropical;
	var landscape_sprite = sprIconIsland;
	switch(lobby.climate_type) {
		case "Boreal": climate_sprite = sprIconBoreal; break;
		case "Temperate" : climate_sprite = sprIconTemperate; break;
	}
	switch(lobby.landscape_type) {
		case "Coastal": landscape_sprite = sprIconCoastal; break;
		case "Continental" : landscape_sprite = sprIconContinental; break;
	}
	draw_sprite_ext(climate_sprite,0,row_x+8,row_y+header_height+8,icon_scale,icon_scale,0,c_white,1)
	draw_sprite_ext(landscape_sprite,0,row_x+8+icon_size+8,row_y+header_height+8,icon_scale,icon_scale,0,c_white,1)
	draw_gui_border(row_x+8,row_y+header_height+8,row_x+8+icon_size,row_y+header_height+8+icon_size)
	draw_gui_border(row_x+icon_size+8,row_y+header_height+8,row_x+2*(8+icon_size),row_y+header_height+8+icon_size)
	
	//todo other stuff
}


//draw scroll wheel
var height_ratio = (n*row_height + (n-1)*row_sep) / h;
var scroll_height = h-32;
if height_ratio > 1 {
	scroll_height *= (1 / height_ratio)	
}
draw_gui_border(x+sprite_width-48,y+16,x+sprite_width-16,y+sprite_height-16)
draw_color_rectangle(x+sprite_width-48,y+16+scroll,x+sprite_width-16,y+16+scroll+scroll_height,c_ltgray,false)