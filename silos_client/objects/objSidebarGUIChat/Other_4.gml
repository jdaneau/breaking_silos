if room == rInGame {
	var disaster = global.state.disaster;
	if disaster == "cyclone" { disaster = "tropical cyclone" }
	chat_add("Server",string("We are currently facing a {0} of {1} intensity. You must work together to implement the best DRR measures! Read your role-specific description by hovering over the question mark next to your avatar. Good luck!",disaster,global.state.disaster_intensity))
}
else if room == rGameResults {
	chat_add("Server", "The last round has finished! Now is the time to reflect on the decisions made during the game and determine what went right and what went wrong.")
	chat_add("Server", "Here are some possible discussion points:")
	chat_add("Server", "What role-specific challenges did you face and how did you overcome them?")
	chat_add("Server", "How did you deal with the budget limitation? Was there enough emphasis placed on long-term solutions?")
	chat_add("Server", "Would your strategy have worked better/worse under different circumstances?")
	chat_add("Server", "What other multi-hazard interactions can you image that aren't represented in this game, and how could they change the DRR strategy?")
}