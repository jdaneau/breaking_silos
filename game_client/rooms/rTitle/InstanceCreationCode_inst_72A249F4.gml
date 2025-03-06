text="Create Game"
font=fSidebar
on_click=function(on) {
	room_goto(rCreateGame)
	global.state.current_room = rCreateGame
}