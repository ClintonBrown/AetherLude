-- Player class

local Player = {}
Player.__index = Player

-- create the player
function Player:Create(img, nm)
	local this = { sprite   = img,
				   speed    = 20,
				   xpos     = 0,
				   ypos	    = 0,
				   collider = { x, y, width, height },
				   name     = nm,
				   health   = 20,
				   attack   = 5,
				   defense  = 5,
				   can_act = true }

	setmetatable(this, self)
	return this	
end

function Player:LoadCollider()
	-- set up player collider
	self.collider.x = self.xpos
	self.collider.y = self.ypos
	self.collider.width  = self.sprite:getWidth()
	self.collider.height = self.sprite:getHeight()
end

-- draws player in center of screen
function Player:Draw()
	love.graphics.draw(self.sprite, self.xpos, self.ypos)
end

-- takes keyboard input for player movement
function Player:Movement(dt, is_collision)
	if self.can_act then
		-- shorthand command
		local key = love.keyboard
		
		-- move if wsad or arrow keys are pressed but do not leave screen
		if (key.isDown("w") or key.isDown("up")) and self.ypos > 0 and not is_collision.up then
			self.ypos = self.ypos - (self.speed * dt)
			
		elseif (key.isDown("s") or key.isDown("down"))  and self.ypos < WINDOW_HEIGHT - self.sprite:getHeight() and not is_collision.down then
			self.ypos = self.ypos + (self.speed * dt)
			
		elseif (key.isDown("a") or key.isDown("left")) and self.xpos > 0 and not is_collision.left then
			self.xpos = self.xpos - (self.speed * dt)
			
		elseif (key.isDown("d") or key.isDown("right")) and self.xpos < WINDOW_WIDTH - self.sprite:getWidth() and not is_collision.right then
			self.xpos = self.xpos + (self.speed * dt)
		end
		
		-- move collider to new player location
		self.collider.y = self.ypos
		self.collider.x = self.xpos
	end
end

return Player