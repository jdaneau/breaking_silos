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
	current_phase : "menu",
	time_remaining : game_get_speed(gamespeed_fps) * 600, 
	seconds_remaining : 600,
	state_budget : 30000,
	role: ROLE.AGRICULTURE,
	disaster: "flood",
	disaster_intensity: "high",
	affected_tiles : ["E6","F6","G6","F7","G7","H6","G8"]
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
	alias:"hospital",
	key: MEASURE.HOSPITAL,
	cost:3000,
	unit:"/building",
	min_cell: 1,
	time: "months",
	icon: sprMeasure_hospital,
	description: "As there is only a limited number of hospitals, their reconstruction is a priority. The reconstruction itself is quite time consuming as it requires advanced building techniques and materials."
})
ds_map_add(global.measures, MEASURE.AIRPORT, {
	name:"Reconstruct Airport", 
	alias:"airport",
	key: MEASURE.AIRPORT,
	cost:4000,
	unit:"/building",
	min_cell: 1,
	time: "weeks",
	icon: sprMeasure_airport,
	description: "The reconstruction of the airport does not take a long time. However, it is expensive. Airports are very important to let international aid deliver resources needed after a disaster."
})
ds_map_add(global.measures, MEASURE.BUILDINGS, {
	name:"Reconstruct Buildings", 
	alias:"buildings",
	key: MEASURE.BUILDINGS,
	cost:600,
	unit:"/cell",
	min_cell: 1,
	time: "weeks",
	icon: sprMeasure_buildings,
	description: "The buildings are of low quality and can therefore be reconstructed rapidly if money for materials is made available. Reconstruction takes place at the same location."
})
ds_map_add(global.measures, MEASURE.SEAWALL, {
	name:"Build Seawall",
	alias:"seawall",
	key: MEASURE.SEAWALL,
	cost:500,
	unit:"/cell",
	min_cell: 1,
	time: "weeks",
	icon: sprMeasure_seawall,
	description: "Seawalls are hard engineered structures with a primary function to prevent further erosion of the shoreline. They are built parallel to the shore to aim to hold or prevent sliding of the soil, while providing protection from wave action. Although their primary function is erosion reduction, they have a secondary function as coastal storm surge defences. There are a variety of construction  methods that can be used to create sea wall protection for a coastal city. They are generally expensive to construct."
})
ds_map_add(global.measures, MEASURE.NBS, {
	name:"Nature-based Solutions", 
	alias:"nbs",
	key: MEASURE.NBS,
	cost:200,
	unit:"/cell",
	min_cell: 1,
	time: "years",
	icon: sprMeasure_nbs,
	description: "For protection from tropical cyclones, mangroves are especially effective in rural areas where populations are widely spread out, and the construction of long seawalls would not be economically feasible. In contrast, for densely populated coastal areas, mangroves alone will not fully protect all the buildings and people at risk since the reduction of surge height from mangroves may be limited. Moreover, the reduction in flow velocity of the storm surge protects embankments from damages.\n\nFor floods, natural overflor areas can be created to make room for the river, thereby decreasing flood risk."
})
ds_map_add(global.measures, MEASURE.NORMAL_CROPS, {
	name:"Plant Normal Crops", 
	alias:"normal_crops",
	key: MEASURE.NORMAL_CROPS,
	cost:300,
	unit:"/cell",
	min_cell: 1,
	time: "months",
	icon: sprMeasure_normalcrops,
	description: "The regular crop thrives under your country's normal climatic conditions.\n\nYou cannot have normal crops and drought-resistant crops in the same cell."
})
ds_map_add(global.measures, MEASURE.RESISTANT_CROPS, {
	name:"Plant Drought-resistant Crops", 
	alias:"resistant_crops",
	key: MEASURE.RESISTANT_CROPS,
	cost:500,
	unit:"/cell",
	min_cell: 1,
	time: "months",
	icon: sprMeasure_resistantcrops,
	description: "When warned about a particularly dry season, farmers can be encouraged to adjust their crops, switching from high to low water-requiring crops. These crops are more sensitive to floods.\n\nYou cannot have normal crops and drought-resistant crops in the same cell."
})
ds_map_add(global.measures, MEASURE.EWS_FLOOD, {
	name:"EWS: Flood", 
	alias:"ews_flood",
	key: MEASURE.EWS_FLOOD,
	cost:1000,
	unit:"/cell",
	min_cell: 4,
	time: "months",
	icon: sprMeasure_ews_flood,
	description: "Early warning systems for floods can be useful in slower-onset floods but are not effective against torrential rains such as those from tropical cyclones. The implementation of a flood early system requires the development of a system that is understood across the board, also by the large number of illiterate people. This involves the training of local communities, which can be a time consuming process. Especially in places with a high illiteracy rate, radio broadcasts play an important role in raising community awareness of approaching floods."
})
ds_map_add(global.measures, MEASURE.EWS_CYCLONE, {
	name:"EWS: Tropical Cyclone",
	alias:"ews_cyclone",
	key: MEASURE.EWS_CYCLONE,
	cost:1000,
	unit:"/cell",
	min_cell: 4,
	time: "months",
	icon: sprMeasure_ews_cyclone,
	description: "The implementation of a tropical cyclone (TC) warning system requires the development of a system that is understood by all the different stakeholders, most importantly by the large number of illiterate people. It therefore requires careful training of local communities, which can be a time consuming process. Especially in places with a high illiteracy rate, radio broadcasts play an important role in raising community awareness of approaching TCs. Rather than provide communities with difficult to understand information about wind speeds, each Numerical Category (from 1-5) is related to the type of destruction likely to occur to locally made houses, common crops and trees. One of the main challenges is that a false warning can also lead to scepticism and reluctance of communities to follow up on the warnings."
})
ds_map_add(global.measures, MEASURE.DIKE, {
	name:"Build Dikes", 
	alias:"dike",
	key: MEASURE.DIKE,
	cost:600,
	unit:"/cell",
	min_cell: 1,
	time: "months",
	icon: sprMeasure_dike,
	description: "Dikes are a common flood control measure and can be implemented at a small scale, for part of a river. However, they do take quite some time to build and are relatively expensive."
})
ds_map_add(global.measures, MEASURE.RELOCATION, {
	name:"Relocation Incentive", 
	alias:"relocation",
	key: MEASURE.RELOCATION,
	cost:500,
	unit:"/cell",
	min_cell: 1,
	time: "years",
	icon: sprMeasure_relocation,
	description: "The World Bank defines planned population relocation as \"a process whereby a community's housing, assets and public infrastructure are rebuilt in another location.\" This disaster risk reduction measure provides financial incentives to move the targeted community to a new, lower-risk location.\n\nTo implement this measure, put the symbol on the cells from which you wish to move the population from. This will create incentives to move 30% of the population from these cells to the rest of the country."
})
ds_map_add(global.measures, MEASURE.DAM, {
	name:"Build Dam", 
	alias:"dam",
	key: MEASURE.DAM,
	cost:10000,
	unit:"/cell",
	min_cell: 1,
	time: "years",
	icon: sprMeasure_dam,
	description: "Dams can be very useful in mitigating flood impacts and can be used as a reservoir during drought periods. They can, however, also lead to lower water availability downstream and therefore increase drought impacts."
})
ds_map_add(global.measures, MEASURE.EVACUATE, {
	name:"Evacuate Impacted Population", 
	alias:"evacuate",
	key: MEASURE.EVACUATE,
	cost:200,
	unit:"/cell",
	min_cell: 1,
	time: "weeks",
	icon: sprMeasure_evacuate,
	description: "Rapid emergency evacuation to temporary shelters is very important to provide immediate relief for population affected by a disaster. These facilities provide a safe access to water, toilets, communal kitchens, medicine and basic shelter. This measure is not preventative and is not sufficient in the long term in cases where people need to be relocated out of high risk areas.\n\nTo implement this measure, place the icon in the cells where you want to move the impacted population to."
})