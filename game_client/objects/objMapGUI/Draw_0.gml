if room != home_room  { exit }
if !surface_exists(map_surface) map_surface = surface_create(global.map.width,global.map.height)

var i;

//draw map surface
surface_set_target(map_surface)
draw_set_color(make_color_rgb(127,140,255)) //lighter version of myriad_light_blue for the water
draw_rectangle(0,0,global.map.width,global.map.height,false)
draw_set_color(c_white)
var land_sprite;
var damaged_sprite;
switch(objOnline.lobby_settings.climate_type) {
	case "Tropical":
		land_sprite = sprMapTileTropical;
		damaged_sprite = sprMapTileTropicalDamaged;
	break;
	case "Temperate":
		land_sprite = sprMapTile;
		damaged_sprite = sprMapTileDamaged;
	break;
	case "Boreal":
		land_sprite = sprMapTileBoreal;
		damaged_sprite = sprMapTileBorealDamaged;
	break;
}
for(i=0; i<array_length(global.map.land_tiles); i++) {
	var _tile = global.map.land_tiles[i];
	var _sprite = is_damaged(_tile, global.map.buildings_grid) ? damaged_sprite : land_sprite;
	draw_sprite(_sprite,_tile.index,_tile.x,_tile.y)
	if _tile.capital {
		draw_sprite_ext(sprCapitalMarker,0,_tile.x,_tile.y,1,1,0,c_white,0.3)	
	}
}
for(i=0; i<array_length(global.map.foreign_tiles); i++) {
	var _tile = global.map.foreign_tiles[i];
	draw_sprite(sprForeignTile,_tile.index,_tile.x,_tile.y)
}	
for(i=0; i<array_length(global.map.river_tiles); i++) {
	var _river = global.map.river_tiles[i];
	draw_sprite(_river.spr,0,_river.x,_river.y)
}

