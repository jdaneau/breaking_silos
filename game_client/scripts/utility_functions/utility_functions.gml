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

/// @function capitalize(str)
/// @description capitalizes the first character in a string
function capitalize(_str) {
	if string_length(_str) > 1 {
		return string_upper(string_copy(_str,1,1)) + string_copy(_str,2,string_length(_str)-1)
	}
	else return string_upper(_str)
}

/// @function array_index(array,val)
/// @description returns the index of the first found instance of value 'val' the array, or -1 if none are found
function array_index(_array,_val) {
	for(var _i=0; _i<array_length(_array); _i++) {
		if _array[_i] == _val { return _i }	
	}
	return -1
}

/// @function copy_stuct(struct)
/// @description returns a copy of the provided struct 
function copy_stuct(struct){
    var key, value;
    var newCopy = {};
    var keys = variable_struct_get_names(struct);
    for (var i = array_length(keys)-1; i >= 0; --i) {
            key = keys[i];
            value = variable_struct_get(struct, key);
            variable_struct_set(newCopy, key, value)
    }
    return newCopy;
}

/// @function euclidean_distance(x1,y1,x2,y2)
/// @description calculates the euclidean distance between two points (x1,y1) and (x2,y2)
function euclidean_distance(x1,y1,x2,y2) {
	return sqrt( sqr(x2-x1) + sqr(y2-y1) )
}

/// @function create(_x, _y, obj)
/// @description shorthand for instance_create_depth
function create(_x, _y, _obj, _depth=0) {
	instance_create_depth(_x, _y, _depth, _obj)	
}