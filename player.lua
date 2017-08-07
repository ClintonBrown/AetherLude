-- player class

-- initialize metatable
Player = {}
Player.__index = Player

-- constructor
function Player:Create(img)
	local this =
	{
		sprite   = img,
		speed    = 20,
		xpos     = 0,
		ypos	 = 0,
		name     = "Aether",
		health   = 20,
		attack   = 5,
		defense  = 5
	}
	setmetatable(this, self)
	return this	
end

-- draws player in center of screen
function Player:Draw()
	love.graphics.draw(self.sprite, self.xpos, self.ypos)
end

function Player:Movement(dt)
	if love.keyboard.isDown("w" or "up") and self.ypos < window_h + self.sprite:getHeight() then
		self.ypos = self.ypos - self.speed * dt
	elseif love.keyboard.isDown("s" or "down")  and self.ypos < window_h - self.sprite:getHeight() then
		self.ypos = self.ypos + self.speed * dt
	elseif love.keyboard.isDown("a" or "left") then
		self.xpos = self.xpos - self.speed * dt
	elseif love.keyboard.isDown("d" or "right") then
		self.xpos = self.xpos + self.speed * dt
	end
end