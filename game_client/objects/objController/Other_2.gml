randomize()

//initialize maps
if file_exists("map.json") {
	var _f = file_text_open_read("map.json");
	var _json = file_text_read_string(_f);
	file_text_close(_f)
	global.map = json_parse(_json)
} else room_goto(rMap01)