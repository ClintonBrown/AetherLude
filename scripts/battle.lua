-- Class that controls random encounters with enemies

local Battle = {}
Battle.__index = Battle

-- create a battle control object
function Battle:Create()
	local this = { 	battle_chance   = love.math.random(24, 120), -- movement range in pixels for a battle to start
					is_battle       = false,
					intro_input     = false,
					choice_selected = 0,
					enemy_health    = 25,
					enemy_damage    = 2,
					CHOICES_OFFSET  = 2,
					CHOICES_GAP     = 5,
					CHOICES_YPOS    = 0,
					CHOICES_WIDTH   = 0,
					CHOICES_HEIGHT  = 0,
					FIGHT_XPOS      = 0,
					HEAL_XPOS       = 0,
					RUN_XPOS        = 0 }

	setmetatable(this, self)
	return this	
end

-- load variables for battle UI
function Battle:Load(tset, msgbox)
	self.CHOICES_WIDTH  = WINDOW_WIDTH / 4
	self.CHOICES_HEIGHT = tset.tile_size
	self.FIGHT_XPOS     = self.CHOICES_OFFSET
	self.CHOICES_YPOS   = self.CHOICES_OFFSET
	self.HEAL_XPOS      = self.CHOICES_OFFSET + self.CHOICES_WIDTH + self.CHOICES_GAP
	self.RUN_XPOS       = self.CHOICES_OFFSET + (self.CHOICES_WIDTH + self.CHOICES_GAP) * 2
end

-- start a battle
function Battle:Start(msgbox, pl_obj)
	-- start battle if pixels moved by player equals the chance
	if self.battle_chance == pl_obj.moved then
		self.is_battle = true
		msgbox.message = "An ANOMALY attacks!"
		msgbox.enabled = true
		
		-- reset pixels moved and recalculate battle chance
		pl_obj.moved = 0
		self.battle_chance = love.math.random(24, 120)
	end

end

-- continue a battle
function Battle:Continue(msgbox)
	if self.is_battle then
		-- check battle logic
		if self.intro_input == false then
			-- clear selected choice highlight
			self.choice_selected = 0
			
			-- wait for input to bypass battle intro message
			function love.keypressed(key)
				if key == "space" or key == "return" then
					self.intro_input    = true
					self.choice_selected = 1
				end
			end
		elseif self.intro_input then
			-- show choice prompt and get choice input
			msgbox.message = "The ANOMALY floats around. What do you want to do?"
			msgbox.enabled = true
			self:SelectChoice()
		end
	end
end

-- controls choice selection on menu during battle
function Battle:SelectChoice()
	-- change the selected battle choice option
	function love.keypressed(key)
		if (key == "a" or key == "left") and self.choice_selected > 1 then
			self.choice_selected = self.choice_selected - 1
		elseif (key == "d" or key == "right") and self.choice_selected < 3 then
			self.choice_selected = self.choice_selected + 1
		elseif key == "space" or key == "return" then
			self.intro_input = false
			self.is_battle   = false
		end
	end
end

-- draw choices for battle based on selection
function Battle:DrawChoiceBoxes()
	if self.is_battle then
		
		if self.choice_selected == 1 then
			-- FIGHT is selected
			self:DrawFightChoice(0, 0, 255, 255)
			self:DrawHealChoice(0, 0, 40, 200)
			self:DrawRunChoice(0, 0, 40, 200)
			
		elseif self.choice_selected == 2 then
			-- HEAL is selected
			self:DrawFightChoice(0, 0, 40, 200)
			self:DrawHealChoice(0, 0, 255, 255)
			self:DrawRunChoice(0, 0, 40, 200)
			
		elseif self.choice_selected == 3 then
			-- RUN is selected
			self:DrawFightChoice(0, 0, 40, 200)
			self:DrawHealChoice(0, 0, 40, 200)
			self:DrawRunChoice(0, 0, 255, 255)
		elseif self.choice_selected == 0 then
			-- battle is not currently taking inputs
			self:DrawFightChoice(0, 0, 40, 200)
			self:DrawHealChoice(0, 0, 40, 200)
			self:DrawRunChoice(0, 0, 40, 200)
			
		end
	end
end

function Battle:DrawChoiceText(gfx_scaler)
	if self.is_battle then
		local font = love.graphics.newFont("alphbeta.ttf", 20)
		local f_xmod = 1.5
		local h_xmod = 2.5
		local r_xmod = 4
		local ypos = self.CHOICES_HEIGHT / 2
		
		-- draw fight text in choice box
		love.graphics.setFont(font)
		love.graphics.printf("FIGHT", (self.FIGHT_XPOS + f_xmod) * gfx_scaler, ypos * gfx_scaler, self.CHOICES_WIDTH * gfx_scaler)
		
		-- draw heal text in choice box
		love.graphics.setFont(font)
		love.graphics.printf("HEAL", (self.HEAL_XPOS + h_xmod) * gfx_scaler, ypos * gfx_scaler, self.CHOICES_WIDTH * gfx_scaler)
		
		-- draw run text in choice box
		love.graphics.setFont(font)
		love.graphics.printf("RUN", (self.RUN_XPOS + r_xmod) * gfx_scaler, ypos * gfx_scaler, self.CHOICES_WIDTH * gfx_scaler)
		
		
	end
end

-- draw the fight choice
-- RGBA parameters are for box background
function Battle:DrawFightChoice(r, g, b, a)
	-- draw fight choice box background
	love.graphics.setColor(r, g, b, a)
	love.graphics.rectangle("fill", self.FIGHT_XPOS, self.CHOICES_YPOS, self.CHOICES_WIDTH, self.CHOICES_HEIGHT)
	-- draw fight choice box box border
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.rectangle("line", self.FIGHT_XPOS, self.CHOICES_YPOS, self.CHOICES_WIDTH, self.CHOICES_HEIGHT)
end

-- draw the heal choice
-- RGBA parameters are for box background
function Battle:DrawHealChoice(r, g, b, a)
	-- draw heal choice box background
	love.graphics.setColor(r, g, b, a)
	love.graphics.rectangle("fill", self.HEAL_XPOS, self.CHOICES_YPOS, self.CHOICES_WIDTH, self.CHOICES_HEIGHT)
	-- draw heal choice box box border
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.rectangle("line", self.HEAL_XPOS, self.CHOICES_YPOS, self.CHOICES_WIDTH, self.CHOICES_HEIGHT)
end

-- draw the run choice
-- RGBA parameters are for box background
function Battle:DrawRunChoice(r, g, b, a)
	-- draw run choice box background
	love.graphics.setColor(r, g, b, a)
	love.graphics.rectangle("fill", self.RUN_XPOS, self.CHOICES_YPOS, self.CHOICES_WIDTH, self.CHOICES_HEIGHT)
	-- draw run choice box box border
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.rectangle("line", self.RUN_XPOS, self.CHOICES_YPOS, self.CHOICES_WIDTH, self.CHOICES_HEIGHT)
end

return Battle