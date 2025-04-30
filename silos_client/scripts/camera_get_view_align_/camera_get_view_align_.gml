/// @function		camera_get_view_halign(camera);
/// @param			{camera}	camera
/// @requires		xtend
/// @description	Returns the horizontal alignment of the input camera, if it is currently
///					assigned to a view. Possible values are `va_left`, `va_center`, `va_top`.
///					If the camera is not assigned to a view, `va_left` will be returned.
/// 
/// @example		var halign = camera_get_view_halign(view_camera[1]);
///
///					draw_set_halign(halign);
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2021, All Rights Reserved

function camera_get_view_halign(_camera) {
	// Get view camera data
	var xtend_view = camera_get_view_struct(_camera);
	
	// Return view camera alignment
	if (!is_undefined(xtend_view)) {
		return xtend_view.halign;
	} else {
		// Otherwise return default if view is not scaled
		return va_left;
	}
}


/// @function		camera_get_view_valign(camera);
/// @param			{camera}	camera
/// @requires		xtend
/// @description	Returns the vertical alignment of the input camera, if it is currently
///					assigned to a view. Possible values are `va_top`, `va_middle`, or 
///					`va_bottom`. If the camera is not assigned to a view, `va_top` will be
///					returned.
/// 
/// @example		var valign = camera_get_view_valign(view_camera[1]);
///
///					draw_set_valign(valign);
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2021, All Rights Reserved

function camera_get_view_valign(_camera) {
	// Get view camera data
	var xtend_view = camera_get_view_struct(_camera);
	
	// Return view camera alignment
	if (!is_undefined(xtend_view)) {
		return xtend_view.valign;
	} else {
		// Otherwise return default if view is not scaled
		return va_top;
	}
}