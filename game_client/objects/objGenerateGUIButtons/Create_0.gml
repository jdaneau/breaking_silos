///define buttons

btn_show_drought_hazard = {
			text : "Show Drought Hazard",
			toggle : true,
			on_click : function(on) {
				if on {
					with objMapGUI { show_drought_hazard = true }
				} else with objMapGUI show_drought_hazard = false
			}	
		}
		
btn_show_flood_hazard = {
			text : "Show Flood Hazard",
			toggle : true,
			on_click : function(on) {
				if on {
					with objMapGUI { show_flood_hazard = true }
				} else with objMapGUI show_flood_hazard = false
			}	
		}
		
btn_show_cyclone_hazard = {
			text : "Show Cyclone Hazard",
			toggle : true,
			on_click : function(on) {
				if on {
					with objMapGUI { show_cyclone_hazard = true }
				} else with objMapGUI show_cyclone_hazard = false
			}	
		}
		
btn_show_population_map = {
			text : "Show Population Map",
			toggle : true,
			on_click : function(on) {
				if on {
					with objMapGUI { show_population = true; layer_caption=string("In thousands (total = {0} million)",get_total_population("millions")) }
				} else with objMapGUI { show_population = false; layer_caption="" }
			}	
		}

btn_show_agricultural_areas = {
			text : "Show Agricultural Areas",
			toggle : true,
			on_click : function(on) {
				if on {
					with objMapGUI { show_agriculture = true; layer_caption="Impacted areas will be removed next round" }
				} else with objMapGUI { show_agriculture = false; layer_caption="" }
			}	
		}
		
btn_end_discussion = {
			text : "End Discussion",
			toggle : false,
			on_click : function(on) {
				with objGUIButton if text=="End Discussion" {
					dialog_mode = "question"
					dialog_status = "end_discussion"
					dialog = show_question_async("Are you sure you want to end the discussion?\nThis will move the game to the next phase.")
				}
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
				}
			}	
		}
		
btn_show_flood_history = {
			text : "Show Flood History",
			toggle : true,
			on_click : function(on) {
				if on {
					with objMapGUI { show_flood_history = true; layer_caption="Observed floods in the past 15 years" }
				} else with objMapGUI { show_flood_history = false; layer_caption="" }
			}	
		}
		
btn_show_drought_history = {
			text : "Show Drought History",
			toggle : true,
			on_click : function(on) {
				if on {
					with objMapGUI { show_drought_history = true; layer_caption="Observed droughts in the past 15 years" }
				} else with objMapGUI { show_drought_history = false; layer_caption="" }
			}	
		}
		
btn_show_watersheds = {
			text : "Show Watersheds",
			toggle : true,
			on_click : function(on) {
				if on {
					with objMapGUI { show_watersheds = true }
				} else with objMapGUI show_watersheds = false
			}	
		}