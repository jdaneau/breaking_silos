//destroy any lobbies that had no responsive players
for(var i=0; i<array_length(destroy_lobbies); i++) {
	var lobby_id = destroy_lobbies[i];
	ds_map_destroy(lobbies[? lobby_id].players)
	ds_map_delete(lobbies, lobby_id)
}
destroy_lobbies = []