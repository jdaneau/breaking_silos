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
	}
	return _spr
}