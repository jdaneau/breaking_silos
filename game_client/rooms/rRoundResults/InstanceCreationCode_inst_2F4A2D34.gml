update = function() {
	var amount = global.state.next_disaster.days_since_last_disaster;
	var unit = "day"
	if amount >= 30 and amount < 365 { amount /= 30; unit="month" }
	else if amount >= 365 { amount /= 365; unit="year" }
	amount = round(amount)
	text = string("{0} {1}{2} later...",amount,unit,(amount > 1 ? "s" : ""))	
}

color = c_white
font = fHeader