///define buttons

btn_show_drought_risk = {
			text : "Show Drought Hazard",
			toggle : true,
			on_click : function(on) {
				if on {
					with objMapGUI { show_drought_risk = true; layer_caption = "1 = Low, 2 = Medium, 3 = High" }
					tutorial_popup(room_width/2-200,room_height/2-100,TUTORIAL.LAYER_HAZARD)
				} else with objMapGUI { reset_info_layers() }
			}	
		}
		
btn_show_flood_risk = {
			text : "Show Flood Hazard",
			toggle : true,
			on_click : function(on) {
				if on {
					with objMapGUI { show_flood_risk = true; layer_caption = "1 = Low, 2 = Medium, 3 = High" }
					tutorial_popup(room_width/2-200,room_height/2-100,TUTORIAL.LAYER_HAZARD)
				} else with objMapGUI { reset_info_layers() }
			}	
		}
		
btn_show_cyclone_risk = {
			text : "Show Cyclone Hazard",
			toggle : true,
			on_click : function(on) {
				if on {
					with objMapGUI { show_cyclone_risk = true; layer_caption = "1 = Low, 2 = Medium, 3 = High" }
					tutorial_popup(room_width/2-200,room_height/2-100,TUTORIAL.LAYER_HAZARD)
				} else with objMapGUI { reset_info_layers() }
			}	
		}
		
btn_show_population_map = {
			text : "Show Population Map",
			toggle : true,
			on_click : function(on) {
				if on {
					with objMapGUI { 
						show_population = true; 
						var total_pop = get_total_population("millions");
						layer_caption=string("In thousands (total = {0} million)",total_pop) 
						var pop_diff = total_pop - get_total_population("millions",false)
						if pop_diff != 0 {
							layer_caption += "\nPink values = Evacuated population"	
						}
					}
					tutorial_popup(room_width/2-200,room_height/2-100,TUTORIAL.LAYER_POPULATION)
				} else with objMapGUI { reset_info_layers() }
			}	
		}

btn_show_agricultural_areas = {
			text : "Show Agricultural Areas",
			toggle : true,
			on_click : function(on) {
				if on {
					with objMapGUI { show_agriculture = true; layer_caption="Yellow: Normal crops, Blue: Drought-resistant crops\nRed: Crops destroyed by current disaster" }
					tutorial_popup(room_width/2-200,room_height/2-100,TUTORIAL.LAYER_AGRICULTURE)
				} else with objMapGUI { reset_info_layers() }
			}	
		}
		
btn_finalize_decision = {
	text : "Finalize Decision",
	toggle : false,
	on_click : function(on) {
				open_dialog("Are you sure you want to finalize your decision?\nThis will end the current round.",
					function(option) {
						if option == "Yes" { with objController end_round() }
					}
				)
			}	
		}

btn_open_calculator = {
			text : "Open Calculator",
			toggle : false,
			on_click : function(on) {
				if !instance_exists(objGUICalculator) {
					instance_create_depth(0,0,-100,objGUICalculator)
				} else if !objGUICalculator.open {
					objGUICalculator.open = true
					global.mouse_depth = objGUICalculator.depth
				}
			}	
		}
		
btn_show_flood_history = {
			text : "Show Flood History",
			toggle : true,
			on_click : function(on) {
				if on {
					with objMapGUI { show_flood_history = true; layer_caption="Observed floods in the past 15 years" }
					tutorial_popup(room_width/2-200,room_height/2-100,TUTORIAL.LAYER_HISTORY)
				} else with objMapGUI { reset_info_layers() }
			}	
		}
		
btn_show_drought_history = {
			text : "Show Drought History",
			toggle : true,
			on_click : function(on) {
				if on {
					with objMapGUI { show_drought_history = true; layer_caption="Observed droughts in the past 15 years" }
					tutorial_popup(room_width/2-200,room_height/2-100,TUTORIAL.LAYER_HISTORY)
				} else with objMapGUI { reset_info_layers() }
			}	
		}
		
btn_show_watersheds = {
			text : "Show Watersheds",
			toggle : true,
			on_click : function(on) {
				if on {
					with objMapGUI { show_watersheds = true; layer_caption = "Each watershed belongs to one river system.\nArrows show direction of flow." }
					tutorial_popup(room_width/2-200,room_height/2-100,TUTORIAL.LAYER_WATERSHEDS)
				} else with objMapGUI { reset_info_layers() }
			}	
		}