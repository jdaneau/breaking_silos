var _y = camera_get_view_y(view_camera[0]);
var _ytarget = room_height - view_hport[0];
if _y < (_ytarget - 1) {
	camera_set_view_pos(view_camera[0], 0, lerp(_y, _ytarget, 0.05))
} else {
	camera_set_view_pos(view_camera[0], 0, _ytarget)
	instance_destroy()
}