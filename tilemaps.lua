-- Tilemaps for areas

local Tilemaps = {}

-- map dimensions
Tilemaps.map_width  = 8
Tilemaps.map_height = 8

-- Map 1
Tilemaps.map_1_layer_1 = {{ 1, 1, 1, 0, 0, 1, 1, 1 },
					      { 3, 0, 0, 0, 0, 0, 0, 3 },
					      { 3, 0, 0, 0, 0, 0, 0, 3 },
					      { 3, 3, 3, 0, 0, 3, 3, 3 },
					      { 0, 0, 3, 3, 3, 3, 0, 0 },
					      { 1, 1, 1, 3, 3, 1, 1, 1 },
					      { 9, 9, 9, 1, 1, 9, 9, 9 },
					      { 9, 9, 9, 9, 9, 9, 9, 9 } }
		
Tilemaps.map_1_layer_2 = {{ 9, 2, 9, 9, 9, 9, 2, 9 },
					      { 9, 9, 9, 9, 9, 9, 9, 9 },
					      { 9, 9, 9, 9, 9, 9, 9, 9 },
					      { 9, 9, 9, 9, 9, 9, 9, 9 },
					      { 9, 9, 9, 9, 9, 9, 9, 9 },
					      { 9, 2, 9, 9, 9, 9, 2, 9 },
					      { 9, 9, 9, 9, 9, 9, 9, 9 },
					      { 9, 9, 9, 9, 9, 9, 9, 9 } }

return Tilemaps