//draw extra information layers
for(i=0; i<array_length(global.map.land_tiles); i++) {
	var _tile = global.map.land_tiles[i];
	var _x1 = _tile.x;
	var _y1 = _tile.y;
	var _x2 = _tile.x + 63;
	var _y2 = _tile.y + 63;
	if show_agriculture and _tile.metrics.agriculture != 0 {
		draw_set_alpha(0.4)
		var _draw_color = c_white;
		if _tile.metrics.agriculture == 1 //normal crops
			_draw_color = c_yellow
		else if _tile.metrics.agriculture == 2 //drought resistant crops
			_draw_color = c_blue
		else if _tile.metrics.agriculture == -1 //destroyed crops
			_draw_color = c_red
		draw_color_rectangle(_x1,_y1,_x2,_y2,_draw_color,false)
		draw_set_alpha(1)
	}
	if show_flood_history and _tile.metrics.observed_flood {
		draw_set_alpha(0.4)
		draw_color_rectangle(_x1,_y1,_x2,_y2,c_blue,false)
		draw_set_alpha(1)
	}
	if show_drought_history and _tile.metrics.observed_drought {
		draw_set_alpha(0.4)
		draw_color_rectangle(_x1,_y1,_x2,_y2,c_red,false)
		draw_set_alpha(1)
	}
	if show_drought_risk {
		var _hazard = _tile.metrics.drought_risk;
		if _hazard == 0 { draw_set_alpha(0) }
		if _hazard == 1 { draw_set_alpha(0.2) }
		else if _hazard == 2 { draw_set_alpha(0.35) }
		else if _hazard == 3 { draw_set_alpha(0.5) }
		draw_color_rectangle(_x1,_y1,_x2,_y2,c_red,false)
		draw_set_alpha(1)
		draw_set_font(fSidebar)
		draw_set_halign(fa_center)
		draw_set_valign(fa_middle)
		draw_set_color(c_black)
		draw_text(_x1+32,_y1+32,string(_hazard))
		draw_set_color(c_white)
	}
	if show_flood_risk {
		var _hazard = _tile.metrics.flood_risk;
		if _hazard == 0 { draw_set_alpha(0) }
		if _hazard == 1 { draw_set_alpha(0.2) }
		else if _hazard == 2 { draw_set_alpha(0.35) }
		else if _hazard == 3 { draw_set_alpha(0.5) }
		draw_color_rectangle(_x1,_y1,_x2,_y2,c_blue,false)
		draw_set_alpha(1)
		draw_set_font(fSidebar)
		draw_set_halign(fa_center)
		draw_set_valign(fa_middle)
		draw_set_color(c_black)
		draw_text(_x1+32,_y1+32,string(_hazard))
		draw_set_color(c_white)
	}
	if show_cyclone_risk {
		var _hazard = _tile.metrics.cyclone_risk;
		if _hazard == 0 { draw_set_alpha(0) }
		if _hazard == 1 { draw_set_alpha(0.2) }
		else if _hazard == 2 { draw_set_alpha(0.35) }
		else if _hazard == 3 { draw_set_alpha(0.5) }
		draw_color_rectangle(_x1,_y1,_x2,_y2,c_purple,false)
		draw_set_alpha(1)
		draw_set_font(fSidebar)
		draw_set_halign(fa_center)
		draw_set_valign(fa_middle)
		draw_set_color(c_black)
		draw_text(_x1+32,_y1+32,string(_hazard))
		draw_set_color(c_white)
	}
	if show_population {
		var _pop = get_population(_tile)
		var _evacuated_pop = 0;
		for(var _i=0; _i<array_length(_tile.evacuated_population); _i++) {
			_evacuated_pop += _tile.evacuated_population[_i].population
		}
		var _sat = (_pop/1000)*255;
		var _draw_color = make_color_hsv(color_get_hue(c_maroon),_sat,255);
		draw_set_alpha(0.4)
		draw_color_rectangle(_x1,_y1,_x2,_y2,_draw_color,false)
		draw_set_alpha(1)
		draw_set_font(fSidebarBold)
		draw_set_halign(fa_center)
		draw_set_valign(fa_middle)
		draw_set_color(c_dkgray)
		if _evacuated_pop == 0 {
			draw_text(_x1+32,_y1+32,string(round(_pop)))
		} else {
			draw_text(_x1+32,_y1+16,string(round(_pop)))
			draw_set_color(c_yellow)
			draw_text(_x1+32,_y1+48,string(round(_evacuated_pop)))
		}
		draw_set_color(c_white)
	}
	if show_watersheds {
		var _watershed_colors = [c_purple,c_green,c_orange,c_blue,c_red,c_fuchsia,c_yellow];
		var _watershed_number = _tile.metrics.watershed;
		draw_set_alpha(0.4)
		draw_color_rectangle(_x1,_y1,_x2,_y2,_watershed_colors[_watershed_number-1],false)
		draw_set_alpha(1)
		var _direction = global.map.river_flow_grid[_tile.x div 64, _tile.y div 64];
		switch(_direction) {
			case "left":
				draw_sprite(sprRiverFlowLeft,0,_x1,_y1)
			break;
			case "right":
				draw_sprite(sprRiverFlowRight,0,_x1,_y1)
			break;
			case "up":
				draw_sprite(sprRiverFlowUp,0,_x1,_y1)
			break;
			case "down":
				draw_sprite(sprRiverFlowDown,0,_x1,_y1)
			break;
		}
	}
}

//draw affected tiles
if array_length(global.state.affected_tiles) > 0 {
	for(i=0; i<array_length(global.state.affected_tiles); i++) {
		var _square = global.state.affected_tiles[i];
		var _coords = grid_to_coords(_square);
		draw_sprite_ext(sprX,0,_coords[0],_coords[1],1,1,0,c_white,150/255)
	}
}

//draw hospitals/airports
pulse_timer++
if pulse_timer > pulse_length { pulse_timer = 0 }
var sat = 125 + 125*sin(2*pi/pulse_length * pulse_timer);
var pulse_color = make_color_hsv(color_get_hue(c_red), sat, 255)
for(i=0; i<array_length(global.map.hospitals); i++) {
	var _hosp = global.map.hospitals[i];
	if is_damaged(_hosp,global.map.hospital_grid) {
		draw_sprite_ext(sprHospital,1,_hosp.x,_hosp.y,1,1,0,pulse_color,1)
	} else {
		draw_sprite(sprHospital,0,_hosp.x,_hosp.y)
	}
}
for(i=0; i<array_length(global.map.airports); i++) {
	var _airp = global.map.airports[i];
	if is_damaged(_airp,global.map.airport_grid) {
		draw_sprite_ext(sprAirport,1,_airp.x,_airp.y,1,1,0,pulse_color,1)
	} else {
		draw_sprite(sprAirport,0,_airp.x,_airp.y)
	}
}

