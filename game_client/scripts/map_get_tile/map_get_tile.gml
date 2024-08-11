/// @desc Function Description
/// @param {any} _x Description
/// @param {any} _y Description
function map_get_tile(_x,_y){
	var n = array_length(global.map.land_tiles);
	for(var i=0; i<n; i++) {
		var _tile = global.map.land_tiles[i];
		var _tx = _tile.x div 64;
		var _ty = _tile.y div 64;
		if _tx == _x and _ty == _y {
			return _tile
		}
	}
	return noone
}