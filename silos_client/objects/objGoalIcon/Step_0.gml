if global.mouse_depth >= depth and coords_in(mouse_x,mouse_y,bbox_left,bbox_top,bbox_right,bbox_bottom) {
	image_index=1
	if mouse_check_pressed(mb_left) and !instance_exists(objGUIIntro) {
		instance_create_depth(0,0,-200,objGUIIntro)
	}
} else {
	image_index = 0
}