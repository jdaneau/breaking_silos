var icon_size = sprite_height;
var icon_scale = (icon_size / sprite_get_width(icon)) * 1.2;
var circle_scale = icon_size / sprite_get_width(sprRoleCircle);
draw_sprite_ext(sprRoleCircle,0,x+4,y,circle_scale,circle_scale,0,c_white,1)
draw_sprite_ext(icon,0,x+4+(icon_size * 0.8),y+(icon_size * 0.8),icon_scale,icon_scale,0,c_white,1)

draw_set_font(fMyriad14)
draw_set_halign(fa_left)
var player_caption = "Player: " + objOnline.get_role_player(role);
var max_caption_size = string_width("CITIZEN REPRESENTATIVE"); //longest title
while string_width(player_caption) > max_caption_size {
	player_caption = string_copy(player_caption,1,string_length(player_caption)-1)
}
if !string_ends_with(player_caption,objOnline.get_role_player(role)) {
	player_caption = string_copy(player_caption,1,string_length(player_caption)-3) + "..."	
}

draw_set_color(global.colors.yellow)
if string_width(global.roles[? role].name) > (sprite_width * 0.5) {
	draw_set_font(fMyriad12)
}
draw_text(x+icon_size+8, y+32, string_upper(global.roles[? role].name))

draw_set_font(fMyriad12)
draw_set_color(c_white)
draw_text(x+icon_size+8, y+32+24, string_upper(global.roles[? role].description))

draw_set_font(fMyriadBold12)
draw_text(x+icon_size+8, y+32+48, player_caption)

//draw button
if role != global.state.role and objOnline.get_role_player(role) != "" { exit } // dont draw button if another player has the role
var button_width = icon_size;
var button_height = sprite_height/3;
var button_x = x + sprite_width - button_width - 16;
var button_y = y+8+16; //same as role description height
var button_color = global.colors.light_green;
var hover = coords_in(mouse_x,mouse_y,button_x,button_y,button_x+button_width,button_y+button_height);
if hover { button_color = global.colors.light_green_50 }
var button_text = "Join";
if role == global.state.role { 
	if hover button_color = global.colors.magenta_50
	else button_color = global.colors.magenta
	button_text = "Leave" 
}
draw_gui_border(button_x,button_y,button_x+button_width,button_y+button_height,button_color,true)
draw_set_halign(fa_center)
draw_set_valign(fa_middle)
draw_set_font(fMyriadBold14)
draw_text(button_x+(button_width/2),button_y+(button_height/2),button_text)
if hover and mouse_check_pressed(mb_left) {
	if role != global.state.role {
		send_string(MESSAGE.JOIN_ROLE,global.roles[? role].name)	
	}
	else {
		send(MESSAGE.LEAVE_ROLE)
	}
}

//draw border around role if selected
if role == global.state.role {
	draw_gui_border(x,y,x+sprite_width,y+sprite_height)	
}