/// @function		camera_get_view_xscale(camera);
/// @param			{camera}	camera
/// @requires		xtend
/// @description	Returns the horizontal scale multipler of a view camera scaled with 
///					`camera_set_view_scale`.
///					
///					If the input view has not been scaled, it will return a value of 1.
///					If the input view does not exist, it will return 0 instead.
///
/// @example		image_xscale = camera_get_view_xscale(view_camera[1]);
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2021, All Rights Reserved

function camera_get_view_xscale(_camera) {
	// Identify view from camera
	var _view = camera_get_view(_camera);
	
	// Return view scale, if found
	if (_view != -1) {
		if (_camera == view_camera[xtend.scale.view]) {
			// Return master view scale
			return view_xscale;
		} else {
			if (variable_struct_exists(xtend, "view" + string(_view))) {
				// Get view camera data
				var xtend_view = variable_struct_get(xtend, "view" + string(_view));
				
				// Return view camera scale
				return (camera_get_view_width(view_camera[_view])/xtend_view.width_base);
			} else {
				// Return 1 if view is not scaled
				return 1;
			}
		}
	} else {
		// Return 0 if view does not exist
		return 0;
	}
}


/// @function		camera_get_view_yscale(camera);
/// @param			{camera}	camera
/// @requires		xtend
/// @description	Returns the verical scale multipler of a view camera scaled with 
///					`camera_set_view_scale`.
///					
///					If the input view has not been scaled, it will return a value of 1.
///					If the input view does not exist, it will return 0 instead.
///
/// @example		image_yscale = camera_get_view_yscale(view_camera[1]);
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2021, All Rights Reserved

function camera_get_view_yscale(_camera) {
	// Identify view from camera
	var _view = camera_get_view(_camera);
	
	// Return view scale, if found
	if (_view != -1) {
		if (_camera == view_camera[xtend.scale.view]) {
			// Return master view scale
			return view_yscale;
		} else {
			if (variable_struct_exists(xtend, "view" + string(_view))) {
				// Get view camera data
				var xtend_view = variable_struct_get(xtend, "view" + string(_view));
				
				// Return view camera scale
				return (camera_get_view_height(view_camera[_view])/xtend_view.height_base);
			} else {
				// Return 1 if view is not scaled
				return 1;
			}
		}
	} else {
		// Return 0 if view does not exist
		return 0;
	}
}