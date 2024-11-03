function get_ai_messages(){
	var messages = [];
	var all_roles = ds_map_keys_to_array(global.roles);
	var player_roles = ds_map_values_to_array(objOnline.players);
	var ai_roles = [];
	for(var i=0; i<array_length(all_roles); i++) {
		if !array_contains(player_roles, all_roles[i]) array_push(ai_roles, all_roles[i])
	}
	
	//todo: ai suggestions
}