text="Create Game"
font=fHeader
on_click=function(on) {
	room_goto(rCreateGame)
	global.state.current_room = rCreateGame
}