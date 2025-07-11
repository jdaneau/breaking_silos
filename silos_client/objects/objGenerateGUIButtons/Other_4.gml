var buttons = [];

switch(global.state.role) {
	case ROLE.PRESIDENT:
		if !role_in_game(ROLE.ENGINEER) {
			if !role_in_game(ROLE.FLOOD) {
				array_push(buttons, btn_show_flood_risk)
			}
			if !role_in_game(ROLE.HOUSING) {
				array_push(buttons, btn_show_cyclone_risk)	
			}
			if !role_in_game(ROLE.AGRICULTURE) {
				array_push(buttons, btn_show_drought_risk)	
			}
			array_push(buttons, btn_show_watersheds)
		}
		if !role_in_game(ROLE.AGRICULTURE) and !role_in_game(ROLE.HOUSING) {
			array_push(buttons, btn_show_agricultural_areas)
		}
		array_push(buttons, btn_show_population_map, btn_finalize_decision)
	break;
	case ROLE.FINANCE:
		array_push(buttons, btn_show_population_map, btn_open_calculator)
	break;
	case ROLE.AGRICULTURE:
		array_push(buttons, btn_show_population_map, btn_show_agricultural_areas, btn_show_drought_risk)
	break;
	case ROLE.CITIZEN:
		array_push(buttons, btn_show_population_map, btn_show_drought_history, btn_show_flood_history)
	break;
	case ROLE.ENGINEER:
		array_push(buttons, btn_show_population_map, btn_show_cyclone_risk, btn_show_watersheds)	
		if !role_in_game(ROLE.FLOOD) {
			array_push(buttons, btn_show_flood_risk)
			if !role_in_game(ROLE.AGRICULTURE) {
				array_push(buttons, btn_show_drought_risk)	
			}
		}
	break;
	case ROLE.FLOOD:
		array_push(buttons, btn_show_population_map, btn_show_flood_risk, btn_show_drought_risk)
		if !role_in_game(ROLE.ENGINEER) {
			array_push(buttons, btn_show_watersheds)
		}
	break;
	case ROLE.HOUSING:
		array_push(buttons, btn_show_population_map)
		if !role_in_game(ROLE.ENGINEER) {
			array_push(buttons, btn_show_cyclone_risk)	
		}
		if !role_in_game(ROLE.AGRICULTURE) {
			array_push(buttons, btn_show_agricultural_areas)	
		}
	break;
	case ROLE.INTERNATIONAL:
		array_push(buttons, btn_show_population_map)	
		if !role_in_game(ROLE.CITIZEN) {
			array_push(buttons, btn_show_flood_history, btn_show_drought_history)
		}
	break;
}

var button_width = 75;

var n_buttons = array_length(buttons);
if n_buttons < 5 {
	var button_space = sprite_width / n_buttons;
	var button_left_padding = (button_space - button_width) / 2;
	for(var i=0; i<n_buttons; i++) {
		var btn = instance_create_depth(x+(button_space*i)+button_left_padding, y+8, depth-25, objGUIButton);
		btn.text = buttons[i].text
		btn.toggle = buttons[i].toggle
		btn.on_click = buttons[i].on_click
		btn.image_xscale = button_width / sprite_get_width(object_get_sprite(objGUIButton))
		btn.image_yscale = (sprite_height-16) / sprite_get_height(object_get_sprite(objGUIButton))
		btn.sprite = buttons[i].sprite
		btn.font = fMyriad14
	}
} else {
	var button_space = sprite_width / 2;
	var dropdown_left_padding = (button_space - (button_width * 1.5)) / 2;
	var button_left_padding = (button_space - button_width) / 2;
	var dropdown = instance_create_depth(x+dropdown_left_padding,y+8,depth-25,objDropdownButton);
	dropdown.image_xscale = (button_width * 1.5) / sprite_get_width(object_get_sprite(objGUIButton))
	dropdown.image_yscale = (sprite_height-16) / sprite_get_height(object_get_sprite(objGUIButton))
	for(var i=0; i<n_buttons; i++) {
		if !struct_equals(buttons[i],btn_finalize_decision) and !struct_equals(buttons[i],btn_open_calculator) {
			array_push(dropdown.buttons,buttons[i])	
		} else {
			var btn = instance_create_depth(x+button_space+button_left_padding, y+8, depth-25, objGUIButton);	
			btn.text = buttons[i].text
			btn.on_click = buttons[i].on_click
			btn.image_xscale = button_width / sprite_get_width(object_get_sprite(objGUIButton))
			btn.image_yscale = (sprite_height-16) / sprite_get_height(object_get_sprite(objGUIButton))
			btn.sprite = buttons[i].sprite
			btn.font = fMyriad14
		}
	}
}