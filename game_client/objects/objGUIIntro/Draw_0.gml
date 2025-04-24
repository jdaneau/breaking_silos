draw_set_alpha(0.85)
draw_color_rectangle(0,0,1600,900,global.colors.dark_blue,false)
draw_set_alpha(1)

draw_sprite(sprIntroPopup, 0, popup_x, popup_y)

var qualifier;
var opening_line;
if global.state.disaster_intensity == "low" qualifier = "minor"
else if global.state.disaster_intensity == "medium" qualifier = "major"
else if global.state.disaster_intensity == "high" qualifier = "massive"
switch(global.state.disaster) {
	case "flood":
		opening_line = string("A {0} flood is about to happen in our country. We need to implement Disaster Risk Reduction (DRR) measures to mitigate the impact of this event.",qualifier);
	break;
	case "drought":
		opening_line = string("A {0} drought is happening in our country. We need to implement Disaster Risk Reduction (DRR) measures to mitigate the impact of this event.",qualifier);
	break;
	case "cyclone":
		opening_line = string("A {0} tropical cyclone is about to pass through our country. We need to implement Disaster Risk Reduction (DRR) measures to mitigate the impact of this event.",qualifier);
	break;
}

var extra_text = "On the map you will see what cells are affected, as well as what buildings will be damaged (see legend). Use this to plan ahead and implement the best measures.";

var role_name = global.roles[? global.state.role].name;

var role_specific_text;
var icon;
switch(global.state.role) {
	case ROLE.PRESIDENT:
		icon = sprPresident
		role_specific_text = "As the President, you need to lead the discussion with your representatives in order to decide which measures to implement. Your associates' suggested implementations will show up on the map.\n\nThe finance minister should report the cost of your planned measures. If there is no finance minister, the budget will automatically update for you.\n\nYou are mainly in charge of selecting measures and placing them on the map before the time limit is over. Good luck!"
	break;
	case ROLE.FINANCE:
		icon = sprFinanceMinister
		role_specific_text = "As the Finance Minister, your job is to take account of all proposed measures and report the cost to the President.\n\nUse the \"Open Calculator\" button to calculate proposed costs!"
	break;
	case ROLE.AGRICULTURE:
		icon = sprAgriculturalRep
		role_specific_text = "As the Agricultural Representative, you need to inform the President on the will and the needs of the farmers with regards to the current disaster and future disasters.\n\nAdd markers to the map to show where you think certain agricultural measures should be implemented!"
	break;
	case ROLE.CITIZEN:
		icon = sprCitizenRep
		role_specific_text = "As the Representative of Citizens, you act on behalf of the locals to inform the president of indigenous flood/drought knowledge.\n\nYou should be critical of ideas that may disrupt the lifestyle of the local communities.\n\nAdd markers to the map to show where you think certain measures should be implemented!"
	break;
	case ROLE.ENGINEER:
		icon = sprEngineer
		role_specific_text = "As the Engineer, your job is to inform the President of the hazard data from your models, in order to best determine which measures to take.\n\nAdd markers to the map to show where you think certain engineering projects should be implemented!"
	break;
	case ROLE.FLOOD:
		icon = sprFloodCoordinator
		role_specific_text = "As the National Flood Agency Coordinator, your job is to inform the President about national flood risk and work towards preventing future harmful flooding events.\n\nAdd markers to the map to show where you think certain flood-resistant measures should be implemented!"
	break;
	case ROLE.HOUSING:
		icon = sprHousingMinister
		role_specific_text = "As the National Housing and Urban Development Agency Chief, you want to make sure that any damaged houses are quickly and efficiently rebuilt in the aftermath of the event.\n\nAdd markers to the map to indicate important spots for rebuilding or relocation projects!"
	break;
	case ROLE.INTERNATIONAL:
		icon = sprInternationalRep
		role_specific_text = "As the Representative of International Aid and Emergency Responder, your job is to ensure mitigation of the population harm and infrastructural damage caused by the disaster.\n\nYou should push to meet the goal of reconstructing all hospitals and airports, replanting all crops, and providing aid to impacted population. This ensures a bonus of 5000 coins in the next round from international donors!\n\nAdd markers to the map to indicate where you think certain measures should be implemented."
		if global.state.disaster == "drought" and global.state.disaster_intensity == "low" {
			role_specific_text += "\n\nNOTE: As we are currently facing a low-intensity drought, evacuation will not be necessary to secure international aid."
		}
	break;
}

var ending_text = "(For more information, hover over the [?] icon next to your character.)";

draw_set_font(fFranklinBold14)
draw_set_color(global.colors.light_blue)
draw_set_halign(fa_center)
draw_set_valign(fa_top)

draw_text_ext(mid_x, popup_y+32, opening_line, 22, popup_size - 72)
var opening_line_height = string_height_ext(opening_line,22,popup_size-72);

draw_set_font(fMyriad12)
draw_set_color(c_black)

draw_text_ext(mid_x, popup_y+32+opening_line_height+32, role_specific_text, 18, popup_size - 72)
var role_text_height = string_height_ext(role_specific_text, 18, popup_size - 72)

draw_text_ext(mid_x, popup_y+32+opening_line_height+32+role_text_height+24, ending_text, 18,  popup_size - 72)

draw_set_color(c_white)

var icon_size = 80;
var icon_scale = (icon_size / sprite_get_width(icon)) * 0.65;
var circle_scale = icon_size / sprite_get_width(sprRoleCircle);
draw_sprite_ext(sprRoleCircle,0,mid_x-(icon_size/2),popup_bottom-(icon_size/2),circle_scale,circle_scale,0,c_white,1)
draw_sprite_ext(icon,0,mid_x,popup_bottom,icon_scale,icon_scale,0,c_white,1)