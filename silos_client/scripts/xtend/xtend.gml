/*
INITIALIZATION
*/

/// @description	Define macros
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2021, All Rights Reserved

#region xtend_init()

// Xtend properties
#macro xtend_version "1.0.5 build 042121"
#macro xtend global.ds_xtend

// Scale modes
#macro linear	0
#macro aspect	1
#macro axis_x	2
#macro axis_y	3
#macro pixel	4

// Viewport properties
#macro view_x		camera_get_view_x(view_camera[xtend.scale.view])
#macro view_y		camera_get_view_y(view_camera[xtend.scale.view])
#macro view_width	camera_get_view_width(view_camera[xtend.scale.view])
#macro view_height	camera_get_view_height(view_camera[xtend.scale.view])
#macro view_xcenter	(view_width*0.5)
#macro view_ycenter (view_height*0.5)
#macro view_xscale	(view_width/xtend.win.width_base)
#macro view_yscale	(view_height/xtend.win.height_base)
#macro view_aspect	(view_width/view_height)

// Viewport alignment
#macro va_left		fa_left
#macro va_center	fa_center
#macro va_right		fa_right
#macro va_top		fa_top
#macro va_middle	fa_middle
#macro va_bottom	fa_bottom

// Initialize at runtime
gml_pragma("global", "xtend_init();");



/// @function		xtend_init();
/// @requires		obj_server_xtend, window_set_dpi, xtend_config
/// @description	Initializes Xtend and automatically adds the scaler object to all rooms
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2021, All Rights Reserved

function xtend_init() {
	// Configure Xtend
	xtend_config();
	
	// Initialize master view camera properties
	xtend.cam = { 
		width_previous:	 0,
		height_previous: 0,
	}

	// Initialize base window properties
	if (!variable_struct_exists(xtend.win, "dpi_base")) {
		xtend.win.dpi_base = 96;
		
		// Platform-specific DPI defaults
		switch (os_type) {
			case os_android: xtend.win.dpi_base = 240; break;
			case os_ios: xtend.win.dpi_base = 192; break;
		}
	}
	if (!variable_struct_exists(xtend.win, "width_base")) {
		xtend.win.width_base	= max(window_get_width(), window_get_height());
	}
	if (!variable_struct_exists(xtend.win, "height_base")) {
		xtend.win.height_base	= min(window_get_width(), window_get_height());
	}

	// Initialize display properties
	xtend.win.dpi					= xtend.win.dpi_base;
	xtend.win.dpi_base_previous		= xtend.win.dpi_base;
	xtend.win.dpi_enabled_previous	= xtend.win.dpi_enabled;
	xtend.win.width_base_previous	= xtend.win.width_base;
	xtend.win.height_base_previous  = xtend.win.height_base;
	xtend.win.full_previous			= window_get_fullscreen();
	xtend.win.width_previous		= 0;
	xtend.win.height_previous		= 0;
	xtend.win.aspect_min_previous	= 0;
	xtend.win.aspect_max_previous	= 0;
	xtend.win.resized				= false;
	
	// Initialize scale properties
	xtend.scale.enabled_previous	= xtend.scale.enabled;
	xtend.scale.sample_previous		= 1;

	// Initialize debug properties
	xtend.debug.font				= fnt_debug_100;

	// Initialize aspect ratio limits
	if (!variable_struct_exists(xtend.win, "aspect_min")) {
		xtend.win.aspect_min = 0;
	}
	if (!variable_struct_exists(xtend.win, "aspect_max")) {
		xtend.win.aspect_max = 0;
	}
	
	// Initialize final resolution sample size
	if (!variable_struct_exists(xtend.scale, "sample")) {
		xtend.scale.sample = 1;
	}
	
	// Initialize preserving scale when disabled
	if (!variable_struct_exists(xtend.scale, "preserve")) {
		xtend.scale.preserve = false;
	}

	// Initialize debug properties
	if (!variable_struct_exists(xtend.debug, "hints_alpha")) {
		xtend.debug.hints_alpha = 0.5;
	}
	if (!variable_struct_exists(xtend.debug, "hints_color")) {
		xtend.debug.hints_color = c_aqua;
	}
	if (!variable_struct_exists(xtend.debug, "stats_color")) {
		xtend.debug.stats_color = c_lime;
	}

	// Apply texture filtering, if enabled
	gpu_set_texfilter(xtend.scale.filter);

	// Apply DPI-aware scaling, if enabled
	window_set_dpi();

	// Automatically insert Xtend object to first room
	room_instance_add(room_first, 0, 0, obj_server_xtend);

	// Automatically enable Xtend viewport in all rooms
	var r = room_first;
	while (room_exists(r)) {
		room_set_view_enabled(r, true);
		if (room_get_viewport(r, xtend.scale.view)[0] == false) {
			room_set_viewport(r, xtend.scale.view, true, 0, 0, xtend.win.width_base, xtend.win.height_base);
			room_set_camera(r, xtend.scale.view, camera_create_view(0, 0, xtend.win.width_base, xtend.win.height_base));
		}
		r = room_next(r);
	}
}
#endregion


