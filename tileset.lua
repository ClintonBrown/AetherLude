Tileset = {}
Tileset.__index = Tileset

-- create a tileset
function Tileset:Create(img)
	local this =
	{
		tileset_image = img,
		tile_size = 8,
		tiles = {}
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

-- draw specified tiles to the screen according to the map dimensions
function Tileset:Draw(map, mapx, mapy)
	for y = 1, mapy do
		for x = 1, mapx do
			-- if there is a valid tile number draw one, otherwise skip
			if map[y][x] < 3 and map[y][x] > -1 then
				love.graphics.draw(self.tileset_image, self.tiles[map[y][x]], (x - 1) * self.tile_size, (y - 1) * self.tile_size)
			end
		end
	end
end