///same as create

measures = []

switch(global.state.role) {
	case ROLE.PRESIDENT:
		measures = ds_map_keys_to_array(global.measures)
	break;
	case ROLE.FINANCE:
		//nothing
	break;
	case ROLE.AGRICULTURE:
		array_push(measures, MEASURE.NORMAL_CROPS)
		array_push(measures, MEASURE.RESISTANT_CROPS)
		if !role_in_game(ROLE.FLOOD) {
			array_push(measures, MEASURE.DIKE)
			if !role_in_game(ROLE.CITIZEN) and !role_in_game(ROLE.INTERNATIONAL) {
				array_push(measures, MEASURE.NBS)	
			}
		}
	break;
	case ROLE.CITIZEN:
		array_push(measures, MEASURE.NBS)
		if !role_in_game(ROLE.FLOOD) and !role_in_game(ROLE.INTERNATIONAL){
			array_push(measures, MEASURE.EWS_FLOOD)
		}
		if !role_in_game(ROLE.INTERNATIONAL) && !role_in_game(ROLE.HOUSING) {
			array_push(measures, MEASURE.EVACUATE)	
			if !role_in_game(ROLE.ENGINEER) {
				array_push(measures, MEASURE.EWS_CYCLONE)
			}
		}
		if !role_in_game(ROLE.AGRICULTURE) {
			array_push(measures, MEASURE.NORMAL_CROPS)
			array_push(measures, MEASURE.RESISTANT_CROPS)
		}
	break;
	case ROLE.ENGINEER:
		array_push(measures, MEASURE.DAM)
		array_push(measures, MEASURE.SEAWALL)
		array_push(measures, MEASURE.CYCLONE_BUILDINGS)
		if !role_in_game(ROLE.INTERNATIONAL) {
			array_push(measures, MEASURE.EWS_CYCLONE)
			if !role_in_game(ROLE.FLOOD) and !role_in_game(ROLE.CITIZEN) {
				array_push(measures, MEASURE.EWS_FLOOD)
			}
		}
		if !role_in_game(ROLE.FLOOD) {
			array_push(measures, MEASURE.DIKE)
			if !role_in_game(ROLE.HOUSING) {
				array_push(measures, MEASURE.FLOOD_BUILDINGS)
			}
		}
		if !role_in_game(ROLE.HOUSING) {
			array_push(measures, MEASURE.BUILDINGS)
			array_push(measures, MEASURE.RELOCATION)	
		}
	break;
	case ROLE.FLOOD:
		array_push(measures, MEASURE.EWS_FLOOD)
		array_push(measures, MEASURE.DIKE)
		array_push(measures, MEASURE.FLOOD_BUILDINGS)
		if !role_in_game(ROLE.ENGINEER) {
			array_push(measures, MEASURE.DAM)
			array_push(measures, MEASURE.SEAWALL)
		}
		if !role_in_game(ROLE.CITIZEN)  {
			if !role_in_game(ROLE.INTERNATIONAL) {
				array_push(measures, MEASURE.NBS)	
			}
			if !role_in_game(ROLE.AGRICULTURE) {
				array_push(measures, MEASURE.NORMAL_CROPS)
				array_push(measures, MEASURE.RESISTANT_CROPS)
			}
		}
	break;
	case ROLE.HOUSING:
		array_push(measures, MEASURE.BUILDINGS)
		array_push(measures, MEASURE.RELOCATION)
		array_push(measures, MEASURE.FLOOD_BUILDINGS)
		array_push(measures, MEASURE.CYCLONE_BUILDINGS)
		if !role_in_game(ROLE.INTERNATIONAL) {
			array_push(measures, MEASURE.HOSPITAL)
			array_push(measures, MEASURE.AIRPORT)
			array_push(measures, MEASURE.EVACUATE)
		}
	break;
	case ROLE.INTERNATIONAL:
		array_push(measures, MEASURE.HOSPITAL)
		array_push(measures, MEASURE.AIRPORT)
		array_push(measures, MEASURE.EWS_CYCLONE)
		array_push(measures, MEASURE.EVACUATE)
		if !role_in_game(ROLE.CITIZEN) {
			array_push(measures, MEASURE.NBS)
		}
		if !role_in_game(ROLE.FLOOD) {
			array_push(measures, MEASURE.EWS_FLOOD)	
		}
		if !role_in_game(ROLE.HOUSING) {
			if !role_in_game(ROLE.ENGINEER) {
				array_push(measures, MEASURE.BUILDINGS)	
				array_push(measures, MEASURE.RELOCATION)	
				array_push(measures, MEASURE.BUILDINGS)
				array_push(measures, MEASURE.CYCLONE_BUILDINGS)
			}
			if !role_in_game(ROLE.FLOOD) {
				array_push(measures, MEASURE.FLOOD_BUILDINGS)
			}
		}
	break;
}

icons = []
y = ystart