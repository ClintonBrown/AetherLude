-- Controls transitioning between maps

--[[map table for math, 2 is start map:
	9, 10, 11, 12
	5,  6,  7,  8
	1,  2,  3,  4   ]]

local MapTeleport = {}

local maps = require("scripts.tilemaps")

-- Teleport player to new map based on their location on the current map
-- Returns: integer value of the new current map
function MapTeleport.CheckTeleports(pl_obj, tset, this_map)
	local half_tile     = tset.tile_size / 2
	local add_half_tile = tset.tile_size * 1.5
	
	--check for map teleports
	if pl_obj.ypos < half_tile then
		this_map = this_map + 4
		pl_obj.ypos = WINDOW_HEIGHT - add_half_tile
		
	elseif pl_obj.ypos > WINDOW_HEIGHT - add_half_tile then
		this_map = this_map - 4
		pl_obj.ypos = half_tile
		
	elseif pl_obj.xpos < half_tile then
		this_map = this_map - 1
		pl_obj.xpos = WINDOW_WIDTH - add_half_tile
		
	elseif pl_obj.xpos > WINDOW_WIDTH - add_half_tile then
		this_map = this_map + 1
		pl_obj.xpos = half_tile
		
	end
	
	return this_map
end

-- Update collision map to reflect the current map
-- Returns: collision map for the current map
function MapTeleport.UpdateCollision(c_map, tset, this_map)
	if     this_map == 2 then c_map = tset:LoadCollision(maps.map_1_layer_1, maps.map_width, maps.map_height)
	elseif this_map == 6 then c_map = tset:LoadCollision(maps.map_2_layer_1, maps.map_width, maps.map_height)
	elseif this_map == 7 then c_map = tset:LoadCollision(maps.map_3_layer_1, maps.map_width, maps.map_height)
	elseif this_map == 3 then c_map = tset:LoadCollision(maps.map_4_layer_1, maps.map_width, maps.map_height)
	elseif this_map == 8 then c_map = tset:LoadCollision(maps.map_5_layer_1, maps.map_width, maps.map_height)
	end
	
	return c_map
end

-- Draw the current map
function MapTeleport.DrawMap(tset, this_map)	
	if this_map == 2 then
		tset:Draw(maps.map_1_layer_1, maps.map_width, maps.map_height)
		tset:Draw(maps.map_1_layer_2, maps.map_width, maps.map_height)
	elseif this_map == 6 then
		tset:Draw(maps.map_2_layer_1, maps.map_width, maps.map_height)
		tset:Draw(maps.map_2_layer_2, maps.map_width, maps.map_height)
	elseif this_map == 7 then
		tset:Draw(maps.map_3_layer_1, maps.map_width, maps.map_height)
		tset:Draw(maps.map_3_layer_2, maps.map_width, maps.map_height)
	elseif this_map == 3 then
		tset:Draw(maps.map_4_layer_1, maps.map_width, maps.map_height)
		tset:Draw(maps.map_4_layer_2, maps.map_width, maps.map_height)
	elseif this_map == 8 then
		tset:Draw(maps.map_5_layer_1, maps.map_width, maps.map_height)
		tset:Draw(maps.map_5_layer_2, maps.map_width, maps.map_height)
	end
end

return MapTeleport