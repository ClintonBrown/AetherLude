-- Love2D RPG project

local player     = require("scripts.player")
local tileset    = require("scripts.tileset")
local messagebox = require("scripts.messagebox")
local maps       = require("scripts.tilemaps")

-- window variables
local SCALER = 4

-- object initialization
local player_1 = player:Create(love.graphics.newImage("sprites/sprite1.png"), "Aether")
local tileset_1 = tileset:Create(love.graphics.newImage("tiles/tile1.png"), 4)
local map_1_collision = tileset_1:LoadCollision(maps.map_1_layer_1, maps.map_width, maps.map_height)
local messagebox_1 = messagebox:Create()

-- tracks which map the player is currently on
local current_map = 1

function love.load()
	-- set up debugging
	if arg[#arg] == "-debug" then require ("mobdebug").start() end
	
	-- window setup and variables
	love.window.setTitle("Aetherlude")
	love.window.setMode(64 * SCALER, 64 * SCALER, {fullscreen=false, msaa=0})
	WINDOW_WIDTH  = love.graphics.getWidth() / SCALER
	WINDOW_HEIGHT = love.graphics.getHeight() / SCALER
	
	-- load player object, sprite filtering, and initial location
	player_1.sprite:setFilter("nearest", "nearest")
	player_1.xpos = math.floor((WINDOW_WIDTH / 2) - player_1.sprite:getWidth()/2)
	player_1.ypos = math.floor((WINDOW_HEIGHT / 2) - player_1.sprite:getHeight()*2)
	player_1:LoadCollider()
	
	-- load tileset object
	tileset_1.tileset_image:setFilter("nearest", "nearest")
	tileset_1:Load()
		
	-- create a messagebox object
	messagebox_1:Load()
	
	-- load intro text
	intro_message = "[-INTERCOM-]\nAethercore engineer 5515 please report to the North Command Room immediately."
	messagebox_1.enabled = true
	
end

function love.update(dt)
	-- messagebox event handling
	if messagebox_1.enabled then player_1.can_act = false else player_1.can_act = true end
	messagebox_1:Continue()
	
	-- allow player movement
	player_1:Movement(dt, maps.map_height, maps.map_width, map_1_collision)
	
	-- check for map teleports
	if current_map == 1 and player_1.ypos < tileset_1.tile_size / 2 then
		current_map = 2
		map_1_collision = tileset_1:LoadCollision(maps.map_2_layer_1, maps.map_width, maps.map_height)
		player_1.ypos = WINDOW_HEIGHT - tileset_1.tile_size * 1.5
	elseif current_map == 2 and player_1.ypos > WINDOW_HEIGHT - (tileset_1.tile_size) then
		current_map = 1
		map_1_collision = tileset_1:LoadCollision(maps.map_1_layer_1, maps.map_width, maps.map_height)
		player_1.ypos = tileset_1.tile_size / 2
	end
	
end

function love.draw()
	-- clear the screen
	love.graphics.clear()
	
	-- store the current state
	love.graphics.push()
	
	-- scale the graphics
	love.graphics.scale(SCALER, SCALER)
	
	-- draw tilemaps
	if current_map == 1 then
		tileset_1:Draw(maps.map_1_layer_1, maps.map_width, maps.map_height)
		tileset_1:Draw(maps.map_1_layer_2, maps.map_width, maps.map_height)
	elseif current_map == 2 then
		tileset_1:Draw(maps.map_2_layer_1, maps.map_width, maps.map_height)
		tileset_1:Draw(maps.map_2_layer_2, maps.map_width, maps.map_height)
	end
	
	-- draw the player
	player_1:Draw()
	
	-- draw debug
--	DrawDebug()
	
	-- draw messagebox box
	messagebox_1:DrawBox()
	
	-- unscaled graphics after the pop
	love.graphics.pop()
	
	-- draw messagebox text
	messagebox_1:DrawText(intro_message, SCALER)

end

-- Draw extra debug information to screen
function DrawDebug()
	-- draw player collision box
	love.graphics.setColor(255, 0, 0, 255)
	love.graphics.setLineWidth(0.5) -- easier to see lines with small boxes
	love.graphics.rectangle("line", player_1.collider.x, player_1.collider.y, player_1.collider.width, player_1.collider.height)
	
	-- draw left, right, up, and down colliders (which are based off of the player collider box)
	love.graphics.rectangle("line", player_1.collider.x, (player_1.collider.y + 1), 1, (player_1.collider.height - 2))         							 -- left
    love.graphics.rectangle("line", (player_1.collider.x + (player_1.collider.width - 1)), (player_1.collider.y + 1), 1, (player_1.collider.height - 2)) -- right
	love.graphics.rectangle("line", (player_1.collider.x + 1), player_1.collider.y, (player_1.collider.width - 2), 1) 									 -- top
	love.graphics.rectangle("line", (player_1.collider.x + 1), (player_1.collider.y + (player_1.collider.height - 1)), (player_1.collider.width - 2), 1) -- bottom
	
	-- draw map collision boxes
	for y = 1, maps.map_height do
		for x = 1, maps.map_width do
			-- if there is a collision box draw it
			if map_1_collision[y][x] ~= nil then
				love.graphics.rectangle("line", map_1_collision[y][x].x, map_1_collision[y][x].y, map_1_collision[y][x].width, map_1_collision[y][x].height)
			end
		end
	end
	love.graphics.setColor(255, 255, 255, 255)
	
end