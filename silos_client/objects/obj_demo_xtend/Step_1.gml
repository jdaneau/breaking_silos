/// @description DEMO: Update mouse movement tracking

// Get camera based on most recently-clicked view
var cam = view_camera[max(0, view_move)];

// Update mouse position scaled to view
global.device_mouse_scaled_x = ((device_mouse_raw_x(0)/window_get_width())*(camera_get_view_width(cam)*(1 + view_move)));
global.device_mouse_scaled_y = ((device_mouse_raw_y(0)/window_get_height())*camera_get_view_height(cam));