/*
FUNCTIONS
*/

/// @function		camera_get_view_struct(camera);
/// @param			{camera}	camera
/// @requires		camera_get_view
/// @description	Returns the index of the struct containing Xtend view camera properties.
///					If data for the input view camera does not exist, it will be created. If 
///					the input camera is not currently assigned to a view, `undefined` will
///					be returned instead.
///
/// @example		var xtend_view = camera_get_view_struct(my_cam);
///
///					if (!is_undefined(xtend_view)) {
///						xtend_view.width_base  = 1920;
///						xtend_view.height_base = 1080;
///					}
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2021, All Rights Reserved

function camera_get_view_struct(_camera) {
	// Identify view from camera
	var _view = string(camera_get_view(_camera));

	// Return `undefined` if camera is not assigned to a view
	if (_view == "-1") {
		return undefined;
	}
	
	// Ensure view camera struct exists
	if (!variable_struct_exists(xtend, "view" + _view)) {
		// Create sub-struct for view camera data
		variable_struct_set(xtend, "view" + _view, {});
			
		// Get view camera data
		var xtend_view = variable_struct_get(xtend, "view" + _view);
			
		// Initialize view camera properties
		xtend_view.width_base = camera_get_view_width(_camera);
		xtend_view.height_base = camera_get_view_height(_camera);
		xtend_view.halign = va_left;
		xtend_view.valign = va_top;
	}
	
	// Get view camera data
	var xtend_view = variable_struct_get(xtend, "view" + _view);
	
	// Ensure view camera position data exists
	if (!variable_struct_exists(xtend_view, "width_previous")) {
		xtend_view.width_previous = camera_get_view_width(_camera);
	}
	if (!variable_struct_exists(xtend_view, "height_previous")) {
		xtend_view.height_previous = camera_get_view_height(_camera);
	}
		
	// Return view camera data
	return xtend_view;
}


/// @function		window_get_dpi();
/// @description	Returns the current window DPI as a **scale multiplier** of the base
///					DPI setting. Result depends on the running platform. Desktop platforms
///					will scale up (> 1), while mobile platforms will scale down (< 1).
///
/// @example		if (window_get_dpi() < 1) {
///						draw_set_font(font_small);
///					} else {
///						draw_set_font(font_large);
///					}
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2021, All Rights Reserved

function window_get_dpi() {
	if (os_type == os_android) or (os_type == os_ios) {
		// Mobile
		return (xtend.win.dpi/display_get_dpi_x());
	} else {
		// Other
		return (display_get_dpi_x()/xtend.win.dpi);
	}
}


/// @function		window_set_dpi([dpi]);
/// @param			{real}	[dpi]
/// @description	Applies the current DPI scale to the window, if DPI scaling is enabled.
///					Can also be used to override the base DPI setting if a new DPI value is
///					provided. If DPI scaling is disabled, base DPI will be applied instead
///					regardless of override.
///
/// @example		window_set_dpi();
///					window_set_dpi(128);
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2021, All Rights Reserved

