//init globals
global.mouse_depth = 10
global.tutorial_enabled = false
global.ai_messages = []
global.tutorial_queue = []
global.tutorial_seen = []
global.starting_budget = 0

//global constants and enums
enum ROLE {
	PRESIDENT,
	FINANCE,
	INTERNATIONAL,
	AGRICULTURE,
	HOUSING,
	ENGINEER,
	FLOOD,
	CITIZEN,
	NONE
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
	EVACUATE=12,
	FLOOD_BUILDINGS=13,
	CYCLONE_BUILDINGS=14
}
global.N_MEASURES = 15

enum TUTORIAL {
	WELCOME,
	CHARACTER_INFO,
	BUDGET,
	CHAT,
	MAP_CONTROLS,
	MAP_LEGEND,
	MAP_LAYERS,
	PLACE_MEASURES,
	TIME_LIMIT,
	MULTI_HAZARD,
	PROJECT_TIME,
	OPEN_CALCULATOR,
	USE_CALCULATOR,
	COLLABORATION,
	IN_PROGRESS_PROJECTS,
	LAYER_POPULATION,
	LAYER_HAZARD,
	LAYER_WATERSHEDS,
	LAYER_HISTORY,
	LAYER_AGRICULTURE,
	MEASURE_RELOCATE,
	MEASURE_DAM,
	MEASURE_EVACUATE
}

global.colors = {
	//main colors: light blue, purple, magenta
	light_blue : make_color_rgb(55,76,255),
	dark_blue : make_color_rgb(0,0,145),
	purple : make_color_rgb(136,54,234),
	yellow : make_color_rgb(255,206,0),
	magenta : make_color_rgb(219,32,210),
	light_green : make_color_rgb(90,224,154),
	
	light_blue_75 : make_color_rgb(103,113,255),
	light_blue_50 : make_color_rgb(153,160,255),
	light_blue_25 : make_color_rgb(204,208,255),
	
	dark_blue_75 : make_color_rgb(64,64,175),
	dark_blue_50 : make_color_rgb(127,127,201),
	dark_blue_25 : make_color_rgb(191,191,228),
	
	purple_75 : make_color_rgb(167,94,242),
	purple_50 : make_color_rgb(196,147,246),
	purple_25 : make_color_rgb(225,201,251),
	
	yellow_75 : make_color_rgb(255,219,64),
	yellow_50 : make_color_rgb(255,231,127),
	yellow_25 : make_color_rgb(255,243,191),
	
	magenta_75 : make_color_rgb(231,64,224),
	magenta_50 : make_color_rgb(239,127,234),
	magenta_25 : make_color_rgb(247,191,245),
	
	light_green_75 : make_color_rgb(126,233,178),
	light_green_50 : make_color_rgb(169,240,203),
	light_green_25 : make_color_rgb(212,247,229)
}

global.time_limits = {
	discussion: 1200 //20 minutes per round
}

//state of the game
global.state = {
	player_name : "",
	current_round : 1,
	datetime : date_current_datetime(),
	current_phase : "menu",
	seconds_remaining : 0,
	time_remaining : 0, 
	state_budget : 0,
	base_tax : 0,
	starting_population : 0,
	starting_risk : {
		flood : 0,
		drought: 0,
		cyclone: 0
	},
	money_spent : 0,
	role: ROLE.NONE,
	disaster: "",
	disaster_intensity: "",
	multi_hazard: false,
	affected_tiles : [],
	round_reports : [],
	measures_implemented: array_create(global.N_MEASURES, 0),
	next_disaster : {
		disaster: "",
		intensity: "",
		days_since_last_disaster: 0
	},
	aid_objectives : {
		buildings : false,
		hospitals : false,
		airport : false,
		agriculture : false
	},
	n_projects_interrupted : 0,
	n_agriculture_lost : 0,
	n_airports_damaged : 0,
	n_hospitals_damaged : 0,
	n_tiles_damaged : 0,
	current_room : room
}

