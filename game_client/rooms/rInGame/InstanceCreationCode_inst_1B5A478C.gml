text = string("National Budget: {0}",global.state.state_budget)
update = function() {
	if !role_in_game(ROLE.FINANCE) {
		text = string("National Budget: {0}",global.state.state_budget)
	}
}
h_align = fa_left