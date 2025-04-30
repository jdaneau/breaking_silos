/// @description DEMO: Initialize demo

/*
GLOBAL
*/

// Set demo Xtend config
xtend.win.dpi_enabled = true;
xtend.win.width_base = 1280;
xtend.win.height_base = 720;
xtend.win.aspect_min = 2/3;
xtend.win.aspect_max = 32/9;

xtend.scale.enabled = true;
xtend.scale.filter = false;
xtend.scale.gui = true;
xtend.scale.mode = aspect;
xtend.scale.view = 0;
xtend.scale.preserve = false;

xtend.debug.stats_enabled = false;
xtend.debug.stats_color = c_lime;
xtend.debug.hints_enabled = false;
xtend.debug.hints_alpha = 0.5;
xtend.debug.hints_color = c_aqua;

// Don't limit aspect on mobile
if (os_type == os_android)
or (os_type == os_ios) {
	xtend.win.aspect_min = 0;
}

// Set splitscreen view camera properties
camera_set_view_pos(view_camera[1], 3840, 2160);
camera_set_view_size(view_camera[1], 420, 280);

// Initialize mouse movement tracking
global.device_mouse_scaled_x = view_xcenter;
global.device_mouse_scaled_y = view_ycenter;
global.device_mouse_scaled_xprevious = global.device_mouse_scaled_x;
global.device_mouse_scaled_yprevious = global.device_mouse_scaled_y;
view_move = 0;

// Choose a random background to display
randomize();
scene = choose(spr_bg_stage, spr_bg_classic);


/*
GUI
*/

// Create demo buttons
with (instance_create_depth(view_xcenter, view_ycenter + 64, depth - 1, obj_demo_button)) {
	label = "Add Ruler";
	action = function() {
		if (view_visible[1]) {
			var view = choose(0, 1);
		} else {
			var view = 0;
		}
		
		var range_xmin = (3840*view);
		var range_ymin = (2160*view);
		
		var range_xmax = 1280 + (3840*view);
		var range_ymax = 720  + (2160*view);
		
		instance_create_depth(irandom_range(range_xmin, range_xmax), irandom_range(range_ymin, range_ymax), depth - 1, obj_demo_ruler);
		instance_create_depth(irandom_range(range_xmin, range_xmax), irandom_range(range_ymin, range_ymax), depth - 1, obj_demo_ruler);
	}
}
with (instance_create_depth(view_xcenter, view_ycenter + 128, depth - 1, obj_demo_button)) {
	label = "Toggle Splitscreen";
	action = function() {
		view_visible[1] = !view_visible[1];
	}
}
with (instance_create_depth(view_xcenter, view_ycenter + 192, depth - 1, obj_demo_button)) {
	label = "Toggle Debug Mode";
	action = function() {
		xtend.debug.stats_enabled = !xtend.debug.stats_enabled;
		xtend.debug.hints_enabled = !xtend.debug.hints_enabled;	
	}
}

// Create demo buttons container (buttons follow container scale)
with (instance_create_depth(view_xcenter, view_ycenter + 32, depth - 1, obj_demo_container)) {
	image_xscale = 0.33;
	image_yscale = 0.33;
}