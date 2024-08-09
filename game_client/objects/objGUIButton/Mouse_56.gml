if click and hover {
	if toggle { 
		var _on = !on;
		with objMapGUI reset_info_layers() //sets all buttons to off
		on = _on
	}
	on_click(on)
}
click = false