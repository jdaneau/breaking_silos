/// @function array_init_2d(rows, cols, [default_value])
/// @description Initializes a 2-dimensional array with the specified number of rows and columns
function array_init_2d(_rows,_cols,_default_value=0) {
	var array;
	for(var i=0; i<_rows; i++) {
		for(var j=0; j<_cols; j++) {
			array[i,j] = _default_value
		}
	}
	return array
}

/// @function coords_in(x, y, bound_x1, bound_y1, bound_x2, bound_y2)
/// @description Checks if a given x,y coordinate pair is inside of a bounded region
function coords_in(_x, _y, _x1, _y1, _x2, _y2){
	return (_x >= _x1 and _x <= _x2 and _y >= _y1 and _y <= _y2 )
}