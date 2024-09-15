function get_next_disaster(){
	return {
		disaster : choose("flood","drought","cyclone"),
		intensity : choose("low","medium","high"),
		days_since_last_disaster : choose(7,30,365) * irandom_range(2,4)
	}
}

//todo: make this more realistic (i.e. based on the map and current climate scenario)