//roles
global.roles = ds_map_create()
ds_map_add(global.roles, ROLE.PRESIDENT, {
	name:"President",
	description:"The Decision Maker"
})
ds_map_add(global.roles, ROLE.FINANCE, {
	name:"Minister of Finance",
	description:"The Accountant"
})
ds_map_add(global.roles, ROLE.AGRICULTURE, {
	name:"Agricultural Representative",
	description:"Voice of the Farmers"
})
ds_map_add(global.roles, ROLE.CITIZEN, {
	name:"Citizen Representative",
	description:"Voice of the Locals"
})
ds_map_add(global.roles, ROLE.ENGINEER, {
	name:"Engineer",
	description:"Logistics Expert"
})
ds_map_add(global.roles, ROLE.FLOOD, {
	name:"National Flood Coordinator",
	description:"Expert on Flood Prevention"
})
ds_map_add(global.roles, ROLE.HOUSING, {
	name:"National Housing Chief",
	description:"Head of Urban Development"
})
ds_map_add(global.roles, ROLE.INTERNATIONAL, {
	name:"International Aid Representative",
	description:"Head of Emergency Response"
})

//measures that can be taken throughout the game
global.measures = ds_map_create()
ds_map_add(global.measures, MEASURE.HOSPITAL, {
	name:"Reconstruct Hospital", 
	alias:"hospital",
	key: MEASURE.HOSPITAL,
	cost:3000,
	unit:"building",
	time: "months",
	icon: sprMeasure_hospital,
	key_use: "Place on cells with damaged hospitals to repair them",
	description: "As there is only a limited number of hospitals, their reconstruction is a priority. The reconstruction itself is quite time consuming as it requires advanced building techniques and materials."
})
ds_map_add(global.measures, MEASURE.AIRPORT, {
	name:"Reconstruct Airport", 
	alias:"airport",
	key: MEASURE.AIRPORT,
	cost:4000,
	unit:"building",
	time: "weeks",
	icon: sprMeasure_airport,
	key_use: "Place on cells with damaged airports to repair them",
	description: "The reconstruction of the airport does not take a long time. However, it is expensive. Airports are very important to let international aid deliver resources needed after a disaster."
})
ds_map_add(global.measures, MEASURE.BUILDINGS, {
	name:"Reconstruct Buildings", 
	alias:"buildings",
	key: MEASURE.BUILDINGS,
	cost:600,
	unit:"cell",
	time: "weeks",
	icon: sprMeasure_buildings,
	key_use: "Place on cells with damaged buildings (checkerboard patterns on the map) to repair them",
	description: "The buildings are of low quality and can therefore be reconstructed rapidly if money for materials is made available. Reconstruction takes place at the same location."
})
ds_map_add(global.measures, MEASURE.SEAWALL, {
	name:"Build Seawall",
	alias:"seawall",
	key: MEASURE.SEAWALL,
	cost:500,
	unit:"cell",
	time: "weeks",
	icon: sprMeasure_seawall,
	key_use: "Place on coastal cells to add protection against storm surges from cyclones",
	description: "Seawalls are hard engineered structures with a primary function to prevent further erosion of the shoreline. They are built parallel to the shore to aim to hold or prevent sliding of the soil, while providing protection from wave action. Although their primary function is erosion reduction, they have a secondary function as coastal storm surge defences. There are a variety of construction  methods that can be used to create sea wall protection for a coastal city. They are generally expensive to construct."
})
ds_map_add(global.measures, MEASURE.NBS, {
	name:"Nature-based Solutions", 
	alias:"nbs",
	key: MEASURE.NBS,
	cost:200,
	unit:"cell",
	time: "years",
	icon: sprMeasure_nbs,
	key_use: "Place on low-population cells to protect against flooding. Incompatible with agriculture",
	description: "For protection from tropical cyclones, mangroves are especially effective in rural areas where populations are widely spread out, and the construction of long seawalls would not be economically feasible. In contrast, for densely populated coastal areas, mangroves alone will not fully protect all the buildings and people at risk since the reduction of surge height from mangroves may be limited. Moreover, the reduction in flow velocity of the storm surge protects embankments from damages.\n\nFor floods, natural overflow areas can be created to make room for the river, thereby decreasing flood risk."
})
ds_map_add(global.measures, MEASURE.NORMAL_CROPS, {
	name:"Plant Normal Crops", 
	alias:"normal_crops",
	key: MEASURE.NORMAL_CROPS,
	cost:300,
	unit:"cell",
	time: "months",
	icon: sprMeasure_normalcrops,
	key_use: "Place on cells to plant (or re-plant) normal crops",
	description: "The regular crop thrives under your country's normal climatic conditions.\n\nYou cannot have normal crops and drought-resistant crops in the same cell."
})
ds_map_add(global.measures, MEASURE.RESISTANT_CROPS, {
	name:"Plant Drought-resistant Crops", 
	alias:"resistant_crops",
	key: MEASURE.RESISTANT_CROPS,
	cost:500,
	unit:"cell",
	time: "months",
	icon: sprMeasure_resistantcrops,
	key_use: "Place on cells that are especially drought prone to plant (or re-plant) drought-resistant crops",
	description: "When warned about a particularly dry season, farmers can be encouraged to adjust their crops, switching from high to low water-requiring crops. These crops are more sensitive to floods.\n\nYou cannot have normal crops and drought-resistant crops in the same cell."
})
ds_map_add(global.measures, MEASURE.EWS_FLOOD, {
	name:"EWS: Flood", 
	alias:"ews_flood",
	key: MEASURE.EWS_FLOOD,
	cost:1000,
	unit:"cell",
	time: "months",
	icon: sprMeasure_ews_flood,
	key_use: "Place on cells to install a warning system that mitigates damages from floods",
	description: "Early warning systems for floods can be useful in slower-onset floods but are not effective against torrential rains such as those from tropical cyclones. The implementation of a flood early system requires the development of a system that is understood across the board, also by the large number of illiterate people. This involves the training of local communities, which can be a time consuming process. Especially in places with a high illiteracy rate, radio broadcasts play an important role in raising community awareness of approaching floods."
})
ds_map_add(global.measures, MEASURE.EWS_CYCLONE, {
	name:"EWS: Tropical Cyclone",
	alias:"ews_cyclone",
	key: MEASURE.EWS_CYCLONE,
	cost:1000,
	unit:"cell",
	time: "months",
	icon: sprMeasure_ews_cyclone,
	key_use: "Place on cells to install a warning system that mitigates damages from cyclones",
	description: "The implementation of a tropical cyclone (TC) warning system requires the development of a system that is understood by all the different stakeholders, most importantly by the large number of illiterate people. It therefore requires careful training of local communities, which can be a time consuming process. Especially in places with a high illiteracy rate, radio broadcasts play an important role in raising community awareness of approaching TCs. Rather than provide communities with difficult to understand information about wind speeds, each Numerical Category (from 1-5) is related to the type of destruction likely to occur to locally made houses, common crops and trees. One of the main challenges is that a false warning can also lead to scepticism and reluctance of communities to follow up on the warnings."
})
ds_map_add(global.measures, MEASURE.DIKE, {
	name:"Build Dikes", 
	alias:"dike",
	key: MEASURE.DIKE,
	cost:600,
	unit:"cell",
	time: "months",
	icon: sprMeasure_dike,
	key_use: "Place on river-containing cells to install dikes in the area, protecting against floods",
	description: "Dikes are a common flood control measure and can be implemented at a small scale, for part of a river. However, they do take quite some time to build and are relatively expensive."
})
ds_map_add(global.measures, MEASURE.RELOCATION, {
	name:"Relocation Incentive", 
	alias:"relocation",
	key: MEASURE.RELOCATION,
	cost:500,
	unit:"cell",
	time: "years",
	icon: sprMeasure_relocation,
	key_use: "Place this measure on the cell(s) you want to move population AWAY from. Useful for depopulating cells that are especially disaster-prone.",
	description: "The World Bank defines planned population relocation as \"a process whereby a community's housing, assets and public infrastructure are rebuilt in another location.\" This disaster risk reduction measure provides financial incentives to move the targeted community to a new, lower-risk location.\n\nTo implement this measure, put the symbol on the cells from which you wish to move the population. This will create incentives to move 30% of the population from these cells to the rest of the country."
})
ds_map_add(global.measures, MEASURE.DAM, {
	name:"Build Dam", 
	alias:"dam",
	key: MEASURE.DAM,
	cost:10000,
	unit:"cell",
	time: "years",
	icon: sprMeasure_dam,
	key_use: "Place on a river-containing cell where you want to construct a dam. Protects itself and five downstream cells against floods",
	description: "Dams can be very useful in mitigating flood impacts and can be used as a reservoir during drought periods. They can, however, also lead to lower water availability downstream and therefore increase drought impacts. Dams will affect the cell you build them on, as well as five cells downstream. Only one dam can be built per watershed."
})
ds_map_add(global.measures, MEASURE.EVACUATE, {
	name:"Evacuate Impacted Population", 
	alias:"evacuate",
	key: MEASURE.EVACUATE,
	cost:200,
	unit:"cell",
	time: "instant",
	icon: sprMeasure_evacuate,
	key_use: "Reduces population loss during a disaster. Place on the cell(s) you want the population to evacuate to - this is where the temporary shelters will be built.",
	description: "Rapid emergency evacuation to temporary shelters is very important to provide immediate relief for population affected by a disaster. These facilities provide a safe access to water, toilets, communal kitchens, medicine and basic shelter. This measure is not preventative and is not sufficient in the long term in cases where people need to be relocated out of high risk areas.\n\nTo implement this measure, place the icon in the cells where you want to move the impacted population to."
})
ds_map_add(global.measures, MEASURE.FLOOD_BUILDINGS, {
	name:"Buildings Upgrade: Flood Resistance", 
	alias:"flood_buildings",
	key: MEASURE.FLOOD_BUILDINGS,
	cost:1200,
	unit:"cell",
	time: "months",
	icon: sprMeasure_floodbuildings,
	key_use: "Place on cells that have damaged or un-upgraded buildings to repair and make them more flood resistant",
	description: "Building Back Better (BBB) is a strategy that aims to reduce future risk of damage following a hazard event. Flood-proofing can be achieved through elevation of structures above the flood line, using flood-resistant building materials, and making drainage systems more efficient.\n\nThis measure can be placed on both damaged or undamaged cells. Future floods will no longer damage the buildings on this cell."
})
ds_map_add(global.measures, MEASURE.CYCLONE_BUILDINGS, {
	name:"Buildings Upgrade: Cyclone Resistance", 
	alias:"cyclone_buildings",
	key: MEASURE.CYCLONE_BUILDINGS,
	cost:1200,
	unit:"cell",
	time: "months",
	icon: sprMeasure_cyclonebuildings,
	key_use: "Place on cells that have damaged or un-upgraded buildings to repair and make them more cyclone resistant",
	description: "Building Back Better (BBB) is a strategy that aims to reduce future risk of damage following a hazard event. Cyclone-proofing can be achieved through wind-resistant roof designs, using strong and durable building materials, and reinforcing infrastructure (such as streetlamps and poles) in the area.\n\nThis measure can be placed on both damaged or undamaged cells. Future cyclones will no longer damage the buildings on this cell."
})

global.ai_messages = []

//used by the text objects in the roundresults screen
global.state.n_tiles_damaged = 0
global.state.n_hospitals_damaged = 0
global.state.n_agriculture_lost = 0
global.state.n_airports_damaged = 0
global.state.n_projects_interrupted = 0