measures = []

switch(global.state.role) {
	case ROLE.PRESIDENT:
		//nothing
	break;
	case ROLE.FINANCE:
		//also nothing
	break;
	case ROLE.AGRICULTURE:
		array_push(measures, MEASURE.NORMAL_CROPS)
		array_push(measures, MEASURE.RESISTANT_CROPS)
	break;
	case ROLE.CITIZEN:
		array_push(measures, MEASURE.NBS)
	break;
	case ROLE.ENGINEER:
		array_push(measures, MEASURE.DAM)
		array_push(measures, MEASURE.SEAWALL)
	break;
	case ROLE.FLOOD:
		array_push(measures, MEASURE.EWS_FLOOD)
		array_push(measures, MEASURE.DIKE)
	break;
	case ROLE.HOUSING:
		array_push(measures, MEASURE.BUILDINGS)
		array_push(measures, MEASURE.RELOCATION)
	break;
	case ROLE.INTERNATIONAL:
		array_push(measures, MEASURE.HOSPITAL)
		array_push(measures, MEASURE.AIRPORT)
		array_push(measures, MEASURE.EWS_CYCLONE)
		array_push(measures, MEASURE.EVACUATE)
	break;
}

icons = []