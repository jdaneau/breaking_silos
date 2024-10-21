var buttons = [];

switch(global.state.role) {
	case ROLE.PRESIDENT:
		 array_push(buttons, btn_show_population_map, btn_end_discussion)
	break;
	case ROLE.FINANCE:
		array_push(buttons, btn_open_calculator)
	break;
	case ROLE.AGRICULTURE:
		array_push(buttons, btn_show_population_map, btn_show_agricultural_areas, btn_show_drought_hazard)
	break;
	case ROLE.CITIZEN:
		array_push(buttons, btn_show_drought_history, btn_show_flood_history)
	break;
	case ROLE.ENGINEER:
		array_push(buttons, btn_show_flood_hazard, btn_show_cyclone_hazard, btn_show_watersheds)	
	break;
	case ROLE.FLOOD:
		array_push(buttons, btn_show_flood_hazard, btn_show_drought_hazard)
	break;
	case ROLE.HOUSING:
		array_push(buttons, btn_show_population_map)
	break;
	case ROLE.INTERNATIONAL:
		//no buttons
	break;
}

var n_buttons = array_length(buttons);
var button_width = (sprite_width/n_buttons) - 16;
if button_width > (sprite_width/3) { button_width = sprite_width/3 }
for(var i=0; i<n_buttons; i++) {
	var btn = instance_create_depth(x+(button_width*i)+(16*i), y, 0, objGUIButton);
	btn.text = buttons[i].text
	btn.toggle = buttons[i].toggle
	btn.on_click = buttons[i].on_click
	btn.image_xscale = button_width / sprite_get_width(object_get_sprite(objGUIButton))
	btn.image_yscale = sprite_height / sprite_get_height(object_get_sprite(objGUIButton))
}