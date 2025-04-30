if !objOnline.connected or global.mouse_depth < depth hover = false

if sprite == noone {
	if coords_in(mouse_x,mouse_y,bbox_left,bbox_top,bbox_right,bbox_bottom) {
		hover = true	
	} else hover = false
}
else {
	if coords_in(mouse_x,mouse_y,x-32,y,bbox_right+32,bbox_bottom+96) {
		hover = true	
	} else hover = false
}