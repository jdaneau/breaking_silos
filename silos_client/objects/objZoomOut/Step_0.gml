if global.mouse_depth >= depth and coords_in(mouse_x,mouse_y,bbox_left,bbox_top,bbox_right,bbox_bottom) {
	image_index=1
	if mouse_check_pressed(mb_left) and !instance_exists(objGUIIntro) {
		with objMapGUI { 
			if map_zoom >= 1.4 {
				zoom(-0.4) 
			} else {
				var zoom_amt = map_zoom - 1;
				if zoom_amt > 0 zoom(-zoom_amt) 
			}
		}
	}
} else {
	image_index = 0
}