function create_lobby() {
	var settings = {
		climate_intensity : get_selector_value("climate_intensity"),
		climate_type : get_selector_value("climate_type"),
		landscape_type : get_selector_value("landscape_type"),
		population : get_selector_value("population"),
		gdp : get_selector_value("gdp"),
		n_rounds : get_selector_value("n_rounds")
	};
	send_compound(MESSAGE.CREATE_GAME, [
		{ type : "string", content : get_textbox_text("name") },
		{ type : "struct", content : settings }
	])
}

function get_selector_value(selector_id) {
	for(var i=0; i<instance_number(objMenuSelector); i++) {
		var select = instance_find(objMenuSelector,i);
		if select.selector_id == selector_id { return select.selected }
	}
	for(var i=0; i<instance_number(objSlideSelector); i++) {
		var select = instance_find(objSlideSelector,i);
		if select.selector_id == selector_id { return select.value }
	}
	return -1
}

function get_textbox_text(textbox_id) {
	for(var i=0; i<instance_number(objTextInput); i++) {
		var textbox = instance_find(objTextInput,i);
		if textbox.textbox_id == textbox_id { return textbox.text }
	}
	return -1
}