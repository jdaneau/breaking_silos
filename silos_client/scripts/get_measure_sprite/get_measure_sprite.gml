function get_measure_sprite(measure){
	var _spr = noone;
	switch(measure) {
		case MEASURE.HOSPITAL:
			_spr = sprMeasure_hospital
		break;
		case MEASURE.AIRPORT:
			_spr = sprMeasure_airport
		break;
		case MEASURE.BUILDINGS:
			_spr = sprMeasure_buildings
		break;
		case MEASURE.SEAWALL:
			_spr = sprMeasure_seawall
		break;
		case MEASURE.NBS:
			_spr = sprMeasure_nbs
		break;
		case MEASURE.NORMAL_CROPS:
			_spr = sprMeasure_normalcrops
		break;
		case MEASURE.RESISTANT_CROPS:
			_spr = sprMeasure_resistantcrops
		break;
		case MEASURE.EWS_FLOOD:
			_spr = sprMeasure_ews_flood
		break;
		case MEASURE.EWS_CYCLONE:
			_spr = sprMeasure_ews_cyclone
		break;
		case MEASURE.DIKE:
			_spr = sprMeasure_dike
		break;
		case MEASURE.RELOCATION:
			_spr = sprMeasure_relocation
		break;
		case MEASURE.DAM:
			_spr = sprMeasure_dam
		break;
		case MEASURE.EVACUATE:
			_spr = sprMeasure_evacuate
		break;
		case MEASURE.FLOOD_BUILDINGS:
			_spr = sprMeasure_floodbuildings
		break;
		case MEASURE.CYCLONE_BUILDINGS:
			_spr = sprMeasure_cyclonebuildings
		break;
	}
	return _spr
}

function get_measure_sprite_index(measure) {
	var _idx = 0;
	switch(measure) {
		case MEASURE.AIRPORT:
			_idx = 0
		break;
		case MEASURE.BUILDINGS:
			_idx = 1
		break;
		case MEASURE.CYCLONE_BUILDINGS:
			_idx = 2
		break;
		case MEASURE.DAM:
			_idx = 3
		break;
		case MEASURE.DIKE:
			_idx = 4
		break;
		case MEASURE.EVACUATE:
			_idx = 5
		break;
		case MEASURE.EWS_CYCLONE:
			_idx = 6
		break;
		case MEASURE.EWS_FLOOD:
			_idx = 7
		break;
		case MEASURE.FLOOD_BUILDINGS:
			_idx = 8
		break;
		case MEASURE.HOSPITAL:
			_idx = 9
		break;
		case MEASURE.NBS:
			_idx = 10
		break;
		case MEASURE.NORMAL_CROPS:
			_idx = 11
		break;
		case MEASURE.RELOCATION:
			_idx = 12
		break;
		case MEASURE.RESISTANT_CROPS:
			_idx = 13
		break;
		case MEASURE.SEAWALL:
			_idx = 14
		break;
	}
	return _idx
}