function window_set_dpi() {
	// Set DPI, if specified
	if (argument_count > 0) {
		xtend.win.dpi_enabled = true;
		xtend.win.dpi = argument[0];
	}
	
	// Force disable DPI scaling in HTML5 (DPI scaling is handled by the browser)
	if (os_browser != browser_not_a_browser) {
		if (xtend.win.dpi_enabled) {
			// Show debug notice
			show_debug_message("WARNING: Attempting to set DPI in HTML5. DPI scaling is handled by the browser, not Xtend! Operation cancelled.");
			
			// Force disable DPI scaling
			xtend.win.dpi = display_get_dpi_x();
			xtend.win.dpi_enabled = false;
		}
		exit;
	}
	
	// Use real DPI if DPI scaling is disabled
	if (!xtend.win.dpi_enabled) or (!xtend.scale.enabled) {
		if (!xtend.scale.preserve) {
			xtend.win.dpi = display_get_dpi_x();
		}
	}
	
	// Set window scale (DPI-awareness)
	if (os_type == os_android) or (os_type == os_ios) {
		// Mobile
		if (window_get_width() > window_get_height()) 
		or (xtend.win.width_base < xtend.win.height_base) {
			// Landscape (or user-enforced portrait)
			xtend.win.width_base = min(xtend.win.width_base, round_to(window_get_width()*window_get_dpi(), 2));
			xtend.win.height_base = min(xtend.win.height_base, round_to(window_get_height()*window_get_dpi(), 2));
		} else {
			// Portrait (or user-enforced landscape)
			xtend.win.width_base = min(xtend.win.width_base, round_to(window_get_height()*window_get_dpi(), 2));
			xtend.win.height_base = min(xtend.win.height_base, round_to(window_get_width()*window_get_dpi(), 2));
		}
	} else {
		// Other
		var win_x = (window_get_x() + (window_get_width()*0.5));
		var win_y = (window_get_y() + (window_get_height()*0.5));
		var win_width  = (xtend.win.width_base*window_get_dpi());
		var win_height = (xtend.win.height_base*window_get_dpi());
	
		// Scale window, if DPI scale is not larger than display
		if (win_width < display_get_width()) and (win_height < display_get_height()) {
			window_set_rectangle(
				clamp(win_x - (win_width*0.5), 1, display_get_width() - 1),
				clamp(win_y - (win_height*0.5), 1, display_get_height() - 1),
				win_width,
				win_height
			);
		} else {
			// Show debug notice
			if (xtend.win.dpi_enabled) {
				show_debug_message("WARNING: Requested DPI too large for display! Resetting to native DPI...");
			}
		
			// Otherwise force disable DPI scaling
			xtend.win.dpi = display_get_dpi_x();
			xtend.win.dpi_enabled = false;
		}
	}
	
	// Get minimum window size multiplier
	if (xtend.scale.mode == pixel) {
		var win_min_scale = 1;
	} else {
		var win_min_scale = 0.5;
	}
	
	// Get minimum window size
	var win_min_height = (xtend.win.height_base*win_min_scale);
	if (xtend.win.aspect_min > 0) {
		// Use minimum aspect ratio, if enabled
		var win_min_width = (win_min_height*xtend.win.aspect_min);
	} else {
		// Otherwise use base height
		var win_min_width = (xtend.win.width_base*win_min_scale);
	}
	
	// Set minimum window size relative to DPI scale
	window_set_min_width(win_min_width*window_get_dpi());
	window_set_min_height(win_min_height*window_get_dpi());
}


/// @function		window_resized();
/// @description	Returns `true` for one step after the window has been resized, after 
///					which it will return `false`. Can be used to trigger behaviors in 
///					response to changes in window size.
///
/// @example		if (window_resized()) {
///						// Action on resize
///					}
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2021, All Rights Reserved

function window_resized() {
	return xtend.win.resized;
}


/// @function		window_set_view_scale([force]);
/// @param			{boolean}	[force]
/// @requires		round_to
/// @description	Checks for changes in window properties and updates the view camera and
///					application surface to fill available space according to the configured
///					scaling method.
///
///					Typically must be run every Step to apply. Enabling `force` will run
///					regardless of changes in window properties--such as when changes have
///					been made to scaling behaviors instead.
///
/// @example		window_set_view_scale();
///					window_set_view_scale(true);
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2021, All Rights Reserved

