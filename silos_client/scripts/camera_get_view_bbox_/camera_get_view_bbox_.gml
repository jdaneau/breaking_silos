/// @function		camera_get_view_bbox_left(camera);
/// @param			{camera}	camera
/// @requires		xtend
/// @description	Returns the width in pixels of the left bounding box (or pillarbox) of a camera,
///					if it is currently assigned to a view. This value is relative to the base width
///					defined in config, and is useful for managing non-scaled, centered content within
///					a scaled viewport. If the camera is not assigned to a view, 0 will be returned
///					instead.
///					
///					Note that this does not measure space outside the view when min/max aspect ratios
///					are employed, but rather the space inside a scaled view relative to an unscaled
///					view.
///
/// @example		draw_rectangle(0, 0, camera_get_view_bbox_left(), view_height, false);
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2021, All Rights Reserved

function camera_get_view_bbox_left(_camera) {
	// Get view camera data
	var xtend_view = camera_get_view_struct(_camera);

	// Return view camera bounding box
	if (!is_undefined(xtend_view)) {
		var cam_width = camera_get_view_width(_camera);
		
		return max(0, (cam_width - xtend_view.width_base)*0.5);
	} else {
		// Otherwise return 0 if camera is not assigned to a view
		return 0;
	}
}


/// @function		camera_get_view_bbox_right(camera);
/// @param			{camera}	camera
/// @requires		xtend
/// @description	Returns the width in pixels of the right bounding box (or pillarbox) of a camera,
///					if it is currently assigned to a view. This value is relative to the base width
///					defined in config, and is useful for managing non-scaled, centered content within
///					a scaled viewport. If the camera is not assigned to a view, 0 will be returned
///					instead.
///					
///					Note that this does not measure space outside the view when min/max aspect ratios
///					are employed, but rather the space inside a scaled view relative to an unscaled
///					view.
///
/// @example		draw_rectangle(camera_get_view_bbox_right(), 0, view_width, view_height, false);
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2021, All Rights Reserved

function camera_get_view_bbox_right(_camera) {
	// Get view camera data
	var xtend_view = camera_get_view_struct(_camera);

	// Return view camera bounding box
	if (!is_undefined(xtend_view)) {	
		var cam_width = camera_get_view_width(_camera);
		
		return min(cam_width, cam_width - ((cam_width - xtend_view.width_base)*0.5));
	} else {
		// Otherwise return 0 if camera is not assigned to a view
		return 0;
	}
}


/// @function		camera_get_view_bbox_top(camera);
/// @param			{camera}	camera
/// @requires		xtend
/// @description	Returns the height in pixels of the top bounding box (or letterbox) of a camera,
///					if it is currently assigned to a view. This value is relative to the base height
///					defined in config, and is useful for managing non-scaled, centered content within
///					a scaled viewport. If the camera is not assigned to a view, 0 will be returned
///					instead.
///					
///					Note that this does not measure space outside the view when min/max aspect ratios
///					are employed, but rather the space inside a scaled view relative to an unscaled
///					view.
///
/// @example		draw_rectangle(0, 0, view_width, camera_get_view_bbox_top(), false);
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2021, All Rights Reserved

function camera_get_view_bbox_top(_camera) {
	// Get view camera data
	var xtend_view = camera_get_view_struct(_camera);

	// Return view camera bounding box
	if (!is_undefined(xtend_view)) {
		var cam_height = camera_get_view_height(_camera);
		
		return max(0, (cam_height - xtend_view.height_base)*0.5);
	} else {
		// Otherwise return 0 if camera is not assigned to a view
		return 0;
	}
}


/// @function		camera_get_view_bbox_bottom(camera);
/// @param			{camera}	camera
/// @requires		xtend
/// @description	Returns the height in pixels of the bottom bounding box (or letterbox) of a camera,
///					if it is currently assigned to a view. This value is relative to the base height
///					defined in config, and is useful for managing non-scaled, centered content within
///					a scaled viewport. If the camera is not assigned to a view, 0 will be returned
///					instead.
///					
///					Note that this does not measure space outside the view when min/max aspect ratios
///					are employed, but rather the space inside a scaled view relative to an unscaled
///					view.
///
/// @example		draw_rectangle(0, camera_get_view_bbox_bottom(), view_width, view_height, false);
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2021, All Rights Reserved

function camera_get_view_bbox_bottom(_camera) {
	// Get view camera data
	var xtend_view = camera_get_view_struct(_camera);

	// Return view camera bounding box
	if (!is_undefined(xtend_view)) {	
		var cam_height = camera_get_view_height(_camera);
		
		return min(cam_height, cam_height - ((cam_height - xtend_view.height_base)*0.5));
	} else {
		// Otherwise return 0 if camera is not assigned to a view
		return 0;
	}
}