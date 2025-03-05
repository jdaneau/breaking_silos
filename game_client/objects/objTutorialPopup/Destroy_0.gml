if array_length(global.tutorial_queue) > 0 {
	var next = array_first(global.tutorial_queue);	
	array_delete(global.tutorial_queue,0,1)
	tutorial_popup(next.x,next.y,next.tutorial_id)
} else {
	global.mouse_depth = 10
}