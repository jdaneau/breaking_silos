var role_player = objOnline.get_role_player(role);
var icon_size = sprite_height * (3/4);

var button_width = icon_size * (3/4);
var button_height = sprite_height/4;
var button_xscale = button_width / sprite_get_width(sprGUIElement);
var button_yscale = button_height / sprite_get_height(sprGUIElement);

if role_player == "" {
	if my_button != noone and my_button.text != "JOIN" {
		with my_button instance_destroy()
		my_button = noone
	}
	if my_button == noone {
		my_button = instance_create_depth(x+icon_size+64,y+icon_size,depth-1,objGUIButton)
		my_button.font = fTooltip
		my_button.image_xscale = button_xscale
		my_button.image_yscale = button_yscale
		my_button.text = "JOIN"
		my_button.on_click = function(on) {
			send_string(MESSAGE.JOIN_ROLE,global.roles[? role].name)	
		}
	}
}
else if role_player == global.state.player_name {
	if my_button != noone and my_button.text != "LEAVE" {
		with my_button instance_destroy()
		my_button = noone
	}
	if my_button == noone {
		my_button = instance_create_depth(x+icon_size+64,y+icon_size,depth-1,objGUIButton)
		my_button.font = fTooltip
		my_button.image_xscale = button_xscale
		my_button.image_yscale = button_yscale
		my_button.text = "LEAVE"
		my_button.on_click = function(on) {
			send(MESSAGE.LEAVE_ROLE)	
		}
	}
}
else if my_button != noone {
	with my_button instance_destroy()
	my_button = noone
}