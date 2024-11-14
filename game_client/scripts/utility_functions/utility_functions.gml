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

function round_nearest(val,factor) {
	return round(val / factor) * factor;
}

/// @function copy_stuct(struct)
/// @description returns a copy of the provided struct 
function copy_stuct(struct){
	var copy = {};
	var keys = variable_struct_get_names(struct);
	for (var i=0; i<array_length(keys); i++) {
		var key = keys[i];
		var value = variable_struct_get(struct, key);
		variable_struct_set(copy, key, value)
	}
	return copy;
}

/// @function struct_equals(struct1, struct2)
/// @description returns true if the two provided structs have the same data
function struct_equals(struct1, struct2) {
	var keys1 = variable_struct_get_names(struct1);
	var keys2 = variable_struct_get_names(struct2);
	if !array_equals(keys1,keys2) return false
	 
	for (var i=0; i<array_length(keys1); i++) {
		var value1 = variable_struct_get(struct1, keys1[i]);
		var value2 = variable_struct_get(struct2, keys1[i]);
        if value1 != value2 { return false }
	}
	return true
}

/// @function euclidean_distance(x1,y1,x2,y2)
/// @description calculates the euclidean distance between two points (x1,y1) and (x2,y2)
function euclidean_distance(x1,y1,x2,y2) {
	return sqrt( sqr(x2-x1) + sqr(y2-y1) )
}

/// @function string_chunk(str, chunk_size)
/// @description breaks a string up into chunks of size chunk_size, and returns an array of strings
function string_chunk(str, chunk_size) {
	var index = 1;
	var length = string_length(str);
	var chunks = [];
	while(index <= length) {
		var count = min(chunk_size, length-index+1);
		var chunk = string_copy(str,index,count);
		array_push(chunks,chunk)
		index += chunk_size
	}
	return chunks
}

/// @function create(_x, _y, obj)
/// @description shorthand for instance_create_depth
function create(_x, _y, _obj, _depth=0) {
	instance_create_depth(_x, _y, _depth, _obj)	
}

//mouse functions (with layers)
function mouse_check(button) {
	if mouse_check_button(button) {
		if depth <= global.mouse_depth return true	
	} 
	return false
}
function mouse_check_pressed(button) {
	if mouse_check_button_pressed(button) {
		if depth <= global.mouse_depth return true	
	} 
	return false
}
function mouse_check_released(button) {
	if mouse_check_button_released(button) {
		if depth <= global.mouse_depth return true	
	} 
	return false
}

function get_role_id(role_name) {
	var roles = ds_map_keys_to_array(global.roles);
	for(var i=0; i<array_length(roles); i++) {
		if global.roles[? roles[i]].name == role_name {
			return roles[i]	
		}
	}
	return ROLE.NONE
}