-- Love2D RPG project

local player     = require("scripts.player")
local tileset    = require("scripts.tileset")
local messagebox = require("scripts.messagebox")
local maps       = require("scripts.tilemaps")
local mteleport  = require("scripts.mapteleport")
local battle     = require("scripts.battle")

-- window variables
local SCALER = 4

-- object initialization
local player_1 = player:Create(love.graphics.newImage("sprites/sprite1.png"), "Aether")
local tileset_1 = tileset:Create(love.graphics.newImage("tiles/tile1.png"), 4)
local messagebox_1 = messagebox:Create("[-INTERCOM-]\nAttention engineers. The Aethercore reactor has reached critical instability. Evacuate immediately!")
local collision_map = tileset_1:LoadCollision(maps.maps_table[2][1], maps.map_width, maps.map_height)
local battler = battle:Create(love.graphics.newImage("sprites/anomaly.png"))

--[[Tracks which map the player is currently on using map table, not all numbers are used.
	Where 2 is the starting map:
	9, 10, 11, 12
	5,  6,  7, 8
	1,  2,  3, 4   ]]
local current_map = 2

local game_end = false

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
	battler.enemy_sprite:setFilter("nearest", "nearest")
	player_1.xpos = math.floor((WINDOW_WIDTH / 2) - player_1.sprite:getWidth()/2)
	player_1.ypos = math.floor((WINDOW_HEIGHT / 2) - player_1.sprite:getHeight()*2)
	player_1:LoadCollider()
	
	-- load tileset object
	tileset_1.tileset_image:setFilter("nearest", "nearest")
	tileset_1:Load()

	-- load messagebox variables
	messagebox_1:Load()
	
	-- enable messagebox for intro message
	messagebox_1.enabled  = true
	
	-- load battler variables
	battler:Load(tileset_1, messagebox_1)
	
end

function love.update(dt)
	-- allow player movement
	player_1:Movement(dt, maps.map_height, maps.map_width, collision_map)
	
	-- check player location for teleports and update the map accordingly
	current_map   = mteleport.CheckTeleports(player_1, tileset_1, current_map)
	collision_map = mteleport.UpdateCollision(maps.maps_table, tileset_1, current_map)
	
	-- battle event handling
	battler:Start(messagebox_1, player_1)
	battler:Continue(messagebox_1, player_1, SCALER)
	
	-- messagebox event handling
	if messagebox_1.enabled then player_1.can_act = false else player_1.can_act = true end
	messagebox_1:Continue(player_1, current_map)
	
	-- check if player is dead
	player_1:IsDead(messagebox_1)
	
	-- check if at end of game
	if current_map == 4 then
		player_1.can_act = false
		messagebox_1.enabled   = true
		player_1.is_dead = true
		messagebox_1.message   = "Congratulations! You made it out!"
		
	end
	
end

function love.draw()
	-- clear the screen
	love.graphics.clear()
	
	-- store the current state
	love.graphics.push()
	
	-- scale the graphics
	love.graphics.scale(SCALER, SCALER)
	
	-- draw current tilemaps
	mteleport.DrawMap(tileset_1, maps.maps_table, current_map)
	
	-- draw the player
	player_1:Draw()
	
	-- draw enemy during battle
	battler:DrawEnemy()
	
	-- draw debug
--	DrawDebug()
	
	-- draw boxes
	messagebox_1:DrawBox()
	battler:DrawChoiceBoxes()
	battler:DrawPlayerHealthBox()

	-- unscaled graphics after the pop
	love.graphics.pop()
	
	-- draw messagebox text
	messagebox_1:DrawText(SCALER)
	battler:DrawChoiceText(SCALER)
	battler:DrawPlayerHealthText(player_1, SCALER)

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
			if collision_map[y][x] ~= nil then
				love.graphics.rectangle("line", collision_map[y][x].x, collision_map[y][x].y, collision_map[y][x].width, collision_map[y][x].height)
			end
		end
	end
	love.graphics.setColor(255, 255, 255, 255)
	
end