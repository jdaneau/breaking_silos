/// @description DEMO: Scale splitscreen view camera

// Splitscreen view will scale to fit right half of screen. Inherits other view camera properties
camera_set_view_scale(view_camera[1], pixel, view_xcenter, 0, view_width*0.5, view_height);