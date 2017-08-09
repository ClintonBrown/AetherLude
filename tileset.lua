local Tileset = {}
Tileset.__index = Tileset

-- create a tileset
function Tileset:Create(img)
	local this =
	{
		tileset_image = img,
		tile_size     = 8,
		collidable    = 1,      -- anything after this tile is collidable
		tiles         = {},
		cmap          = {}      -- table for collision rectangles
	}
	setmetatable(this, self)
	return this
end

-- load a tileset with a specified length in tiles
function Tileset:Load(length)
	for t = 0, length do
		-- go through tileset image and get each individual tile
		self.tiles[t] = love.graphics.newQuad(t * self.tile_size, 0, self.tile_size, self.tile_size, self.tileset_image:getDimensions())
	end
end

-- create collision boxes for tilemap
-- returns: 2D table of collision boxes
function Tileset:LoadCollision(tmap, map_w, map_h)
	-- table to hold collision map
	self.cmap = {}
	
	for y = 1, map_h do
		-- create new row
		self.cmap[y] = {}
		for x = 1, map_w do
			if tmap[y][x] >= self.collidable then
				-- create bounding rectangle at collidable points
				self.cmap[y][x] = { x = (x - 1) * self.tile_size, 
									y = (y - 1) * self.tile_size,
									width  = self.tile_size,
									height = self.tile_size }
			end
		end
	end
	return self.cmap
end

-- draw specified tiles to the screen according to the tilemap dimensions
function Tileset:Draw(tmap, map_w, map_h)
	-- loop through
	for y = 1, map_h do
		for x = 1, map_w do
			-- if there is a valid tile number draw one, otherwise skip
			if tmap[y][x] < 3 and tmap[y][x] > -1 then
				love.graphics.draw(self.tileset_image, self.tiles[tmap[y][x]], (x - 1) * self.tile_size, (y - 1) * self.tile_size)
			end
		end
	end
end

return Tileset