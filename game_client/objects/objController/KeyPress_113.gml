if objOnline.lobby_id != "" {
	objOnline.lobby_id = ""
	global.state.player_name = ""
	global.state.role = ROLE.NONE
	ds_map_clear(objOnline.players)
	send(MESSAGE.LEAVE_GAME)
}
room_goto(rTitle)