info_spr = noone
scale=1

switch global.state.role {
	case ROLE.PRESIDENT:
		info_spr = sprRole_president
	break;
	case ROLE.FINANCE:
		info_spr = sprRole_finance
	break;
	case ROLE.AGRICULTURE:
		info_spr = sprRole_agriculture
	break;
	case ROLE.CITIZEN:
		info_spr = sprRole_citizen
	break;
	case ROLE.ENGINEER:
		info_spr = sprRole_engineer
	break;
	case ROLE.FLOOD:
		info_spr = sprRole_flood
	break;
	case ROLE.HOUSING:
		info_spr = sprRole_housing
	break;
	case ROLE.INTERNATIONAL:
		info_spr = sprRole_international
	break;
}

w=0
h=0
mouse_on = false