-- Love2D RPG project

local player = require("player")
local tileset = require("tileset")

-- map dimensions
local map_x = 8
local map_y = 8

-- load map
local map_1_layer_1 = {{ 1, 1, 1, 0, 0, 1, 1, 1 },
					   { 0, 0, 0, 0, 0, 0, 0, 0 },
					   { 0, 0, 0, 0, 0, 0, 0, 0 },
					   { 0, 0, 0, 0, 0, 0, 0, 0 },
					   { 0, 0, 0, 0, 0, 0, 0, 0 },
					   { 1, 0, 0, 0, 0, 0, 0, 1 },
					   { 1, 0, 1, 0, 0, 1, 0, 1 },
					   { 1, 1, 1, 1, 1, 1, 1, 1 } }
		
local map_1_layer_2 = {{ 3, 2, 3, 3, 3, 3, 2, 3 },
					   { 3, 3, 3, 3, 3, 3, 3, 3 },
					   { 3, 3, 3, 3, 3, 3, 3, 3 },
					   { 3, 3, 3, 3, 3, 3, 3, 3 },
					   { 3, 3, 3, 3, 3, 3, 3, 3 },
					   { 3, 3, 3, 3, 3, 3, 3, 3 },
					   { 3, 3, 3, 3, 3, 3, 3, 3 },
					   { 2, 3, 2, 3, 3, 2, 3, 2 } }

local is_collision = { left = "", right = "", up = "", down = "" }

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
	
	-- load collision
	map_1_collision = tileset_1:LoadCollision(map_1_layer_1, map_x, map_y)
	
	-- shorthand command
	m1c = map_1_collision
	
end

function love.update(dt)
	-- check collisions for player
	UpdateCollision(player_1)
	
	-- allow player movement
	player_1:Movement(dt, is_collision)
	
end

function love.draw()
	-- scale the graphics
	love.graphics.scale(scaler, scaler)
	
	-- draw tilemaps
	tileset_1:Draw(map_1_layer_1, map_x, map_y)
	tileset_1:Draw(map_1_layer_2, map_x, map_y)
	
	-- draw the player
	player_1:Draw()
	
	--------------------------------------------------------------------------------------------------------------------------------
	--[[DEBUG---------------------------------------------------------------------------------------------------------------------]]
	--------------------------------------------------------------------------------------------------------------------------------
	-- draw player collision box
--	love.graphics.setColor(255, 0, 0, 255)
--	love.graphics.rectangle("line", player_1.collider.x, player_1.collider.y, player_1.collider.width, player_1.collider.height)
	
	
--	-- draw map collision boxes
--	for y = 1, map_y do
--		for x = 1, map_x do
--			-- if there is a collision box draw it
--			if map_1_collision[y][x] ~= nil then
--				love.graphics.rectangle("line", map_1_collision[y][x].x, map_1_collision[y][x].y, map_1_collision[y][x].width, map_1_collision[y][x].height)
--			end
--		end
--	end
--	love.graphics.setColor(255, 255, 255, 255)
	--------------------------------------------------------------------------------------------------------------------------------

end

-- perform collision checks for an object with 4-direction movement
-- object must have xpos, ypos, and sprite
function UpdateCollision(object)
	-- reset collision check
	is_collision = { left = false, right = false, up = false, down = false }
	
	-- check for collisions
	for y = 1, map_x do
		for x = 1, map_y do
			-- if there is a collision report it
			if m1c[y][x] ~= nil then
				
				-- Check for collisions on left, right, top, and bottom of player collision box
				if CheckCollision(object.xpos, (object.ypos + 1), (object.sprite:getWidth() - 6), (object.sprite:getHeight() - 2),
										 (m1c[y][x].x + 6), (m1c[y][x].y + 1), (m1c[y][x].width - 6), (m1c[y][x].height) - 2) then
				-- there was a collision between LEFT of player and RIGHT of collidable tile
				is_collision.left = true
				end
				
				if CheckCollision((object.xpos + 6), (object.ypos + 1), (object.sprite:getWidth() - 6), (object.sprite:getHeight() - 2),
										 (m1c[y][x].x), (m1c[y][x].y + 1), (m1c[y][x].width - 6), (m1c[y][x].height) - 2) then
				-- there was a collision between RIGHT of player and LEFT of collidable tile
				is_collision.right = true
				end
				
				if CheckCollision((object.xpos + 1), (object.ypos), (object.sprite:getWidth() - 2), (object.sprite:getHeight() - 6),
										 (m1c[y][x].x + 1), (m1c[y][x].y + 6), (m1c[y][x].width - 2), (m1c[y][x].height - 6)) then
				-- there was a collision between TOP of player and BOTTOM of collidable tile
				is_collision.up = true
				end
				
				if CheckCollision((object.xpos + 1), (object.ypos + 6), (object.sprite:getWidth() - 2), (object.sprite:getHeight() - 6),
										 (m1c[y][x].x + 1), (m1c[y][x].y), (m1c[y][x].width - 2), (m1c[y][x].height - 6)) then
				-- there was a collision between BOTTOM of player and TOP of collidable tile
				is_collision.down = true
				end
			
			end
		end
	end
end

-- checks if box is overlapping another box
-- returns: true if boxes are colliding
function CheckCollision(x1, y1, w1, h1, x2, y2, w2, h2)	
	return  x1 < x2+w2 and
			x2 < x1+w1 and
            y1 < y2+h2 and
            y2 < y1+h1
end