font = fMyriad14
color = c_white
h_align = fa_left
v_align = fa_top

if global.state.disaster == "flood" {
	if global.state.disaster_intensity == "low" {
		text = "The minor flood caused only small damages to crops and infrastructure, but is nothing that couldn't be quickly repaired. This gave you an opportunity to allocate more costs towards longer-term DRR measures. Did you take this opportunity, or did you choose to save for the next round?"
	}
	if global.state.disaster_intensity == "medium" {
		text = "The flood caused major damages to crops and buildings, which will have to be repaired. Without proper evacuation measures, there can also be significant loss of life. Did you do enough to address the flood damages?"
	}
	if global.state.disaster_intensity == "high" {
		text = "The massive flood caused widespread damage to crops and buildings, which will have to be repaired. There is bound to be population loss with such an event, but this could have been mitigated through proper evacuation and prior measures. Were you prepared enough to handle this disaster? How will we recover from it?"
	}
}
if global.state.disaster == "cyclone" {
	if global.state.disaster_intensity == "low" {
		text = "The minor cyclone caused only small damages to crops and infrastructure, but is nothing that couldn't be quickly repaired. This gave you an opportunity to allocate more costs towards longer-term DRR measures. Did you take this opportunity, or did you choose to save for the next round?"
	}
	if global.state.disaster_intensity == "medium" {
		text = "The cyclone caused major damages to crops and buildings, which will have to be repaired. Without proper evacuation measures, there can also be significant loss of life. Did you do enough to address damage caused by the strong winds?"
	}
	if global.state.disaster_intensity == "high" {
		text = "The massive cyclone caused widespread damage to crops and buildings, which will have to be repaired. There is bound to be population loss with such an event, but this could have been mitigated through proper evacuation and prior measures. Were you prepared enough to handle this disaster? How will we recover from it?"
	}
}
if global.state.disaster == "drought" {
	if global.state.disaster_intensity == "low" {
		text = "The minor drought caused only small damages to crops, which will need to be replanted. This gave you an opportunity to allocate more costs towards longer-term DRR measures. Did you take this opportunity, or did you choose to save for the next round?"
	}
	if global.state.disaster_intensity == "medium" {
		text = "The drought caused major crop losses, which will have to be replanted. Without proper evacuation measures, there can also be some loss of life due to starvation, depending on food access. Did you do enough to address the drought's effects, and is there any money left over?"
	}
	if global.state.disaster_intensity == "high" {
		text = "The massive drought caused widespread crop loss, which will all have to be replanted. Without proper evacuation measures, there can also be significant loss of life due to starvataion, depending on food access. Were you prepared enough to handle this disaster? How will we recover from it?"
	}
}