//destroy any sockets that had no response within 30 seconds
var n_removed = 0;
for(var i=0; i<array_length(destroy_sockets); i++) {
	if ds_map_exists(sockets, destroy_sockets[i]) {
		ds_map_delete(sockets, destroy_sockets[i])	
		n_removed++
	}
}
if n_removed > 0 show_debug_message(string("Removed {0} players from the socket list.",n_removed))
destroy_sockets = []