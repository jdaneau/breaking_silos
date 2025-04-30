///same as create

image_speed=0

scale=1
max_w = 432
sep = 20
text = []

draw_set_font(fMyriad14)

switch global.state.role {
	case ROLE.PRESIDENT:
		array_push(text, "As the President, you:")
		array_push(text, " - chair the meetings, delegate tasks to anyone in the team and make the final decision")
		array_push(text, " - have access to all measure types, and can thus place or remove all of them")
		array_push(text, " - are currently ruling during a stable political situation but tensions continue to exist with the opposition, and elections are on the horizon")
		array_push(text, " - focus on ensuring a strong national economy, realizing that it depends on both the small wealthy segment of society as well as the large agricultural sector")
		array_push(text, " - are not necessarily interested in spending money to increase future resilience, but you are willing to implement any measures that would have a positive impact on the economy in the short term")
		if role_in_game(ROLE.AGRICULTURE)
			array_push(text, " - are close friends with the agricultural representative and therefore strongly influenced by suggestions made by them")
		if role_in_game(ROLE.FINANCE)
			array_push(text, " - need to make sure your minister of finance is taking account of expenses")
	break;
	case ROLE.FINANCE:
		array_push(text, "As the Minister of Finance, you:")
		array_push(text, " - are in charge of the budget during the game")
		array_push(text, " - are responsible for the calculations of the total costs of the to-be-implemented disaster reduction measures (using the calculator tool)")
		array_push(text, " - know that the budget will be increased on Jan 1 of each year from taxes (higher population/gdp = more tax income)")
		array_push(text, " - want to save money for future rounds incase they happen before tax can be collected")
		array_push(text, " - generally agree with the president until they are spending too much")
	break;
	case ROLE.AGRICULTURE:
		array_push(text, "As the Agricultural Representative, you:")
		array_push(text, " - focus on short term to minimize impacts on the agriculture sector")
		array_push(text, string(" - need to make sure that there are at least {0} cells with crops to maintain the country's food security (note that this number can change if there are large shifts in population numbers)",string(get_minimum_agriculture())))
		array_push(text, " - want to exploit the nation's land as much as possible for production, even if it might not be arable in its natural state")
		array_push(text, " - like the idea of those drought-resistant crops to secure enough food but also realize that distributing such crops can be expensive")
		array_push(text, " - have experienced negative impacts on crops due to dam-induced droughts so you don't want new dams to be constructed")
		array_push(text, " - are good friends with the president, so you can convince the president easily of your ideas")
	break;
	case ROLE.CITIZEN:
		array_push(text, "As the Representative of Citizens, you:")
		array_push(text, " - have indigenous knowledge about flood and drought prone areas, which can be different from the official hazard maps")
		array_push(text, " - care more about protecting the capital, as that is where you live")
		array_push(text, " - are against the idea of moving to a lower risk area as communities are familiar with their current location and have lived there for a long time")
		array_push(text, " - are against the construction of dams as they create droughts downstream")
		array_push(text, " - advocate for nature-based solutions rather than artificial solutions")
		array_push(text, " - support the opposition party so you are critical of the president")
	break;
	case ROLE.ENGINEER:
		array_push(text, "As the Engineer, you:")
		array_push(text, " - have knowledge of the watersheds and river flow patterns of the country, and want to push for installing a dam for long-term flood protection")
		array_push(text, " - know the movement patterns of tropical cyclones and can accurately predict where they are most likely to hit")
		array_push(text, " - highly trust the official flood/drought hazard maps and think the decision makers should base their decisions on these rather than on indigenous knowledge")
		if role_in_game(ROLE.CITIZEN)
			array_push(text, " - do not value the input of the citizen representative")
	break;
	case ROLE.FLOOD:
		array_push(text, "As the National Flood Agency Coordinator, you:")
		array_push(text, " - have detailed flood and drought hazard maps created from the best models")
		array_push(text, " - want to focus on long term disaster risk reduction (DRR) measures, irrespective of the costs")
		array_push(text, " - are a long time public servant, seen as a trusted public figure by the ruling party")
		if role_in_game(ROLE.ENGINEER)
			array_push(text, " - closely collaborate with the engineer and generally agree with them")
	break;
	case ROLE.HOUSING:
		array_push(text, "As the National Housing and Urban Development Agency Chief, you:")
		array_push(text, " - focus on medium term measures, as due to population growth, there is a big need for urban expansion")
		array_push(text, " - want to reconstruct buildings right away, quickly and cheaply, rather than focusing on the quality of the housing")
		array_push(text, " - think it is better in the long-term for citizens to relocate to less-population regions, and want to initiate relocation incentives")
		array_push(text, " - are paid directly by the president's administration so you generally agree with the president")
		array_push(text, " - are new to the position and therefore are eager to prove your value to the president")
	break;
	case ROLE.INTERNATIONAL:
		array_push(text, "As the Representative of International Aid and Emergency Responder, you:") 
		array_push(text, " - focus on getting people out of harm's way")
		array_push(text, " - are paid by international donors, so you feel comfortable being critical of the president")
		array_push(text, " - know that if a round is ended by taking measures that address all damages to hospitals, crops, airports and population (either by evacuating them or by reconstructing buildings), the country will receive 5000 coins from international donors to further improve its resilience efforts")
		array_push(text, string(" - also want to make sure there are enough crops to maintain food security (at least {0} cells), this can be any type of crop",string(get_minimum_agriculture())))
		if role_in_game(ROLE.CITIZEN)
			array_push(text, " - value the indigenous knowledge of the citizen representative")
	break;
}

w=0
h=0
mouse_on = false

max_h=32
for(var i=0; i<array_length(text); i++) {
	max_h += string_height_ext(text[i],sep,max_w)
	if i > 0 { max_h += sep }
}

surface_free(surf)
surf = surface_create(max_w,max_h)