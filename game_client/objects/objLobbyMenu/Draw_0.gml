if room != home_room { exit; }
if !surface_exists(surf) surf = surface_create(w,surf_h)

//draw main border
draw_color_rectangle(x,y,x+sprite_width,y+sprite_height,make_color_hsv(color_get_hue(global.colors.myriad_dark_blue),100,200),false)
draw_gui_border(x,y,x+sprite_width,y+sprite_height)

//draw lobbies
var header_height = round(row_h/4);
var join_width = round(row_w/4);
var n = array_length(lobbies);

surface_set_target(surf)
for(var i=0; i<n; i++) {
	var row_x = 2;
	var row_y = 2 + (row_h * i) + (row_sep * i);
	//row borders & lines
	draw_color_rectangle(row_x,row_y,row_x+row_w,row_y+row_h,c_white,false)
	draw_color_rectangle(row_x,row_y,row_x+row_w,row_y+header_height,make_color_hsv(color_get_hue(global.colors.myriad_light_blue),180,255),false)

	draw_gui_line(row_x+row_w-join_width,row_y+header_height,row_x+row_w-join_width,row_y+row_h)
	draw_gui_line(row_x,row_y+header_height,row_x+row_w,row_y+header_height)
	draw_gui_border(row_x,row_y,row_x+row_w,row_y+row_h)
	
	//lobby name
	var lobby = lobbies[i];
	draw_set_font(fSidebar)
	draw_set_halign(fa_left)
	draw_set_valign(fa_top)
	draw_text(row_x+8,row_y+8,lobby.name)
	
	//header
	draw_set_font(fTooltip)
	draw_set_halign(fa_center)
	draw_text(row_x+w-(join_width/2),row_y+8,string("Connected players: {0}/8",array_length(lobby.players)))
	draw_set_color(c_red)
	draw_set_valign(fa_bottom)
	if lobby.open draw_set_color(c_lime)
	draw_text(row_x+w-(join_width/2),row_y+header_height-8,lobby.open? "Lobby open":"In-game")
	
	//icons
	var icon_size = row_h - header_height - 16;
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
	draw_sprite_ext(climate_sprite,0,row_x+8,row_y+header_height+8,icon_scale,icon_scale,0,c_white,1)
	draw_sprite_ext(landscape_sprite,0,row_x+8+icon_size+8,row_y+header_height+8,icon_scale,icon_scale,0,c_white,1)
	
	//settings text
	var text_x = row_x + 2*icon_size + 8 + 8 + 32;
	var text_y = row_y+header_height + 16
	draw_set_halign(fa_left)
	draw_set_valign(fa_top)
	draw_set_color(c_black)
	draw_text(text_x,text_y,"Climate type: "+lobby.settings.climate_type)
	draw_text(text_x,text_y+48,"Landscape type: "+lobby.settings.landscape_type)
	draw_text(text_x,text_y+96,"Climate change intensity: "+lobby.settings.climate_intensity)
	
	text_x += string_width("Climate change intensity: "+lobby.settings.climate_intensity) + 32
	draw_text(text_x,text_y,"Country GDP: "+lobby.settings.gdp)
	draw_text(text_x,text_y+48,"Number of rounds: "+string(lobby.settings.n_rounds))
	
	//join button
	var button_w = join_width - 48;
	var button_h = 96;
	var button_x = row_x+row_w-(join_width/2)-(button_w/2);
	var button_y = row_y+header_height+(row_h-header_height)/2-(button_h/2);
	
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
			if lobby.open {
				with objOnline { send_string(MESSAGE.JOIN_GAME, lobby.lobby_id) }
			}
		}
	} else hover = false
	if hover {
		if button_click[i] draw_set_color(c_gray)
		else draw_set_color(make_color_hsv(0,0,220))
	} else draw_set_color(c_ltgray)
	if !lobby.open draw_set_color(c_dkgray)
	
	if mouse_check_released(mb_left) {
		button_click[i] = false
	}
	
	draw_button(button_x,button_y,button_x+button_w,button_y+button_h,!button_click[i])
	draw_set_font(fSidebar)
	draw_set_halign(fa_center)
	draw_set_valign(fa_middle)
	draw_set_color(c_black)
	draw_text(button_x+(button_w/2),button_y+(button_h/2),"Join Game")
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
draw_gui_border(x+sprite_width-48,scroll_top,x+sprite_width-16,scroll_bottom)
draw_color_rectangle(x+sprite_width-48,scroll_top+scroll_amount,x+sprite_width-16,scroll_top+scroll_amount+scroll_bar_height,c_ltgray,false)

if coords_in(mouse_x,mouse_y,x+sprite_width-48,scroll_top+scroll_amount,x+sprite_width-16,scroll_top+scroll_amount+scroll_bar_height) {
	if mouse_check_pressed(mb_left) { 
		scroll_click = true	
		scroll_mouse_y = mouse_y
	}
}