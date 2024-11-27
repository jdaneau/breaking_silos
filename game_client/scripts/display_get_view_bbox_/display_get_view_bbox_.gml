/// @function		display_get_bbox_left();
/// @requires		xtend, ext_xtend
/// @description	Android/iOS only. Returns the width in pixels of the left bounding box
///                 (or pillarbox) of a display with cutout. Will return 0 on other displays.
///					Note that bounding box will change depending on device orientation.
///
/// @example        var str = "Hello, world!";
///                 var sx = display_get_bbox_left();
///					var sy = 50;
///
///                 draw_text(sx, sy, str);
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2021, All Rights Reserved

function display_get_bbox_left() {
	// Get resolution source
	switch (event_number) {
		// Draw GUI events
		case ev_gui:
		case ev_gui_begin:
		case ev_gui_end: {
			return (ext_xtend_function_l()/display_get_width())*display_get_gui_width();
		}
		
		// Other events
		default: {
			return (ext_xtend_function_l()/display_get_width())*view_width;
		}
	}
}


/// @function		display_get_bbox_right();
/// @requires		xtend, ext_xtend
/// @description	Android/iOS only. Returns the width in pixels of the right bounding box 
///                 (or pillarbox) of a display with cutout. Will return 0 on other displays.
///					Note that bounding box will change depending on device orientation.
///
/// @example        var str = "Hello, world!";
///                 var sx = display_get_width() - display_get_bbox_right() - string_width(str);
///					var sy = 50;
///
///                 draw_text(sx, sy, str);
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2021, All Rights Reserved

function display_get_bbox_right() {
	// Get resolution source
	switch (event_number) {
		// Draw GUI events
		case ev_gui:
		case ev_gui_begin:
		case ev_gui_end: {
			return (ext_xtend_function_r()/display_get_width())*display_get_gui_width();
		}
		
		// Other events
		default: {
			return (ext_xtend_function_r()/display_get_width())*view_width;
		}
	}
}



/// @function		display_get_bbox_top();
/// @requires		xtend, ext_xtend
/// @description	Android/iOS only. Returns the height in pixels of the top bounding box 
///                 (or letterbox) of a display with cutout. Will return 0 on other displays.
///					Note that bounding box will change depending on device orientation.
///
/// @example        var str = "Hello, world!";
///					var sx = 50;
///                 var sy = display_get_bbox_top();
///
///                 draw_text(sx, sy, str);
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2021, All Rights Reserved

function display_get_bbox_top() {
	// Get resolution source
	switch (event_number) {
		// Draw GUI events
		case ev_gui:
		case ev_gui_begin:
		case ev_gui_end: {
			return (ext_xtend_function_t()/display_get_height())*display_get_gui_height();
		}
		
		// Other events
		default: {
			return (ext_xtend_function_t()/display_get_height())*view_height;
		}
	}
}



/// @function		display_get_bbox_bottom();
/// @requires		xtend, ext_xtend
/// @description	Android/iOS only. Returns the height in pixels of the bottom bounding box
///                 (or letterbox) of a display with cutout. Will return 0 on other displays.
///					Note that bounding box will change depending on device orientation.
///
/// @example        var str = "Hello, world!";
///					var sx = 50;
///                 var sy = display_get_height() - display_get_bbox_bottom() - string_height(str);
///
///                 draw_text(sx, sy, "Hello, world!");
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2021, All Rights Reserved

function display_get_bbox_bottom() {
	// Get resolution source
	switch (event_number) {
		// Draw GUI events
		case ev_gui:
		case ev_gui_begin:
		case ev_gui_end: {
			return (ext_xtend_function_b()/display_get_height())*display_get_gui_height();
		}
		
		// Other events
		default: {
			return (ext_xtend_function_b()/display_get_height())*view_height;
		}
	}
}