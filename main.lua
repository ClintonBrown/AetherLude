-- Love2D RPG project

local player = require("player")
local tileset = require("tileset")

function love.load()
	-- set up debugging
	if arg[#arg] == "-debug" then require ("mobdebug").start() end
	
	-- window setup and variables
	love.window.setTitle("Aetherlude")
	scaler = 4
	love.window.setMode(64 * scaler, 64 * scaler, {fullscreen=false, msaa=0})
	window_w = love.graphics.getWidth() / scaler
	window_h = love.graphics.getHeight() / scaler
	
	
	-- load player object, sprite filtering, and initial location
	player_1 = Player:Create(love.graphics.newImage("sprites/sprite1.png"))
	player_1.sprite:setFilter("nearest", "nearest")
	player_1.xpos   = math.floor((window_w / 2) - player_1.sprite:getWidth()/2)
	player_1.ypos   = math.floor((window_h / 2) - player_1.sprite:getHeight()/2)
	
	-- load player collider
	player_1:LoadCollider()
	
	-- load tileset
	tileset_1 = Tileset:Create(love.graphics.newImage("tiles/tile1.png"))
	tileset_1.tileset_image:setFilter("nearest", "nearest")
	tileset_1:Load(2)
	
	-- load map
	map_1_layer_1 = {{ 1, 1, 1, 0, 0, 1, 1, 1 },
					 { 0, 0, 0, 0, 0, 0, 0, 0 },
					 { 0, 0, 0, 0, 0, 0, 0, 0 },
					 { 0, 0, 0, 0, 0, 0, 0, 0 },
					 { 0, 0, 0, 0, 0, 0, 0, 0 },
					 { 0, 0, 0, 0, 0, 0, 0, 0 },
					 { 0, 0, 0, 0, 0, 0, 0, 0 },
					 { 1, 1, 1, 1, 1, 1, 1, 1 } }
		
	map_1_layer_2 = {{ 3, 2, 3, 3, 3, 3, 2, 3 },
					 { 3, 3, 3, 3, 3, 3, 3, 3 },
					 { 3, 3, 3, 3, 3, 3, 3, 3 },
					 { 3, 3, 3, 3, 3, 3, 3, 3 },
					 { 3, 3, 3, 3, 3, 3, 3, 3 },
					 { 3, 3, 3, 3, 3, 3, 3, 3 },
					 { 3, 3, 3, 3, 3, 3, 3, 3 },
					 { 2, 3, 2, 3, 3, 2, 3, 2 } }
	
	-- load collision
	map_1_collision = tileset_1:LoadCollision(map_1_layer_1, 8, 8)
	
end

function love.update(dt)
	player_1:Movement(dt)
end

function love.draw()
	-- scale the graphics
	love.graphics.scale(scaler, scaler)
	
	-- draw tilemaps
	tileset_1:Draw(map_1_layer_1, 8, 8)
	tileset_1:Draw(map_1_layer_2, 8, 8)
	
	-- draw the player
	player_1:Draw()
	
	--------------------------------------------------------------------------------------------------------------------------------
	--[[DEBUG---------------------------------------------------------------------------------------------------------------------]]
	--------------------------------------------------------------------------------------------------------------------------------
	-- draw player collision box
--	love.graphics.setColor(255, 0, 0, 255)
--	love.graphics.rectangle("line", player_1.collider.x, player_1.collider.y, player_1.collider.width, player_1.collider.height)
	
	
--	-- draw map collision boxes
--	for y = 1, 8 do
--		for x = 1, 8 do
--			-- if there is a valid tile number draw one, otherwise skip
--			if map_1_collision[y][x] ~= nil then
--				love.graphics.rectangle("line", map_1_collision[y][x].x, map_1_collision[y][x].y, map_1_collision[y][x].width, map_1_collision[y][x].height)
--			end
--		end
--	end
--	love.graphics.setColor(255, 255, 255, 255)
	--------------------------------------------------------------------------------------------------------------------------------

end