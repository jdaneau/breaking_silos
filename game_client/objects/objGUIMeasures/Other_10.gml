var _x;
var _icon;
var _measure;
var _sep = 128;
if array_length(measures) > 4 { _sep = 96 }
if array_length(measures) > 12 { _sep = 64 +16 }
for(var i=0; i<array_length(measures); i++) {
	if i mod 3 == 0 { _x = x+(sprite_width/4)-32 } 
	else if i mod 3 == 1 {  _x = x+(sprite_width*2/4)-32 }
	else { _x = x+(sprite_width*(3/4))-32 }
	_icon = instance_create_depth(_x,y,-1,objMeasureIcon)
	_measure = ds_map_find_value(global.measures, measures[i])
	_icon.name = _measure.name
	_icon.text = _measure.description
	_icon.key_info = _measure.key_use
	_icon.cost = _measure.cost
	_icon.time = _measure.time
	_icon.unit = _measure.unit
	_icon.sprite_index = get_measure_sprite(measures[i])
	_icon.measure_id = measures[i]
	if i mod 3 == 2 { y += _sep }
}
with objMeasureIcon event_user(0)