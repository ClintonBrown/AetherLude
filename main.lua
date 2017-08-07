-- Love2D RPG project

local player = require("player")

function love.load()
	-- window setup and variables
	scaler = 4
	love.window.setMode(64 * scaler, 64 * scaler, {fullscreen=false, msaa=0})
	window_w = love.graphics.getWidth()
	window_h = love.graphics.getHeight()
	
	
	-- set up player object
	player_1 = Player:Create()
	player_1.sprite = love.graphics.newImage("sprites/sprite1.png")
	player_1.xpos   = math.floor(window_w / (scaler*2) - player_1.sprite:getWidth()/2)
	player_1.ypos   = math.floor(window_h / (scaler*2) - player_1.sprite:getHeight()/2)
end

function love.update(dt)
	player_1:Movement(dt)
end

function love.draw()
	-- scale the graphics
	love.graphics.scale(scaler, scaler)
	
	-- draw the player
	player_1.sprite:setFilter("nearest", "nearest")
	player_1:Draw()
end