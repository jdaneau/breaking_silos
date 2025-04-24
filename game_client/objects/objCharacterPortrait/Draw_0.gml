draw_set_color(global.colors.light_blue)
draw_rectangle(x+(sprite_width/2),y+(sprite_height/4),x+(sprite_width*3.5),y+(sprite_height*3/4),false)
draw_circle(x+(sprite_width*3.5),y+(sprite_height/2)-1,sprite_height/4+1,false)

draw_set_color(c_white)
draw_set_font(fMyriad10)
draw_set_halign(fa_left)
draw_set_valign(fa_top)
draw_text(x+sprite_width+8,y+(sprite_height/4)+8,"YOUR ROLE:")
draw_set_font(fMyriadBold12)
draw_text(x+sprite_width+8,y+(sprite_height/4)+8+16,global.roles[? global.state.role].name)

draw_self()

var icon;
switch(global.state.role) {
	case ROLE.AGRICULTURE:
		icon = sprAgriculturalRep
	break;
	case ROLE.CITIZEN:
		icon = sprCitizenRep
	break;
	case ROLE.ENGINEER:
		icon = sprEngineer
	break;
	case ROLE.FINANCE:
		icon = sprFinanceMinister
	break;
	case ROLE.FLOOD:
		icon = sprFloodCoordinator
	break;
	case ROLE.HOUSING:
		icon = sprHousingMinister
	break;
	case ROLE.INTERNATIONAL:
		icon = sprInternationalRep
	break;
	case ROLE.PRESIDENT:
		icon = sprPresident
	break;
}
if default_mode { icon = sprCharacterPortraitDefault }

var icon_size = sprite_height;
var icon_scale = (icon_size / sprite_get_width(icon)) * 0.65;
draw_sprite_ext(icon,0,x+(icon_size/2),y+(icon_size/2),icon_scale,icon_scale,0,c_white,1)