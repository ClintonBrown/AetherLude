-- Controls transitioning between maps

--[[map table, 2 is start map:
	9, 10, 11, 12
	5,  6,  7,  8
	1,  2,  3,  4   ]]

local MapTeleport = {}

local maps = require("scripts.tilemaps")

-- Teleport player to new map based on their location on the current map
-- Returns: integer value of the new current map
function MapTeleport.CheckTeleports(pl_obj, tset, this_map)
	local half_tile = tset.tile_size / 2
	
	-- check for map teleports
	-- map 1 is the last map before the end
	-- map 4 is the blank map for end of game
	if this_map ~= 4 and pl_obj.ypos < -half_tile then
		this_map = this_map + 4
		pl_obj.ypos = WINDOW_HEIGHT - half_tile
		
	elseif this_map ~= 4 and this_map ~= 1 and pl_obj.ypos > WINDOW_HEIGHT - half_tile then
		this_map = this_map - 4
		pl_obj.ypos = -half_tile
		
	elseif this_map == 1 and pl_obj.ypos > WINDOW_HEIGHT - half_tile then
		-- load blank map
		this_map = 4
		
		-- center player
		pl_obj.xpos = math.floor((WINDOW_WIDTH / 2) - (pl_obj.sprite:getWidth() / 2))
		pl_obj.ypos = math.floor((WINDOW_HEIGHT / 2) - pl_obj.sprite:getHeight())
		
	elseif this_map ~= 4 and pl_obj.xpos < -half_tile then
		this_map = this_map - 1
		pl_obj.xpos = WINDOW_WIDTH - half_tile
		
	elseif this_map ~= 4 and pl_obj.xpos > WINDOW_WIDTH - half_tile then
		this_map = this_map + 1
		pl_obj.xpos = -half_tile
		
	end
	
	return this_map
end

-- Update collision map to reflect the current map
-- Returns: collision map for the current map
function MapTeleport.UpdateCollision(map_t, tset, this_map)
	-- load the collision map for the current map
	c_map = tset:LoadCollision(map_t[this_map][1], maps.map_width, maps.map_height)
	
	return c_map
end

-- Draw the current map
function MapTeleport.DrawMap(tset, map_t, this_map)	
	tset:Draw(map_t[this_map][1], maps.map_width, maps.map_height)
	tset:Draw(map_t[this_map][2], maps.map_width, maps.map_height)
end

return MapTeleport