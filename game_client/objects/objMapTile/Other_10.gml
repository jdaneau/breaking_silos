//establish adjacency with other tiles to render the map
var up, left, down, right;
up = place_meeting(x,y-1,objMapTile) || place_meeting(x,y-1,objForeignTile) || y == 0
left = place_meeting(x-1,y,objMapTile) || place_meeting(x-1,y,objForeignTile) || x == 0
right = place_meeting(x+1,y,objMapTile) || place_meeting(x+1,y,objForeignTile) || x == (room_width - 64)
down = place_meeting(x,y+1,objMapTile) || place_meeting(x,y+1,objForeignTile) || y == (room_height - 64)

if !up and down and left and right { image_index = LAND_TILE.TOP }
else if !left and up and down and right { image_index = LAND_TILE.LEFT }
else if !right and up and left and down { image_index = LAND_TILE.RIGHT }
else if !down and up and left and right { image_index = LAND_TILE.BOTTOM }
else if !up and !left and down and right { image_index = LAND_TILE.TOPLEFT }
else if !up and !right and down and left { image_index = LAND_TILE.TOPRIGHT }
else if !down and !left and up and right { image_index = LAND_TILE.BOTTOMLEFT }
else if !down and !right and up and left { image_index = LAND_TILE.BOTTOMRIGHT }
else if !up and !left and !down and right { image_index = LAND_TILE.PENINSULA_LEFT }
else if !up and !right and !down and left { image_index = LAND_TILE.PENINSULA_RIGHT }
else if !down and !left and up and !right { image_index = LAND_TILE.PENINSULA_DOWN }
else if down and !right and !up and !left { image_index = LAND_TILE.PENINSULA_UP }
else { image_index = LAND_TILE.MIDDLE }