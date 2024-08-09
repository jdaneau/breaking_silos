// source for this object:
// https://forum.gamemaker.io/index.php?threads/smooth-panning-and-zooming-made-easy.16523/

//establish the default view scale as a reference point
view_enabled=true
view_visible[0]=true

//The camera's width and height
view_wview=room_width 
view_hview=room_height 
//The camera's position
view_xview=0
view_yview=0

camera=camera_create_view(view_xview,view_yview,view_wview,view_yview)

view_set_camera(0,camera)

window_max_w = view_wview
window_max_h = view_hview
window_min_w = 90
window_min_h = 90

zoom_speed = 10

window_set_size(view_wview,view_hview)  
surface_resize(application_surface,view_wview,view_hview) 
display_set_gui_size(view_wview,view_hview) 

var display_width = display_get_width()
var display_height = display_get_height()

var window_width = view_wview
var window_height = view_hview

camera_set_view_pos(camera,view_xview,view_yview)
camera_set_view_size(camera,view_wview,view_hview)