//don't do this stuff in the end-of-round map preview
if room != rRoundResults {

	//draw tiles with projects on them
	for(i=0; i<array_length(global.map.land_tiles); i++) {
		var tile = global.map.land_tiles[i];
		if array_length(tile.in_progress) > 0 || array_length(tile.implemented) > 0 {
			draw_sprite(sprInProgress,0,tile.x+48,tile.y+48)
		}
	}

	//draw added measures 
	for(i=0; i<array_length(global.map.land_tiles); i++) {
		var _tile = global.map.land_tiles[i];
		if array_length(_tile.measures) > 0 {
			for(var j=0; j<array_length(_tile.measures); j++) {
				var _x = _tile.x + (64 * (1/3)) * (j mod 3);
				var _y = _tile.y + (64 * (1/3)) * (j div 3);
				draw_sprite_ext(get_measure_sprite(_tile.measures[j]),0,_x,_y,1/3,1/3,0,c_white,1)
			}
		}
	}

	//draw markers
	if instance_number(objMarker) > 0 {
		for(i=0; i<instance_number(objMarker); i++) {
			var _mark = instance_find(objMarker,i);
			var _x = _mark.x*64 + 32;
			var _y = _mark.y*64 + 32;
			draw_sprite_ext(sprMarker,0,_x,_y,_mark.scale,_mark.scale,0,_mark.color,_mark.alpha)
		}
	}

	//get tooltip
	tooltip = "";
	if global.mouse_depth >= depth and mouse_map_x != -1{
		var _mouse_i = clamp(mouse_map_x div 64,0,14);
		var _mouse_j = clamp(mouse_map_y div 64,0,14);
		if global.map.land_grid[_mouse_i,_mouse_j] == 1 {
			draw_sprite_ext(sprWhiteTile,0,_mouse_i*64,_mouse_j*64,1,1,0,c_white,1)
			tooltip = coords_to_grid(mouse_map_x,mouse_map_y)
			var projects = tile_projects[$ tooltip];
			if array_length(projects) > 0 and room == rInGame {
				tutorial_popup(room_width/2-200,room_height/2-100,TUTORIAL.IN_PROGRESS_PROJECTS)	
			}
			for(var p=0; p<array_length(projects); p++) {
				tooltip += "\n" + projects[p];
			}
		}
	}

}

surface_reset_target()

//draw GUI map
var _scale = map_w / map_camera_w;
gpu_set_blendenable(false)
draw_surface_part_ext(map_surface,map_camera_x,map_camera_y,map_camera_w,map_camera_h,map_x,map_y,_scale,_scale,c_white,1)
gpu_set_blendenable(true)
draw_gui_border(map_x,map_y,map_x+map_w,map_y+map_h)

//draw layer caption
if layer_caption != "" {
	draw_set_alpha(0.5)
	draw_set_color(c_black)
	draw_set_font(fSidebar)
	draw_set_halign(fa_center)
	draw_set_valign(fa_bottom)
	draw_text(map_x+(map_w/2), map_y+map_h-16,layer_caption)
	draw_set_alpha(1)
	draw_set_color(c_white)
}

//draw marker captions
if instance_number(objMarker) > 0 {
	for(i=0; i<instance_number(objMarker); i++) {
		var _mark = instance_find(objMarker,i);
		var _amt = 64 * _scale;
		var _x = x + ((_mark.x*64)-map_camera_x)/64*_amt + _amt/2;
		var _y = y + ((_mark.y*64)-map_camera_y)/64*_amt + _amt/2;
		if coords_in(_x,_y,objMapGUI.x,objMapGUI.y,objMapGUI.bbox_right,objMapGUI.bbox_bottom) {
			draw_set_font(fInput)
			draw_set_alpha(_mark.alpha)
			draw_text_outline(_x,_y + (56*_scale),_mark.caption,c_white,c_black)
			draw_set_alpha(1)
		} else {
			if !_mark.announced {
				_mark.announced = true
				objSidebarGUIChat.chat_add(string("{0} has highlighted square {1}!",_mark.caption,coords_to_grid(_mark.x,_mark.y,false)))
			}
		}
	}
}

//draw tooltip
if tooltip != "" {
	draw_set_font(fTooltip)
	draw_set_halign(fa_center)
	draw_set_valign(fa_bottom)
	draw_text_outline(mouse_x,mouse_y-8,tooltip,c_white,c_black)
}