function window_set_view_scale() {
	
	/*
	INITIALIZATION
	*/
	
	// Force scaling, if enabled
	var force = false;
	if (argument_count > 0) {
		force = argument[0];
	}
	
	// Get current view camera dimensions
	var cam_width = camera_get_view_width(view_camera[xtend.scale.view]);
	var cam_height = camera_get_view_height(view_camera[xtend.scale.view]);
			
	// Get master view camera data
	if (cam_width != xtend.cam.width_previous) or (cam_height != xtend.cam.height_previous) 
	or (xtend.win.width_base != xtend.win.width_base_previous) or (xtend.win.height_base != xtend.win.height_base_previous) {
		var xtend_view = camera_get_view_struct(view_camera[xtend.scale.view]);
	
		// If master view camera is destroyed, recreate it (this should not happen!)
		if (is_undefined(xtend_view)) {
			show_debug_message(
				"WARNING: View camera view_camera[" + string(xtend.scale.view) + "] doesn't exist! " +
				"Creating from defaults..."
			);
		
			// Create new master view camera
			view_camera[xtend.scale.view] = camera_create_view(0, 0, xtend.win.width_base, xtend.win.height_base);
			
			// Get master view camera data
			xtend_view = camera_get_view_struct(view_camera[xtend.scale.view]);
		
			// Refresh view scale
			force = true;
		}
		
		// Check for manual changes in view camera dimensions
		if (!xtend.win.resized) {
			// Update camera if base resolution is changed
			if (xtend.win.width_base != xtend.win.width_base_previous) 
			or (xtend.win.height_base != xtend.win.height_base_previous) {
				// Refresh view scale
				force = true;
			}
			
			// Update base resolution if camera is changed
			if (cam_width != xtend_view.width_previous)
			or (cam_height != xtend_view.height_previous) {
				// Update base view dimensions
				xtend.win.width_base = cam_width;
				xtend.win.height_base = cam_height;
			
				// Refresh view scale
				force = true;
			}
	
			// Refresh view camera dimensions
			cam_width = camera_get_view_width(view_camera[xtend.scale.view]);
			cam_height = camera_get_view_height(view_camera[xtend.scale.view]);
		}
		
		// Update master view port properties
		xtend_view.width_base = xtend.win.width_base;
		xtend_view.height_base = xtend.win.height_base;
		xtend_view.width_previous = cam_width;
		xtend_view.height_previous = cam_height;
		
		// Update master view camera properties
		xtend.cam.width_previous = cam_width;
		xtend.cam.height_previous = cam_height;
		
		// Update base resolution properties
		xtend.win.width_base_previous = xtend.win.width_base;
		xtend.win.height_base_previous = xtend.win.height_base;
	}
	
	// Check for manual changes in DPI scaling
	if (xtend.win.dpi_base != xtend.win.dpi_base_previous) 
	or (xtend.win.dpi_enabled != xtend.win.dpi_enabled_previous) {
		// Update DPI scaling, if changed
		window_set_dpi(xtend.win.dpi_base);
		
		// Update DPI scaling checks
		xtend.win.dpi_base_previous = xtend.win.dpi_base;
		xtend.win.dpi_enabled_previous = xtend.win.dpi_enabled;
	}
	
	// Reset window status
	xtend.win.resized = false;
	
	// Get original window dimensions
	var win_width = xtend.win.width_base;
	var win_height = xtend.win.height_base;
	
	// Get current window dimensions based on platform
	if (xtend.scale.enabled) or (xtend.scale.preserve) {
		if (os_browser != browser_not_a_browser) {
			// HTML5
			win_width = (browser_width - 1);
			win_height = (browser_height - 1);
		} else {
			// Other
			win_width = window_get_width();
			win_height = window_get_height();
		}
	}
	
	// Get current screen mode
	var win_full = window_get_fullscreen();
	
	// Skip scaling if minimized
	if (win_width < 32) or (win_height < 32) {
		exit;
	}
	
	
	/*
	SCALING
	*/
	
	// If window properties have changed...
	if (win_width != xtend.win.width_previous) 
	or (win_height != xtend.win.height_previous)
	or (win_full != xtend.win.full_previous) 
	or (xtend.win.aspect_min != xtend.win.aspect_min_previous)
	or (xtend.win.aspect_max != xtend.win.aspect_max_previous)
	or (xtend.scale.enabled != xtend.scale.enabled_previous)
	or (force) {
		// Update window properties
		xtend.win.width_previous = win_width;
		xtend.win.height_previous = win_height;
		xtend.win.full_previous = win_full;
		xtend.win.aspect_min_previous = xtend.win.aspect_min;
		xtend.win.aspect_max_previous = xtend.win.aspect_max;
               
		// If scaling is enabled...
		if (xtend.scale.enabled) or (xtend.scale.enabled_previous) {
			if (xtend.scale.enabled) or (xtend.scale.preserve) {
				// Round window dimensions to preserve square pixels
				if (!win_full) {
					win_width = round_to(win_width, 2);
					win_height = round_to(win_height, 2);
					window_set_size(win_width, win_height);
				}
				
				// Limit aspect ratio, if enabled
				if (xtend.win.aspect_min > 0) {
					if ((win_width/win_height) < xtend.win.aspect_min) {
						win_height = round_to(win_width/xtend.win.aspect_min, 2);
					}
				}
				if (xtend.win.aspect_max > 0) {
					if ((win_width/win_height) > xtend.win.aspect_max) {
						win_width = round_to(win_height*xtend.win.aspect_max, 2);
					}
				}
			}
			
		    // Scale application surface
		    if (surface_exists(application_surface)) {
		        surface_resize(application_surface, win_width, win_height);
			} else {
				// Restart scale operation if application surface is busy
				xtend.win.width_previous = 0;
				xtend.win.height_previous = 0;
				exit;
			}
		
			// Scale GUI to application surface, if GUI scaling is disabled
			if (!xtend.scale.gui) {
				display_set_gui_size(win_width, win_height);
			}
		
			// Scale viewport according to the configured mode
			switch (xtend.scale.mode) {
				// Aspect ratio scaling
				case aspect: 
					// Get base aspect ratio
					var win_ratio_base = (xtend.win.width_base/xtend.win.height_base);
		
					// Get current aspect ratio
					var win_ratio = (win_width/win_height);
		
					// Scale to aspect ratio while preserving base resolution
					if (win_ratio > win_ratio_base) {
						win_height = xtend.win.height_base;
						win_width = round_to(win_height*win_ratio, 2);
					} else {
						win_width = xtend.win.width_base;
						win_height = round_to(win_width/win_ratio, 2);
					}
				break;
			
				// X axis scaling
				case axis_x:
					// Get current aspect ratio
					var win_ratio = (win_width/win_height);
				
					// Scale width to aspect ratio while preserving height
					win_height = xtend.win.height_base;
					win_width = round_to(win_height*win_ratio, 2);
				break;
			
				// Y axis scaling
				case axis_y:
					// Get current aspect ratio
					var win_ratio = (win_width/win_height);
				
					// Scale height to aspect ratio while preserving width
					win_width = xtend.win.width_base;
					win_height = round_to(win_width/win_ratio, 2);
				break;
			
				// Pixel scaling
				case pixel:
					// Get nearest integer to scale
					var win_int = min(
						round(win_width/xtend.win.width_base), 
						round(win_height/xtend.win.height_base)
					);
					
					// Disallow invalid scale
					if (win_int == 0) {
						win_int = 1;
					}
				
					// Scale to aspect while preserving pixel ratio
					win_width /= win_int;
					win_height /= win_int;
				break;
			}
		
			// Set new viewport dimensions
			camera_set_view_size(view_camera[xtend.scale.view], win_width, win_height);
			view_wport[xtend.scale.view] = win_width;
			view_hport[xtend.scale.view] = win_height;
		
			// Scale GUI to viewport, if enabled
			if (xtend.scale.gui) {
				display_set_gui_size(win_width, win_height);
			}
			
			
			/*
			ALIGNMENT
			*/
			
			// Align viewport
			var cam_xoffset = 0;
			var cam_yoffset = 0;
			
			// Horizontal alignment
			switch (camera_get_view_halign(view_camera[xtend.scale.view])) {
				case va_center: cam_xoffset = ((win_width - cam_width)*0.5); break;
				case va_right: cam_xoffset = (win_width - cam_width); break;
			}
			
			// Vertical alignment
			switch (camera_get_view_valign(view_camera[xtend.scale.view])) {
				case va_middle: cam_yoffset = ((win_height - cam_height)*0.5); break;
				case va_bottom: cam_yoffset = (win_height - cam_height); break;
			}
			
			// Align camera to viewport
			camera_set_view_pos(
				view_camera[xtend.scale.view],
				camera_get_view_x(view_camera[xtend.scale.view]) - cam_xoffset,
				camera_get_view_y(view_camera[xtend.scale.view]) - cam_yoffset,
			);
		}
		
		
		/*
		PROPAGATION
		*/
		
		// Run Draw > Window Resize Event
		with (all) {
			event_perform(ev_draw, 65);
		}
		
		// Activate window_resized() function
		xtend.win.resized = true;
		
		// Update scaling properties
		xtend.scale.enabled_previous = xtend.scale.enabled;
		
		// Force resampling application surface, if enabled
		if (xtend.scale.sample != 1) {
			xtend.scale.sample_previous = 0;
		}
		
		
		/*
		DEBUG
		*/
		
		// Calculate font size percentage from window resolution
		var win_size = sqrt(win_width*win_height);
		var font_step = 50;
		var font_res = round_to(win_size*(0.1 - (win_size/100000)), font_step);
			
		// Limit minimum font size
		if (font_res < font_step) { 
			font_res = round_to((font_res + font_step), font_step); 
		}
			
		// Find nearest available font
		while (font_res > 0) {
			var font_check = asset_get_index("fnt_debug_" + string(font_res));
			if (font_exists(font_check)) {
				xtend.debug.font = font_check;
				break;
			}
				
			// If font was not found, check next size
			font_res -= font_step;
		}
	}
	
	
	/*
	SAMPLING
	*/
	
	// Check for manual changes in resolution sample size
	if (xtend.scale.sample != xtend.scale.sample_previous) {
		if (surface_exists(application_surface)) and (!xtend.win.resized) {
			if (xtend.scale.enabled) or (xtend.scale.preserve) {
				// Limit sample size based on platform
				switch (os_type) {
					case os_android:
					case os_ios:
					case os_switch: 
						xtend.scale.sample = clamp(
							xtend.scale.sample, 
							256/max(view_width, view_height), 
							4096/max(view_width, view_height)
						); 
					break;
				
					default: 
						xtend.scale.sample = clamp(
							xtend.scale.sample, 
							256/max(view_width, view_height), 
							8192/max(view_width, view_height)
						);
					break;
				}
		
				// Scale application surface
			    surface_resize(application_surface, view_width*xtend.scale.sample, view_height*xtend.scale.sample);
			}
			
			// Update resolution sample size
			xtend.scale.sample_previous = xtend.scale.sample;
		}
	}
}


