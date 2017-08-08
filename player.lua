-- player class

-- initialize metatable
Player = {}
Player.__index = Player

-- create the player
function Player:Create(img)
	local this =
	{
		sprite   = img,
		speed    = 20,
		xpos     = 0,
		ypos	 = 0,
		collider = { x, y, width, height },
		name     = "Aether",
		health   = 20,
		attack   = 5,
		defense  = 5
	}
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
	-- shorthand command
	key = love.keyboard
	
	-- move if wsad or arrow keys are pressed but do not leave screen
	if (key.isDown("w") or key.isDown("up")) and self.ypos > 0 and not is_collision.up then
		self.ypos = self.ypos - self.speed * dt
		
	elseif (key.isDown("s") or key.isDown("down"))  and self.ypos < window_h - self.sprite:getHeight() and not is_collision.down then
		self.ypos = self.ypos + self.speed * dt
		
	elseif (key.isDown("a") or key.isDown("left")) and self.xpos > 0 and not is_collision.left then
		self.xpos = self.xpos - self.speed * dt
		
	elseif (key.isDown("d") or key.isDown("right")) and self.xpos < window_h - self.sprite:getWidth() and not is_collision.right then
		self.xpos = self.xpos + self.speed * dt
	end
	
	-- move collider to new player location
	self.collider.y = self.ypos
	self.collider.x = self.xpos
end

---- checks if box is overlapping another box
---- returns: true if boxes are colliding
--function Player:CheckCollision(x1, y1, w1, h1, x2, y2, w2, h2)	
--	return x1 < x2+w2 and
--			x2 < x1+w1 and
--            y1 < y2+h2 and
--            y2 < y1+h1
--end