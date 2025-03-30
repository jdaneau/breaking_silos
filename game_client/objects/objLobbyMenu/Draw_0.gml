if room != home_room { exit; }
if !surface_exists(surf) surf = surface_create(w,surf_h)

//draw lobbies
var row_draw_offset = 32;
var header_height = round(row_h/3);
var footer_y = header_height + 16;
var n = array_length(lobbies);

surface_set_target(surf)
draw_clear_alpha(c_black,0);
for(var i=0; i<n; i++) {
	var row_x = 4;
	var row_y = 4 + (row_h * i) + (row_sep * i);
	
	//row borders & lines
	draw_gui_border(row_x,row_y,row_x+row_w,row_y+row_h)
	draw_gui_line(row_x+row_draw_offset,row_y+header_height,row_x+row_w-row_draw_offset,row_y+header_height)
	
	//lobby name / info
	var lobby = lobbies[i];
	var lobby_name = string_upper(lobby.name);
	var lobby_open = lobby.open? "LOBBY OPENED":"IN-GAME";
	var connected_players = string("CONNECTED PLAYERS: {0}/8",array_length(lobby.players));
	draw_set_font(fMyriadBold12)
	draw_set_halign(fa_left)
	draw_set_valign(fa_top)
	draw_set_color(global.colors.yellow)
	draw_text(row_x+row_draw_offset,row_y+row_draw_offset,lobby_name)
	draw_set_color(c_white)
	draw_text(row_x+row_draw_offset+string_width(lobby_name) + 16,row_y+row_draw_offset, "|")
	draw_set_color(c_red)
	if lobby.open draw_set_color(c_lime)
	var circle_radius = string_height("T")/2;
	draw_circle(row_x+row_draw_offset+string_width(lobby_name) + 32+circle_radius,row_y+row_draw_offset+circle_radius,circle_radius,false)
	draw_text(row_x+row_draw_offset+string_width(lobby_name) + 32 + (circle_radius*3),row_y+row_draw_offset,lobby_open)
	draw_set_color(c_white)
	draw_text(row_x+row_draw_offset+string_width(lobby_name) + 32 + (circle_radius*3) + string_width(lobby_open) + 16,row_y+row_draw_offset, "|")
	draw_text(row_x+row_draw_offset+string_width(lobby_name) + 32 + (circle_radius*3) + string_width(lobby_open) + 32,row_y+row_draw_offset, connected_players)
	
	//icons
	var icon_size = row_h - header_height - 32;
	var icon_scale = icon_size / sprite_get_width(sprIconIsland);
	var climate_sprite = sprIconTropical;
	var landscape_sprite = sprIconIsland;
	switch(lobby.settings.climate_type) {
		case "Boreal": climate_sprite = sprIconBoreal; break;
		case "Temperate" : climate_sprite = sprIconTemperate; break;
	}
	switch(lobby.settings.landscape_type) {
		case "Coastal": landscape_sprite = sprIconCoastal; break;
		case "Continental" : landscape_sprite = sprIconContinental; break;
	}
	draw_color_rectangle(row_x+row_draw_offset, footer_y,row_x+row_draw_offset+icon_size,footer_y+icon_size, global.colors.dark_blue_75,false)
	draw_color_rectangle(row_x+row_draw_offset+icon_size+16, footer_y,row_x+row_draw_offset+icon_size+16+icon_size,footer_y+icon_size, global.colors.dark_blue_75,false)
	draw_sprite_ext(climate_sprite,0,row_x+row_draw_offset,footer_y,icon_scale,icon_scale,0,c_white,1)
	draw_sprite_ext(landscape_sprite,0,row_x+row_draw_offset+icon_size+16,footer_y,icon_scale,icon_scale,0,c_white,1)
	
	//settings text
	draw_set_font(fMyriadBold10)
	var text_x = row_x+row_draw_offset+icon_size+16+icon_size+16;
	var text_y = row_y+header_height + 16
	var text_h = string_height("T");
	var text_sep = (icon_size - (text_h*3)) / 2;
	draw_set_halign(fa_left)
	draw_set_valign(fa_top)
	draw_text_multicolor(text_x,text_y,[{text:"Climate type : ",color:global.colors.light_blue_75},{text:string_upper(lobby.settings.climate_type),color:c_white}])
	draw_text_multicolor(text_x,text_y+text_h+text_sep,[{text:"Landscape type : ",color:global.colors.light_blue_75},{text:string_upper(lobby.settings.landscape_type),color:c_white}])
	draw_text_multicolor(text_x,text_y+2*(text_h+text_sep),[{text:"Climate change intensity : ",color:global.colors.light_blue_75},{text:string_upper(lobby.settings.climate_intensity),color:c_white}])
	
	text_x += string_width("Climate change intensity: "+lobby.settings.climate_intensity) + 32
	draw_text_multicolor(text_x,text_y,[{text:"Population : ",color:global.colors.light_blue_75},{text:string_upper(lobby.settings.population),color:c_white}])
	draw_text_multicolor(text_x,text_y+text_h+text_sep,[{text:"Country GDP : ",color:global.colors.light_blue_75},{text:string_upper(lobby.settings.gdp),color:c_white}])
	draw_text_multicolor(text_x,text_y+2*(text_h+text_sep),[{text:"Number of rounds : ",color:global.colors.light_blue_75},{text:string(lobby.settings.n_rounds),color:c_white}])
	
	//join button
	var button_w = 128;
	var button_h = 32;
	var button_x = row_x+row_w-row_draw_offset-button_w;
	var button_y = row_y+row_draw_offset-16;
	
	var hover = false;
	if array_length(button_click) < array_length(lobbies) {
		button_click = array_create(array_length(lobbies), false)	
	}
	if coords_in(mouse_surf_x,mouse_surf_y,button_x,button_y,button_x+button_w,button_y+button_h) {
		hover = true;
		if mouse_check_pressed(mb_left) {
			button_click[i] = true
		}
		if mouse_check_released(mb_left) and button_click[i] {
			with objOnline { send_string(MESSAGE.JOIN_GAME, lobby.lobby_id) }
		}
	} 
	if mouse_check_released(mb_left) {
		button_click[i] = false
	}
	
	var button_color = c_lime;
	
	if hover {
		button_color = global.colors.light_green_50
		draw_set_alpha(0.5)
		if button_click[i] {
			draw_gui_border(button_x,button_y,button_x+button_w,button_y+button_h,c_green,false)
			button_color = c_green
		}
		else 
			draw_gui_border(button_x,button_y,button_x+button_w,button_y+button_h,global.colors.light_green_50,false)
		draw_set_alpha(1)
	}
	
	draw_gui_border(button_x,button_y,button_x+button_w,button_y+button_h,button_color,true)
	draw_set_font(fMyriadBold12)
	draw_set_halign(fa_center)
	draw_set_valign(fa_middle)
	draw_set_color(button_color)
	draw_text(button_x+(button_w/2),button_y+(button_h/2),"Join Game")
	draw_set_color(c_white)
}
surface_reset_target()
draw_surface_part(surf,0,scroll,w,h,x+16,y+16)

//draw scroll bar
var scroll_top = y+16;
var scroll_bottom = y+sprite_height-16;
var scroll_height = scroll_bottom - scroll_top;
var scroll_bar_height = scroll_height;
var total_height = n*(row_h+row_sep);
if total_height > h { scroll_bar_height = scroll_height*(h / total_height) }

var scroll_amount = 0;
if scroll > 0 scroll_amount = (scroll / max_scroll);
scroll_amount *= (scroll_height - scroll_bar_height)
draw_color_rectangle(x+sprite_width+48,scroll_top,x+sprite_width+48+32,scroll_bottom,global.colors.light_blue_25,true)
draw_color_rectangle(x+sprite_width+48,scroll_top+scroll_amount,x+sprite_width+48+32,scroll_top+scroll_amount+scroll_bar_height,global.colors.dark_blue_75,false)

if coords_in(mouse_x,mouse_y,x+sprite_width+48,scroll_top+scroll_amount,x+sprite_width+48+32,scroll_top+scroll_amount+scroll_bar_height) {
	if mouse_check_pressed(mb_left) { 
		scroll_click = true	
		scroll_mouse_y = mouse_y
	}
}