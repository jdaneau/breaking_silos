/// @function		camera_set_view_halign(camera, halign);
/// @param			{camera}	camera
/// @param			{constant}	halign
/// @requires		xtend
/// @description	Sets the horizontal alignment of a camera, if it is currently assigned to a
///					view. Alignment determines which side(s) of the view are expanded or cropped
///					following a resize operation. Possible values are `va_left`, `va_center`, or
///					`va_top` (`va_left` by default).
/// 
/// @example		camera_set_view_halign(view_camera[1], va_center);
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2021, All Rights Reserved

function camera_set_view_halign(_camera, _align) {
	// Get view camera data
	var xtend_view = camera_get_view_struct(_camera);
	
	// Set view camera alignment
	if (!is_undefined(xtend_view)) {
		xtend_view.halign = _align;
	}
}


/// @function		camera_set_view_valign(camera, valign);
/// @param			{camera}	camera
/// @param			{constant}	valign
/// @requires		xtend
/// @description	Sets the vertial alignment of a camera, if it is currently assigned to a 
///					view. Alignment determines which side(s) of the view are expanded or cropped
///					following a resize operation. Possible values are `va_top`, `va_middle`, or
///					`va_bottom` (`va_top` by default).
/// 
/// @example		camera_set_view_valign(view_camera[1], va_middle);
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2021, All Rights Reserved

function camera_set_view_valign(_camera, _align) {
	// Get view camera data
	var xtend_view = camera_get_view_struct(_camera);
	
	// Set view camera alignment
	if (!is_undefined(xtend_view)) {
		xtend_view.valign = _align;
	}
}