-- Love2D RPG project

local player     = require("player")
local tileset    = require("tileset")
local collision  = require("collision")
local messagebox = require("messagebox")

-- map dimensions
local map_width  = 8
local map_height = 8

-- collision detection flags
local is_collision = { left = false, right = false, up = false, down = false }

-- window variables
local SCALER = 4

-- load map
local map_1_layer_1 = {{ 1, 1, 1, 0, 0, 1, 1, 1 },
					   { 0, 0, 0, 0, 0, 0, 0, 0 },
					   { 0, 0, 0, 0, 0, 0, 0, 0 },
					   { 0, 0, 0, 0, 0, 0, 0, 0 },
					   { 0, 0, 0, 0, 0, 0, 0, 0 },
					   { 0, 0, 0, 0, 0, 0, 0, 0 },
					   { 0, 0, 0, 0, 0, 0, 0, 0 },
					   { 1, 1, 1, 1, 1, 1, 1, 1 } }
		
local map_1_layer_2 = {{ 3, 2, 3, 3, 3, 3, 2, 3 },
					   { 3, 3, 3, 3, 3, 3, 3, 3 },
					   { 3, 3, 3, 3, 3, 3, 3, 3 },
					   { 3, 3, 3, 3, 3, 3, 3, 3 },
					   { 3, 3, 3, 3, 3, 3, 3, 3 },
					   { 3, 3, 3, 3, 3, 3, 3, 3 },
					   { 3, 3, 3, 3, 3, 3, 3, 3 },
					   { 2, 3, 2, 3, 3, 2, 3, 2 } }



function love.load()
	-- set up debugging
	if arg[#arg] == "-debug" then require ("mobdebug").start() end
	
	-- window setup and variables
	love.window.setTitle("Aetherlude")
	love.window.setMode(64 * SCALER, 64 * SCALER, {fullscreen=false, msaa=0})
	WINDOW_WIDTH  = love.graphics.getWidth() / SCALER
	WINDOW_HEIGHT = love.graphics.getHeight() / SCALER
	
	-- load player object, sprite filtering, and initial location
	player_1 = player:Create(love.graphics.newImage("sprites/sprite1.png"))
	player_1.sprite:setFilter("nearest", "nearest")
	player_1.xpos   = math.floor((WINDOW_WIDTH / 2) - player_1.sprite:getWidth()/2)
	player_1.ypos   = math.floor((WINDOW_HEIGHT / 2) - player_1.sprite:getHeight()/2)
	
	-- load player collider
	player_1:LoadCollider()
	
	-- load tileset
	tileset_1 = tileset:Create(love.graphics.newImage("tiles/tile1.png"))
	tileset_1.tileset_image:setFilter("nearest", "nearest")
	tileset_1:Load(2)
	
	-- load collision
	map_1_collision = tileset_1:LoadCollision(map_1_layer_1, map_width, map_height)
	
	-- create a messagebox object
	messagebox_1 = messagebox:Create()
	messagebox_1:Load()
	
end

function love.update(dt)
	-- check collisions for player
	local is_collision = collision.UpdateCollision(player_1, map_width, map_height, map_1_collision)
	
	-- messagebox event handling
	if messagebox_1.enabled then player_1.can_act = false else player_1.can_act = true end
	messagebox_1:Continue()
	
	-- allow player movement
	player_1:Movement(dt, is_collision)
	
end

function love.draw()
	-- store the current state
	love.graphics.push()
	
	-- scale the graphics
	love.graphics.scale(SCALER, SCALER)
	
	-- draw tilemaps
	tileset_1:Draw(map_1_layer_1, map_width, map_height)
	tileset_1:Draw(map_1_layer_2, map_width, map_height)
	
	-- draw the player
	player_1:Draw()
	
	-- draw messagebox box
	messagebox_1:DrawBox()
	
	-- unscaled graphics after the pop
	love.graphics.pop()
	
	-- draw messagebox text
	messagebox_1:DrawText("This is a test of the messagebox system. Check out this messagebox!", SCALER)
	

	
	--------------------------------------------------------------------------------------------------------------------------------
	--[[DEBUG---------------------------------------------------------------------------------------------------------------------]]
	--------------------------------------------------------------------------------------------------------------------------------
	-- draw player collision box
--	love.graphics.setColor(255, 0, 0, 255)
--	love.graphics.rectangle("line", player_1.collider.x, player_1.collider.y, player_1.collider.width, player_1.collider.height)
	
	
--	-- draw map collision boxes
--	for y = 1, map_height do
--		for x = 1, map_width do
--			-- if there is a collision box draw it
--			if map_1_collision[y][x] ~= nil then
--				love.graphics.rectangle("line", map_1_collision[y][x].x, map_1_collision[y][x].y, map_1_collision[y][x].width, map_1_collision[y][x].height)
--			end
--		end
--	end
--	love.graphics.setColor(255, 255, 255, 255)
	--------------------------------------------------------------------------------------------------------------------------------

end