/// @function		debug_draw_view_hints();
/// @description	Draws colored view borders to indicate where the view has been extended 
///					or cropped, and by how much (in a value of pixels).
///					
///					The font used for drawing stats is itself determined by view scale. See
///					`debug_draw_view_stats` for details.
///
/// @example		debug_draw_view_hints();
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2021, All Rights Reserved

function debug_draw_view_hints() {
	// Draw debug hints, if enabled
	if (xtend.debug.hints_enabled) {
		// Get current drawing properties
		var fnt = draw_get_font();
		var halign = draw_get_halign();
		var valign = draw_get_valign();
		var color = draw_get_color();
		var alpha = draw_get_alpha();
	
		// Get opposite hints color
		var color_alt = make_color_hsv(
			(color_get_hue(xtend.debug.hints_color) + 128) mod 255,
			color_get_saturation(xtend.debug.hints_color),
			color_get_value(xtend.debug.hints_color)
		);
	
		// Set hints drawing properties
		draw_set_font(xtend.debug.font);
		draw_set_halign(fa_center);
		draw_set_valign(fa_middle);
		draw_set_alpha(xtend.debug.hints_alpha);
		
		
		/*
		MASTER VIEW
		*/
		
		// Get hint box dimensions
		var view_bbox_width = (view_width - xtend.win.width_base);
		var view_bbox_height = (view_height - xtend.win.height_base);
		
		// Get hint box position
		var view_bbox_right = (view_width - abs(view_bbox_width));
		var view_bbox_bottom = (view_height - abs(view_bbox_height));
	
		// Draw right hint box
		if (view_bbox_right != view_width) {
			// Get right hint box properties
			if (view_bbox_width > 0) {
				// Extend
				draw_set_color(xtend.debug.hints_color);
			} else {
				// Crop
				draw_set_color(color_alt);
			}
			
			// Draw right hint box
			draw_rectangle(view_bbox_right, 0, view_width, view_height, false);
	
			// Draw right hint box label
			gpu_set_blendmode(bm_add);
			draw_text(
				view_width - max(abs(view_bbox_width*0.5), string_width("   ")), (view_bbox_bottom*0.5), 
				string(round(view_bbox_width)) + "px"
			);
			gpu_set_blendmode(bm_normal);
		}
	
		// Draw bottom hint box
		if (view_bbox_bottom != view_height) {
			// Get bottom hint box properties
			if (view_bbox_height > 0) {
				// Extend
				draw_set_color(xtend.debug.hints_color);
			} else {
				// Crop
				draw_set_color(color_alt);
			}
		
			// Draw bottom hint box
			draw_rectangle(0, view_bbox_bottom, view_bbox_right - 1, view_height, false);
	
			// Draw bottom hint box label
			gpu_set_blendmode(bm_add);
			draw_text(
				(view_bbox_right*0.5), view_height - max(abs(view_bbox_height*0.5), string_height("   ")), 
				string(round(view_bbox_height)) + "px"
			);
			gpu_set_blendmode(bm_normal);
		}
		
		
		/*
		OTHER VIEWS
		*/
		
		for (var v = 0; v <= 7; v++) {
			if (variable_struct_exists(xtend, "view" + string(v)))
			and (v != xtend.scale.view) {
				if (view_visible[v]) {
					// Get view camera data
					var xtend_view = variable_struct_get(xtend, "view" + string(v));
					
					// Get view camera properties
					var cam_width = camera_get_view_width(view_camera[v]);
					var cam_height = camera_get_view_height(view_camera[v]);
					
					// Get view port properties
					var port_x = view_xport[v];
					var port_y = view_yport[v];
					var port_width = view_wport[v];
					var port_height = view_hport[v];
					
					// Get hint box dimensions
					var port_bbox_width = port_width*((cam_width - xtend_view.width_base)/cam_width);
					var port_bbox_height = port_height*((cam_height - xtend_view.height_base)/cam_height);
					
					// Get hint box position
					var port_bbox_right = (port_width - abs(port_bbox_width));
					var port_bbox_bottom = (port_height - abs(port_bbox_height));
					
					// Draw right hint box
					if (port_bbox_right != port_width) {
						if (port_bbox_width > 0) {
							// Extend
							draw_set_color(xtend.debug.hints_color);
						} else {
							// Crop
							draw_set_color(color_alt);
						}
			
						// Draw right hint box
						draw_rectangle(port_x + port_bbox_right, port_y, port_x + port_width, port_y + port_height, false);
	
						// Draw right hint box label
						gpu_set_blendmode(bm_add);
						draw_text(
							port_x + port_width - max(abs(port_bbox_width*0.5), string_width("   ")), port_y + (port_bbox_bottom*0.5), 
							string(round(cam_width - xtend_view.width_base)) + "px"
						);
						gpu_set_blendmode(bm_normal);
					}
					
					// Draw bottom hint box
					if (port_bbox_bottom != port_height) {
						if (port_bbox_height > 0) {
							// Extend
							draw_set_color(xtend.debug.hints_color);
						} else {
							// Crop
							draw_set_color(color_alt);
						}
			
						// Draw bottom hint box
						draw_rectangle(port_x, port_y + port_bbox_bottom, port_x + port_bbox_right - 1, port_y + port_height, false);
	
						// Draw bottom hint box label
						gpu_set_blendmode(bm_add);
						draw_text(
							port_x + (port_bbox_right*0.5), port_y + port_height - max(abs(port_bbox_height*0.5), string_height("   ")), 
							string(round(cam_height - xtend_view.height_base)) + "px"
						);
						gpu_set_blendmode(bm_normal);
					}
				}
			}
		}
		
		
		/*
		FINALIZATION
		*/
	
		// Reset drawing properties
		draw_set_font(fnt);
		draw_set_halign(halign);
		draw_set_valign(valign);
		draw_set_color(color);
		draw_set_alpha(alpha);
	}	
}


