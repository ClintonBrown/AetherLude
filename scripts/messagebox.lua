-- Popup message box class

local MessageBox = {}
MessageBox.__index = MessageBox

function MessageBox:Create(msg)
	local this = {
		MB_GAP    = 2,
		MB_WIDTH  = 0,
		MB_HEIGHT = 0,
		mb_xpos   = 0,
		mb_ypos   = 0,
		message   = msg,
		enabled   = false }
	
	setmetatable(this, self)
	return this
end

-- initialize messagebox size/location parameters
function MessageBox:Load()
	self.MB_WIDTH  = WINDOW_WIDTH - (self.MB_GAP * 2)
	self.MB_HEIGHT = WINDOW_HEIGHT / 4
	self.mb_xpos   = self.MB_GAP
	self.mb_ypos   = WINDOW_HEIGHT - (WINDOW_HEIGHT / 4) - self.MB_GAP
end

-- get input from user to continue past this messagebox
function MessageBox:Continue()
	if self.enabled then
		-- if key is pressed close messagebox
		if love.keyboard.isDown("space") or love.keyboard.isDown("return") then
			self.enabled = false
		end
	end
end

function MessageBox:DrawBox()
	if self.enabled then
	-- draw message box background
		love.graphics.setColor(0, 0, 40, 255)
		love.graphics.rectangle("fill", self.mb_xpos, self.mb_ypos, self.MB_WIDTH, self.MB_HEIGHT)
		-- draw message box border
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.rectangle("line", self.mb_xpos, self.mb_ypos, self.MB_WIDTH, self.MB_HEIGHT)
	end
end

function MessageBox:DrawText(gfx_scaler)
	if self.enabled then
		local font = love.graphics.newFont("alphbeta.ttf", 14)
		
		-- draw text in message box
		love.graphics.setFont(font)
		love.graphics.printf(self.message, (self.mb_xpos + self.MB_GAP) * gfx_scaler, (self.mb_ypos + self.MB_GAP) * gfx_scaler, self.MB_WIDTH * gfx_scaler)
	end
end

return MessageBox