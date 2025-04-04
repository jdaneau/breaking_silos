chat = []
home_room =room

if room == rInGame {
	var qualifier;
	var opening_line;
	if global.state.disaster_intensity == "low" qualifier = "minor"
	else if global.state.disaster_intensity == "medium" qualifier = "major"
	else if global.state.disaster_intensity == "high" qualifier = "massive"
	switch(global.state.disaster) {
		case "flood":
			opening_line = string("A {0} flood is about to happen in our country. We need to implement Disaster Risk Reduction (DRR) measures to mitigate the impact of this event.",qualifier);
		break;
		case "drought":
			opening_line = string("A {0} drought is happening in our country. We need to implement Disaster Risk Reduction (DRR) measures to mitigate the impact of this event.",qualifier);
		break;
		case "cyclone":
			opening_line = string("A {0} tropical cyclone is about to pass through our country. We need to implement Disaster Risk Reduction (DRR) measures to mitigate the impact of this event.",qualifier);
		break;
	}
	opening_line += " The map shows the cells will be affected by the disaster, as well as what buildings will be damaged (see legend). Use this to plan ahead and implement the best measures."
	array_push(chat,opening_line)

	switch(global.state.role) {
		case ROLE.PRESIDENT:
			array_push(chat,
				"As the President, you need to lead the discussion with your representatives in order to decide which measures to implement. Your associates' suggested implementations will show up on the map.",
				"Your finance minister should report the cost of your planned measures. If there is no finance minister, the budget will automatically update for you.",
				"You need to select measures and place them on the map within the time limit. Good luck!"
			)
		break;
		case ROLE.FINANCE:
			array_push(chat,
				"As the Finance Minister, your job is to take account of all proposed measures and report the cost to the President.",
				"Use the \"Open Calculator\" button to calculate proposed costs!"
			)
		break;
		case ROLE.AGRICULTURE:
			array_push(chat,
				"As the Agricultural Representative, you need to inform the President on the will and the needs of the farmers with regards to the current disaster and future disasters.",
				"Add markers to the map to show where you think certain agricultural measures should be implemented!"
			)
		break;
		case ROLE.CITIZEN:
			array_push(chat,
				"As the Representative of Citizens, you act on behalf of the locals to inform the president of indigenous flood/drought knowledge.",
				"You should be critical of ideas that may disrupt the lifestyle of the local communities.",
				"Add markers to the map to show where you think certain measures should be implemented!"
			)
		break;
		case ROLE.ENGINEER:
			array_push(chat,
				"As the Engineer, your job is to inform the President of the hazard data from your models, in order to best determine which measures to take.",
				"Add markers to the map to show where you think certain engineering projects should be implemented!"
			)
		break;
		case ROLE.FLOOD:
			array_push(chat,
				"As the National Flood Agency Coordinator, your job is to inform the President about national flood risk and work towards preventing future harmful flooding events.",
				"Add markers to the map to show where you think certain flood-resistant measures should be implemented!"
			)
		break;
		case ROLE.HOUSING:
			array_push(chat,
				"As the National Housing and Urban Development Agency Chief, you want to make sure that any damaged houses are quickly and efficiently rebuilt in the aftermath of the event.",
				"Add markers to the map to indicate important spots for rebuilding or relocation projects!"
			)
		break;
		case ROLE.INTERNATIONAL:
			array_push(chat,
				"As the Representative of International Aid and Emergency Responder, your job is to ensure that harm to the affected population is mitigated, and that infrastructural damage is undone.",
				"You should push to meet the goal of reconstructing all hospitals and airports, replanting all crops, and providing aid to impacted population. This ensures a bonus of 5000 coins in the next round from international donors!",
				"Add markers to the map to indicate where you think certain measures should be implemented!"
			)
			if global.state.disaster == "drought" and global.state.disaster_intensity == "low" {
				array_push(chat, "NOTE: As we are currently facing a low-intensity drought, evacuation will not be necessary to secure international aid.")
			}
		break;
	}
	array_push(chat, "(For more information, hover over the [?] icon next to your character.)")
}
else if room == rGameResults {
	array_push(chat, "The last round has finished! Now is the time to reflect on the decisions made during the game and determine what went right and what went wrong.")
	array_push(chat, "Here are some possible discussion points:")
	array_push(chat, "What role-specific challenges did you face and how did you overcome them?")
	array_push(chat, "How did you deal with the budget limitation? Was there enough emphasis placed on long-term solutions?")
	array_push(chat, "Would your strategy have worked better/worse under different circumstances?")
	array_push(chat, "What other multi-hazard interactions can you image that aren't represented in this game, and how could they change the DRR strategy?")
}

chat_surface = surface_create(sprite_width,sprite_height*2)
chat_message = noone

sep = 32
chat_scroll = 0
mouse_on = false

function chat_add(msg) {
	objSidebarGUIChat.chat_scroll = 0
    array_push(objSidebarGUIChat.chat,msg)
}