/// @function		debug_draw_view_stats();
/// @requires		camera_get_view_xscale, camera_get_view_yscale
/// @description	Draws a variety of debug statistics and scaling values, as well as the 
///					current version of Xtend.
///
///					The font used for drawing stats is itself determined by view scale, as a
///					percentage of DPI. (As a rule of thumb, a font scale of 100% should be 
///					suitable for 1080p.) Several font scales are included by default, covering 
///					a range from 240p-4K, but additional fonts can be supplied for even broader 
///					range. Simply name your font `fnt_debug_###`, where "###" is the percentage 
///					the font should apply to.
///
/// @example		debug_draw_view_stats();
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2021, All Rights Reserved

function debug_draw_view_stats() {
	// Draw debug stats, if enabled
	if (xtend.debug.stats_enabled) {
		
		/*
		MASTER VIEW
		*/
		
		// Get text label for scaling mode
		var scale_mode = "linear";
		switch (xtend.scale.mode) {
			case aspect: scale_mode = "aspect"; break;
			case axis_x: scale_mode = "axis_x"; break;
			case axis_y: scale_mode = "axis_y"; break;
			case pixel:  scale_mode = "pixel"; break;
		}
	
		// Get current font properties
		var fnt		= draw_get_font();
		var color	= draw_get_color();
		var halign	= draw_get_halign();
		var valign	= draw_get_valign();
		var xoffset = max(
			font_get_size(xtend.debug.font)*0.5, 
			display_get_bbox_left(), 
			display_get_bbox_right()
		);
		var yoffset = max(
			font_get_size(xtend.debug.font)*0.5, 
			display_get_bbox_top(), 
			display_get_bbox_bottom()
		);
	
		// Set debug font
		draw_set_font(xtend.debug.font);
		draw_set_color(xtend.debug.stats_color);
		draw_set_valign(fa_top);
	
		// Draw scaling stats
		draw_set_halign(fa_left);
		draw_text(
			xoffset + font_get_size(xtend.debug.font), yoffset + font_get_size(xtend.debug.font),
			"DEBUG MODE" +
			"\n" +
			"\n[Scaling]" +
			"\nEnabled: " + string(xtend.scale.enabled) +
			"\nBase: " + string(xtend.win.width_base) + "x" + string(xtend.win.height_base) +
			"\nWindow: " + string(window_get_width()) + "x" + string(window_get_height()) +
			"\nView: " + string(round(view_width)) + "x" + string(round(view_height)) + 
			"\nScale: " + string(view_xscale) + " | " + string(view_yscale) +
			"\n" +
			"\n[DPI]" +
			"\nEnabled: " + string(xtend.win.dpi_enabled) +
			"\nBase: " + string(xtend.win.dpi) +
			"\nWindow: " + string(display_get_dpi_x()) + 
			"\nScale: " + string(window_get_dpi()) 
		);
	
		// Draw config stats
		draw_set_halign(fa_right);
		draw_text(
			view_width - xoffset - font_get_size(xtend.debug.font), yoffset + font_get_size(xtend.debug.font),
			"XTEND VERSION " + xtend_version +
			"\n" + 
			"\n[Config]" +
			"\nFilter: " + string(xtend.scale.filter) + 
			"\nGUI: " + string(xtend.scale.gui) + 
			"\nMode: " + scale_mode + 
			"\nView: " + string(xtend.scale.view) + 
			"\n" +
			"\n[Aspect Ratio]" +
			"\nBase: " + string(xtend.win.width_base/xtend.win.height_base) + 
			"\nWindow: " + string(window_get_width()/window_get_height()) + 
			"\nView: " + string(view_aspect) + 
			"\nMin: " + string(xtend.win.aspect_min) + 
			"\nMax: " + string(xtend.win.aspect_max)
		);
		
		
		/*
		OTHER VIEWS
		*/
		
		xoffset = font_get_size(xtend.debug.font)*0.5;
		yoffset = font_get_size(xtend.debug.font)*0.5;
		
		for (var v = 0; v <= 7; v++) {
			if (variable_struct_exists(xtend, "view" + string(v)))
			and (v != xtend.scale.view) {
				if (view_visible[v]) {
					// Get view camera data
					var xtend_view = variable_struct_get(xtend, "view" + string(v));
					
					// Get view camera properties
					var cam_width  = camera_get_view_width(view_camera[v]);
					var cam_height = camera_get_view_height(view_camera[v]);
					var cam_xscale = camera_get_view_xscale(view_camera[v]);
					var cam_yscale = camera_get_view_yscale(view_camera[v]);
					
					// Draw scaling stats
					draw_set_halign(fa_left);
					draw_text(
						view_xport[v] + xoffset + font_get_size(xtend.debug.font), view_yport[v] + yoffset + font_get_size(xtend.debug.font),
						"[Scaling]" +
						"\nBase: " + string(xtend_view.width_base) + "x" + string(xtend_view.height_base) +
						"\nCamera: " + string(cam_width) + "x" + string(cam_height) +
						"\nPort: " + string(round(view_wport[v])) + "x" + string(round(view_hport[v])) + 
						"\nScale: " + string(cam_xscale) + " | " + string(cam_yscale)
					);
				}
			}
		}
		
		
		/*
		FINALIZATION
		*/
	
		// Reset font properties
		draw_set_font(fnt);
		draw_set_color(color);
		draw_set_halign(halign);
		draw_set_valign(valign);
	}	
}