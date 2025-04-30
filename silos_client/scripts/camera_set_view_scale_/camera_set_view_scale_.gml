/// @function		camera_set_view_scale(camera, mode, xport, yport, wport, hport, [force]);
/// @param			{camera}	camera
/// @param			{int|macro}	mode
/// @param			{real}		xport
/// @param			{real}		yport
/// @param			{real}		wport
/// @param			{real}		hport
/// @param			{boolean}	[force]
/// @requires		round_to, xtend
/// @description	While the master view defined in config will always fill the entire window,
///					additional views can be created for splitscreen display within the master
///					view. This script applies the same scaling behaviors to splitscreen views
///					as are applied to the master view.
///
///					GameMaker currently provides 8 built-in view cameras, numbered 0-7, although
///					custom cameras can be assigned to the view as well. To use a built-in camera,
///					input `camera` as `view_camera[#]`. `view_visible[#]` must be `true` for the
///					viewport to be displayed.
///
///					Note that if the master view is input in this script, it will be ignored.
///
///					It is recommended to use the built-in `view_width` and `view_height` macros
///					to position and size the viewport relative to the master view. If this script
///					is run in a Step event, inner views will respond to changes in window size
///					with correct scaling. For other events, enabling the optional `[force]`
///					argument will trigger scaling immediately.
///
///					By default, base width/height will be determined by the size of the camera
///					when this script is first run. This can be set with `camera_set_view_size` or
///					by defining `width_base` and `height_base` within a `view#` section in config.
///
/// @example		camera_set_view_scale(view_camera[1], axis_x, 0, 0, view_width*0.5, view_height);
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2021, All Rights Reserved

function camera_set_view_scale(_camera, _mode, _port_x, _port_y, _port_width, _port_height) {
	
	/*
	INITIALIZATION
	*/
	
	// Force scaling, if enabled
	var force = false;
	if (argument_count > 6) {
		force = argument[6];
	}
	
	// Identify view from camera
	var _view = camera_get_view(_camera);

	// Skip if input camera is not assigned to a view, or is assigned to the master view
	if (_view == -1) or (_view == xtend.scale.view) {
		exit;
	}
		
	// Initialize scaling for view camera
	if (!variable_struct_exists(xtend, "view" + string(_view))) {
		force = true;
	}
	
	// Get current view camera dimensions
	var cam_width = camera_get_view_width(_camera);
	var cam_height = camera_get_view_height(_camera);
		
	// Get view camera data
	var xtend_view = camera_get_view_struct(_camera);
	
	// If view camera is destroyed, recreate it (this should not happen!)
	if (is_undefined(xtend_view)) {
		show_debug_message(
			"WARNING: View camera view_camera[" + string(_view) + "] doesn't exist! " +
			"Creating from defaults..."
		);
		
		// Create new view camera
		view_camera[_view] = camera_create_view(0, 0, xtend.win.width_base, xtend.win.width_base);
			
		// Get view camera data
		xtend_view = camera_get_view_struct(view_camera[_view]);
		
		// Refresh view scale
		force = true;
	}
		
	// Check for manual changes in view camera dimensions
	if (!xtend.win.resized) {
		if (cam_width != xtend_view.width_previous)
		or (cam_height != xtend_view.height_previous) {
			// Update base view dimensions
			xtend_view.width_base = cam_width;
			xtend_view.height_base = cam_height;
				
			// Refresh view scale
			force = true;
		}
	}
		
	// Update viewport properties
	view_xport[_view] = _port_x;
	view_yport[_view] = _port_y;
	
	
	/*
	SCALING
	*/
		
	// If window properties have changed...
	if (xtend.win.resized) or (force) {
		// If scaling is enabled...
		if (xtend.scale.enabled) {
			// Round port dimensions to preserve square pixels
			_port_width = round_to(_port_width, 2);
			_port_height = round_to(_port_height, 2);
			view_wport[_view] = _port_width;
			view_hport[_view] = _port_height;
		
			// Scale viewport according to the configured mode
			switch (_mode) {
				// Aspect ratio scaling
				case aspect: 
					// Get base aspect ratio
					var view_ratio_base = (xtend_view.width_base/xtend_view.height_base);
		
					// Get current aspect ratio
					var view_ratio = (_port_width/_port_height);
		
					// Scale to aspect ratio while preserving base resolution
					if (view_ratio > view_ratio_base) {
						_port_height = xtend_view.height_base;
						_port_width = round_to(_port_height*view_ratio, 2);
					} else {
						_port_width = xtend_view.width_base;
						_port_height = round_to(_port_width/view_ratio, 2);
					}
				break;
			
				// X axis scaling
				case axis_x:
					// Get current aspect ratio
					var view_ratio = (_port_width/_port_height);
				
					// Scale width to aspect ratio while preserving height
					_port_height = xtend_view.height_base;
					_port_width = round_to(_port_height*view_ratio, 2);
				break;
			
				// Y axis scaling
				case axis_y:
					// Get current aspect ratio
					var view_ratio = (_port_width/_port_height);
				
					// Scale height to aspect ratio while preserving width
					_port_width = xtend_view.width_base;
					_port_height = round_to(_port_width/view_ratio, 2);
				break;
			
				// Pixel scaling
				case pixel:
					// Get nearest integer to scale
					var view_int = min(
						round(_port_width/xtend_view.width_base), 
						round(_port_height/xtend_view.height_base)
					);
					
					// Disallow invalid scale
					if (view_int == 0) {
						view_int = 1;
					}
				
					// Scale to aspect while preserving pixel ratio
					_port_width /= view_int;
					_port_height /= view_int;
				break;
			}
		
			// Set new viewport dimensions
			camera_set_view_size(_camera, _port_width, _port_height);
			
			
			/*
			ALIGNMENT
			*/
			
			// Align viewport
			var cam_xoffset = 0;
			var cam_yoffset = 0;
			
			// Horizontal alignment
			switch (camera_get_view_halign(_camera)) {
				case va_center: cam_xoffset = ((_port_width - cam_width)*0.5); break;
				case va_right: cam_xoffset = (_port_width - cam_width); break;
			}
			
			// Vertical alignment
			switch (camera_get_view_valign(_camera)) {
				case va_middle: cam_yoffset = ((_port_height - cam_height)*0.5); break;
				case va_bottom: cam_yoffset = (_port_height - cam_height); break;
			}
			
			// Align camera to viewport
			camera_set_view_pos(
				_camera,
				camera_get_view_x(_camera) - cam_xoffset,
				camera_get_view_y(_camera) - cam_yoffset,
			);
		}
	}
	
	// Update view camera properties
	xtend_view.width_previous = camera_get_view_width(_camera);   // Must not use `cam_width` or
	xtend_view.height_previous = camera_get_view_height(_camera); // `cam_height` here!
}