update = function() {
	var days = global.state.next_disaster.days_since_last_disaster;
	var months = days div 30;
	var years = days div 365;
	if (days >= 30) days = days mod 30;
	if (months >= 12) months = months mod 12;
	if years > 0 {
		if months == 0 {
			text = string("{0} year{1} later...",years,(years > 1 ? "s" : ""))
		}
		else text = string("{0} year{1}, {2} month{3} later...",years,(years > 1 ? "s" : ""),months,(months > 1 ? "s" : ""))	
	}
	else if months > 0 {
		if days == 0 {
			text = string("{0} month{1} later...",months,(months > 1 ? "s" : ""))
		}
		else text = string("{0} month{1}, {2} day{3} later...",months,(months > 1 ? "s" : ""), days, (days > 1 ? "s" : ""))
	}
	else {
		text = string("{0} days later...",days)
	}
}

color = c_white
font = fMyriadBold32