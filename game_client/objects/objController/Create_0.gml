//global constants and enums

enum ROLE {
	PRESIDENT,
	FINANCE,
	INTERNATIONAL,
	AGRICULTURE,
	HOUSING,
	ENGINEER,
	FLOOD,
	CITIZEN
}

enum MEASURE {
	HOSPITAL=0,
	AIRPORT=1,
	BUILDINGS=2,
	SEAWALL=3,
	NBS=4,
	NORMAL_CROPS=5,
	RESISTANT_CROPS=6,
	EWS_FLOOD=7,
	EWS_CYCLONE=8,
	DIKE=9,
	RELOCATION=10,
	DAM=11,
	EVACUATE=12
}

global.colors = {
	myriad_light_blue : make_color_rgb(55,76,255),
	myriad_dark_blue : make_color_rgb(0,0,145),
	myriad_purple : make_color_rgb(136,54,234),
	myriad_yellow : make_color_rgb(255,206,0),
	myriad_magenta : make_color_rgb(219,32,210),
	myriad_light_green : make_color_rgb(90,224,154)
	//main colors: light blue, purple, magenta
}

//state of the game
global.state = {
	player_name : "Player1",
	current_round : 1,
	state_budget : 30000,
	role: ROLE.AGRICULTURE,
	disaster: "flood",
	disaster_intensity: "high",
	affected_tiles : []
}

//roles
global.roles = ds_map_create()
ds_map_add(global.roles, ROLE.PRESIDENT, {
	name:"President"	
})
ds_map_add(global.roles, ROLE.FINANCE, {
	name:"Minister of Finance"	
})
ds_map_add(global.roles, ROLE.AGRICULTURE, {
	name:"Agricultural Representative"	
})
ds_map_add(global.roles, ROLE.CITIZEN, {
	name:"Citizen Representative"	
})
ds_map_add(global.roles, ROLE.ENGINEER, {
	name:"Engineer"	
})
ds_map_add(global.roles, ROLE.FLOOD, {
	name:"National Flood Coordinator"	
})
ds_map_add(global.roles, ROLE.HOUSING, {
	name:"National Housing Chief"	
})
ds_map_add(global.roles, ROLE.INTERNATIONAL, {
	name:"International Aid Representative"	
})
role_ids = ds_map_keys_to_array(global.roles)
role_id_index = array_find_index(role_ids,function(_value,_index){return _value == global.state.role})

//measures that can be taken throughout the game
global.measures = ds_map_create()
ds_map_add(global.measures, MEASURE.HOSPITAL, {
	name:"Reconstruct Hospital", 
	cost:3000,
	unit:"/building",
	min_cell: 1,
	time: "medium"
})
ds_map_add(global.measures, MEASURE.AIRPORT, {
	name:"Reconstruct Airport", 
	cost:4000,
	unit:"/building",
	min_cell: 1,
	time: "short"
})
ds_map_add(global.measures, MEASURE.BUILDINGS, {
	name:"Reconstruct Buildings", 
	cost:600,
	unit:"/cell",
	min_cell: 1,
	time: "short"
})
ds_map_add(global.measures, MEASURE.SEAWALL, {
	name:"Build Seawall", 
	cost:500,
	unit:"/cell",
	min_cell: 1,
	time: "short"
})
ds_map_add(global.measures, MEASURE.NBS, {
	name:"Nature-based Solutions", 
	cost:200,
	unit:"/cell",
	min_cell: 1,
	time: "long"
})
ds_map_add(global.measures, MEASURE.NORMAL_CROPS, {
	name:"Plant Normal Crops", 
	cost:300,
	unit:"/cell",
	min_cell: 1,
	time: "medium"
})
ds_map_add(global.measures, MEASURE.RESISTANT_CROPS, {
	name:"Plant Drought-resistant Crops", 
	cost:500,
	unit:"/cell",
	min_cell: 1,
	time: "medium"
})
ds_map_add(global.measures, MEASURE.EWS_FLOOD, {
	name:"EWS: Flood", 
	cost:1000,
	unit:"/cell",
	min_cell: 4,
	time: "medium"
})
ds_map_add(global.measures, MEASURE.EWS_CYCLONE, {
	name:"EWS: Tropical Cyclone", 
	cost:1000,
	unit:"/cell",
	min_cell: 1,
	time: "medium"
})
ds_map_add(global.measures, MEASURE.DIKE, {
	name:"Build Dikes", 
	cost:600,
	unit:"/cell",
	min_cell: 1,
	time: "medium"
})
ds_map_add(global.measures, MEASURE.RELOCATION, {
	name:"Relocation Incentive", 
	cost:500,
	unit:"/cell",
	min_cell: 1,
	time: "long"
})
ds_map_add(global.measures, MEASURE.DAM, {
	name:"Build Dam", 
	cost:10000,
	unit:"/cell",
	min_cell: 1,
	time: "long"
})
ds_map_add(global.measures, MEASURE.EVACUATE, {
	name:"Evacuate Impacted Population", 
	cost:200,
	unit:"/cell",
	min_cell: 1,
	time: "short"
})