h_align = fa_left
font = fMyriadBold18

text = string(global.state.money_spent) + " coins"
color = c_white

update = function() {
	text = string(global.state.money_spent) + " coins"
}