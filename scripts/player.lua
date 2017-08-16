-- Player class

local Player = {}
Player.__index = Player

-- create the player
function Player:Create(img, nm)
	local this = {	sprite   = img,
					speed    = 1,
					xpos     = 0,
					ypos	    = 0,
					collider = { x, y, width, height },
					name     = nm,
					health   = 20,
					max_hp   = 20,
					attack   = 5,
					magic    = 3,
					moved    = 0,
					is_dead  = false,
					can_act  = true }

	setmetatable(this, self)
	return this	
end

function Player:LoadCollider()	
	-- set up player collider
	self.collider.x = self.xpos
	self.collider.y = self.ypos
	
	-- collider is slightly widened to allow for pixel perfect collisions
	self.collider.width  = self.sprite:getWidth() + 1
	self.collider.height = self.sprite:getHeight() + 1
end

-- draws player in center of screen
function Player:Draw()
	love.graphics.draw(self.sprite, self.xpos, self.ypos)
end

-- takes keyboard input for player movement
function Player:Movement(dt, map_w, map_h, c_map)
	if self.can_act then
		-- shorthand command
		local key = love.keyboard
		
		-- check collisions for player
		local collision  = require("scripts.collision")
		local is_collision = collision.UpdateCollision(self, map_w, map_h, c_map)
		
		-- move if wsad or arrow keys are pressed but do not leave screen
		if (key.isDown("w") or key.isDown("up")) and not is_collision.up then
			self.ypos = math.floor(self.ypos) - (self.speed * dt)
			self.moved = self.moved + 1
			
		elseif (key.isDown("s") or key.isDown("down")) and not is_collision.down then
			self.ypos = math.ceil(self.ypos) + (self.speed * dt)
			self.moved = self.moved + 1
			
		elseif (key.isDown("a") or key.isDown("left")) and not is_collision.left then
			self.xpos = math.floor(self.xpos) - (self.speed * dt)
			self.moved = self.moved + 1
			
		elseif (key.isDown("d") or key.isDown("right")) and not is_collision.right then
			self.xpos = math.ceil(self.xpos) + (self.speed * dt)
			self.moved = self.moved + 1
		end
		
		-- move collider to new player location
		self.collider.y = self.ypos - 0.5
		self.collider.x = self.xpos - 0.5
	end
end

function Player:IsDead(msgbox)
	if self.is_dead == true then
		msgbox.message   = "You have died."
		msgbox.enabled   = true
	end
end

return Player