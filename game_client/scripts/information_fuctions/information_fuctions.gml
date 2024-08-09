/// @function get_total_population(format)
/// @description Returns the total population of all tiles in the global map
/// @param {string} format Format to return the population in. "raw":integer number, "thousands":divide total by 1000, "millions":divide total by 1 million
function get_total_population(_format="raw") {
	var _pop = 0;
	for(i=0; i<array_length(global.map.land_tiles); i++) {
		var _tile = global.map.land_tiles[i];	
		_pop += _tile.metrics.population
	}
	if _format == "raw"
		return _pop * 1000
	else if _format == "thousands"
		return _pop
	else if _format == "millions"
		return _pop / 1000
}