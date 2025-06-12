function tutorial_popup(_x,_y,tutorial_id){
	if !global.tutorial_enabled or tutorial_seen(tutorial_id) {
		return
	}
	var tut = create(_x,_y,objTutorialPopup,-149);
	global.mouse_depth = -149
	switch(tutorial_id) {
		case TUTORIAL.WELCOME:
			tut.text = "Welcome to Bridging the Silos! In this short tutorial I'll walk you through the basic components of the game. If you have any uncertainties during play, feel free to consult the manual linked to by the \"How to play\" button on the title screen. I hope you enjoy playing the game!"
		break;
		case TUTORIAL.CHARACTER_INFO:
			tut.text = "First, to get acquainted with your character and your role in the game, you should hover over the question mark box next to your character portrait. This will give some context on what you should focus on during the game's discussion!"
		break;
		case TUTORIAL.BUDGET:
			tut.text = "The national budget represents the amount of money available to spend on projects. This can be replenished in future rounds via tax income or international aid funding. Note that tax income is only applied when the in-game calendar passes a new year. If not enough time passes between hazards, then you won't have any tax money for the next round! Spend your money carefully :)"
		break;
		case TUTORIAL.CHAT:
			tut.text = "The chat window contains a short briefing summary, and can be used for text communication between players. You can scroll the chat up/down with the mouse wheel, and send a chat message to the rest of the players using the text area on the bottom."
		break;
		case TUTORIAL.MAP_CONTROLS:
			tut.text = "In the centre of the screen is a map of the country. Here you can see where the hospitals, airports, shorelines, and damaged areas are located. Hovering your mouse over a cell will display its coordinates. To pan the map, use the mouse's left click button. To zoom in/out, scroll the mouse wheel while hovering over the map, or use the zoom controls in the corner. Right clicking a cell will highlight it for other players, allowing for quick spatial communication."
		break;
		case TUTORIAL.MAP_LEGEND:
			tut.text = "Hovering over this arrow tab will display the map legend. This will illustrate the meaning behind all the symbols you can see on the map."
		break;
		case TUTORIAL.MAP_LAYERS:
			tut.text = "With these buttons on the bottom, you can toggle different info layers for the map. These layers will give you crucial information for deciding on where to place your measures! Note that not all roles have access to the same information. Communication is key!"
		break;
		case TUTORIAL.PLACE_MEASURES:
			tut.text = "The icons on the right-hand side of the screen are the measures you can implement. The President is the only role with access to all the measures. Hover over an icon to view information about that measure, including price, implementation time, use cases and restrictions. To select a measure, left click the icon and a square will appear around it. Left click a selected measure to deselect it. Once a measure icon is selected, that measure can be placed on the map by left clicking a cell. Right clicking a cell that already has the selected measure will remove it."
		break;
		case TUTORIAL.TIME_LIMIT:
			tut.text = "Take note of the time limit in the top right! Once the time is up, the discussion is over and no more action can be taken."
		break;
		case TUTORIAL.MULTI_HAZARD:
			tut.text = "One thing to keep in mind: sometimes a multi-hazard scenario can occur, where the next hazard occurs only days after the first. This happens most often with flooding following a tropical cyclone. Be aware of this interaction and always keep some money leftover, and try to meet the requirements for international aid!"
		break;
		case TUTORIAL.PROJECT_TIME:
			tut.text = "Nice, you just placed a measure! Note that every measure has a cost and must fit within the budget. Measures also have an implementation time, which varies from weeks to years. Because of this, most measures may not be fully implemented by the next round. A lot of them are pretty long-term and the next hazard may strike sooner!"
		break;
		case TUTORIAL.OPEN_CALCULATOR:
			tut.text = "As the Minister of Finance, you have the unique job of keeping track of expenses. Click the \"Open Calculator\" button to take a look at the calculator tool."
		break;
		case TUTORIAL.USE_CALCULATOR:
			tut.text = "Here, every measure is listed out along with its price. Click the '+' button to add to the tally count for that measure, and '-' to subtract one. Make sure you're accurately keeping track of the current cost! Note that you can freely close the calculator and retain the tallies."
		break;
		case TUTORIAL.COLLABORATION:
			tut.text = "Remember that collaboration and communication is key! Not everyone has access to the same information as you, so you need to ensure that the President is fully informed when they make their final decision. And try to convince others of your character's cause! This is the last tutorial popup for now, though you may see some more as you play the game. Good luck!"
		break;
		case TUTORIAL.IN_PROGRESS_PROJECTS:
			tut.text = "This cell has a measure on it that is either complete or in-progress, as indicated by the white plus-shaped icon in the corner. Hovering over will tell you what these measures are, which will help you remember where everything is!"
		break;
		case TUTORIAL.LAYER_POPULATION:
			tut.text = "The population layer shows how many people live in each cell, by the thousand. Most people live around the capital region. You may want to prioritise these densely-populated areas as they have high population exposure!"
		break;
		case TUTORIAL.LAYER_HAZARD:
			tut.text = "Here you can see the probability of a given hazard for each cell. It can range from 0 (never) to 3 (likely) or even higher depending on what you do. Areas with high hazard probability should be protected!"
		break;
		case TUTORIAL.LAYER_WATERSHEDS:
			tut.text = "Watershed areas show the reach of each river system, along with its direction of flow. When placing dams, the downstream tiles will have their flood chance lowered and flood damage in general will be reduced. You can only build one dam per river system!"
		break;
		case TUTORIAL.LAYER_HISTORY:
			tut.text = "Flood and drought history represents the indigenous knowledge of the citizens living in the country. These are not official maps, but signify areas that people (and thus voters) believe are hazard-prone and should be protected. You may want to convince the President to protect these areas first."
		break;
		case TUTORIAL.LAYER_AGRICULTURE:
			tut.text = "Agricultural areas are cells that have crops planted in them. To keep the country fed, the number of agricultural cells should never be allowed to decrease. As such, if you see any destroyed agriculture, you should point out that these areas need to be replanted!"
		break;
		case TUTORIAL.MEASURE_RELOCATE:
			tut.text = "When placing the relocate population measure, you need to put it on the source cell from which you want the population to migrate. The destination cells are randomly chosen based on general appeal of the movers. They will tend not to move into cells that are damaged or have low hospital/airport access."
		break;
		case TUTORIAL.MEASURE_DAM:
			tut.text = "Dams are expensive and long-term projects, so make sure you are placing them in a good spot! Only one dam can exist per watershed. In the game, cells that are downstream from a dam will have much lower flood risk, though they may have a slightly higher drought risk."
		break;
		case TUTORIAL.MEASURE_EVACUATE:
			tut.text = "To evacuate population, place this measure on a cell where you wish to construct temporary shelters. Evacuated population will be removed from all the affected cells to this cell. For effective evacuation, you should evacuate to as many cells as were affected by the hazard."
		break;
	}
	array_push(global.tutorial_seen,tutorial_id)
}

function tutorial_seen(tutorial_id) {
	return array_contains(global.tutorial_seen, tutorial_id)	
}