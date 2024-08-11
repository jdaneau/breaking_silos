var max_w = sprite_get_width(sprMapLegend);
var max_h = sprite_get_height(sprMapLegend);

if mouse_on {
	w = lerp(w,max_w,0.1)
	h = lerp(h,max_h,0.1)
} else {
	w = lerp(w,0,0.1)
	h = lerp(h,0,0.1)
}