if room != home_room {
	if surface_exists(surf) surface_free(surf)
	instance_destroy()
	exit
}

draw_set_halign(fa_left)
draw_set_valign(fa_top)

if mouse_on and global.mouse_depth >= depth {
	w = lerp(w,max_w,0.1)
	h = lerp(h,max_h,0.1)
} else {
	w = lerp(w,0,0.1)
	h = lerp(h,0,0.1)
}