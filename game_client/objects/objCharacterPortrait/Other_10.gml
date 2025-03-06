///same as room start

switch(global.state.role) {
	case ROLE.PRESIDENT:
		sprite_index = sprPresident
	break;
	case ROLE.FINANCE:
		sprite_index = sprFinanceMinister
	break;
	case ROLE.ENGINEER:
		sprite_index = sprEngineer
	break;
	case ROLE.FLOOD:
		sprite_index = sprFloodCoordinator
	break;
	case ROLE.AGRICULTURE:
		sprite_index = sprAgriculturalRep
	break;
	case ROLE.CITIZEN:
		sprite_index = sprCitizenRep
	break;
	case ROLE.HOUSING:
		sprite_index = sprHousingMinister
	break;
	case ROLE.INTERNATIONAL:
		sprite_index = sprInternationalRep
	break;
}