-- Class that controls random encounters with enemies

local Battle = {}
Battle.__index = Battle

-- create a battle control object
function Battle:Create(img)
	local this = { 	battle_chance   = love.math.random(24, 120), -- movement range in pixels for a battle to start
					enemy_sprite    = img,
					dice            = 0,
					is_battle       = false,
					msg_input       = false,
					end_msg_input   = true,
					choice_selected = 0,
					enemy_health    = 25,
					enemy_attack    = 2,
					CHOICES_OFFSET  = 2,
					CHOICES_GAP     = 5,
					CHOICES_YPOS    = 0,
					CHOICES_WIDTH   = 0,
					CHOICES_HEIGHT  = 0,
					FIGHT_XPOS      = 0,
					HEAL_XPOS       = 0,
					RUN_XPOS        = 0,
					PL_HEALTH_YPOS  = 36 }

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
function Battle:Continue(msgbox, pl_obj, gfx_scaler)
	if self.is_battle then
		-- check if player is out of health
		if pl_obj.health < 1 then
			-- set player health to 0 so it doesn't show negative
			pl_obj.health = 0
			pl_obj.is_dead = true
		end
		
		-- check battle logic
		if self.msg_input == false and pl_obj.health > 0 then
			msgbox.enabled = true
			-- clear selected choice highlight
			self.choice_selected = 0
			
			-- wait for input to bypass battle intro message
			function love.keypressed(key)
				if key == "space" or key == "return" and self.second_message == false then
					self.msg_input     = true
					self.choice_selected = 1
				end
			end
		elseif (self.msg_input and pl_obj.health > 0) then
			-- show choice prompt and get choice input
			msgbox.message = "The ANOMALY floats around. What do you want to do?"
			msgbox.enabled = true
			self:SelectChoice(msgbox, pl_obj, gfx_scaler)
			
		end
	elseif self.end_msg_input == false and pl_obj.health > 0 then
		msgbox.enabled = true
		
		-- wait for input to bypass battle end message
		function love.keypressed(key)
			if key == "space" or key == "return" and self.second_message == false then
				self.end_msg_input = true
			end
		end
	end
end

-- controls choice selection on menu during battle
function Battle:SelectChoice(msgbox, pl_obj, gfx_scaler)
	-- battle choice options
	function love.keypressed(key)
		-- change highlighted selection
		if (key == "a" or key == "left") and self.choice_selected > 1 then
			self.choice_selected = self.choice_selected - 1
			
		elseif (key == "d" or key == "right") and self.choice_selected < 3 then
			self.choice_selected = self.choice_selected + 1
			
		-- FIGHT
		elseif (key == "space" or key == "return") and self.choice_selected == 1 then		
			-- calculate player damage and subtract from enemy's health
			self.dice = love.math.random(1, 6)
			local damage = pl_obj.attack * self.dice
			self.enemy_health = self.enemy_health - damage
			
			msgbox.message = "You damaged the ANOMALY for ".. damage .. " hit points!"
			
			if self.enemy_health < 1 then
				-- exit battle
				msgbox.message = msgbox.message .. "\nYou defeated the ANOMALY!"
				self:ExitBattle()
			else
				-- calculate enemy damage and subtract from player's health
				self.dice = love.math.random(1, 6)
				damage = self.enemy_attack * self.dice
				pl_obj.health = pl_obj.health - damage
				
				msgbox.message = msgbox.message .. "\nThe ANOMALY hits you for ".. damage .. " hit points!"
				self.msg_input = false
				self.choice_selected = 0
			end
			
		-- HEAL
		elseif (key == "space" or key == "return") and self.choice_selected == 2 then
			-- roll for player's heal and add to player's health
			self.dice = love.math.random(1, 6)
			local heal = pl_obj.magic * self.dice
			pl_obj.health = pl_obj.health + heal
			
			-- if player health goes over max reset it to it's max
			if pl_obj.health > pl_obj.max_hp then
				pl_obj.health = pl_obj.max_hp
				msgbox.message = "You healed YOURSELF to max hit points!"
			else
				msgbox.message = "You healed YOURSELF for ".. heal .. " hit points!"
			end
			
			
			if self.enemy_health < 1 then
				-- exit battle
				msgbox.message = msgbox.message .. "\nYou defeated the ANOMALY!"
				self:ExitBattle()
			else
				-- calculate enemy damage and subtract from player's health
				self.dice = love.math.random(1, 6)
				local damage = self.enemy_attack * self.dice
				pl_obj.health = pl_obj.health - damage
				
				msgbox.message = msgbox.message .. "\nThe ANOMALY hits you for ".. damage .. " hit points!"
				self.msg_input = false
				self.choice_selected = 0
			end
			
		-- RUN
		elseif (key == "space" or key == "return") and self.choice_selected == 3 then 
			-- 50% chance to run
			self.dice = love.math.random(1, 100)
			if self.dice > 49 then
				-- exit battle
				msgbox.message = "You ran away!"
				self:ExitBattle()
			else
				msgbox.message = "You failed to run!"
				self.msg_input = false
				self.choice_selected = 0
			end
		end
	end
end

-- resets battle variables and exits the battle
function Battle:ExitBattle()
	self.dice            = 0
	self.choice_selected = 0
	self.enemy_health    = 25
	self.end_msg_input   = false
	self.msg_input       = false
	self.is_battle       = false
end

-- draw the enemy
function Battle:DrawEnemy()
	if self.is_battle then
		local enemy_w = self.enemy_sprite:getWidth()
		local enemy_h = self.enemy_sprite:getHeight()
		local xpos    = (WINDOW_WIDTH / 2) - (enemy_w / 2)
		local ypos    = (WINDOW_HEIGHT / 2) - enemy_h
		
		-- draw a backdrop rectangle for the enemy
		love.graphics.setColor(0, 0, 40, 230)
		love.graphics.rectangle("fill", xpos - (enemy_w / 2), ypos - (enemy_h / 2), self.enemy_sprite:getWidth() * 2, self.enemy_sprite:getHeight() * 2)
		
		-- draw a backdrop outline rectangle for the enemy
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.rectangle("line", xpos - (enemy_w / 2), ypos - (enemy_h / 2), self.enemy_sprite:getWidth() * 2, self.enemy_sprite:getHeight() * 2)
		
		-- draw the enemy
		love.graphics.draw(self.enemy_sprite, xpos, ypos)
	end
end

-- draw the box that shows player health
function Battle:DrawPlayerHealthBox()
	if self.is_battle then		
		-- draw fight choice box background
		love.graphics.setColor(0, 0, 40, 230)
		love.graphics.rectangle("fill", self.FIGHT_XPOS, self.PL_HEALTH_YPOS, self.CHOICES_WIDTH + 1, self.CHOICES_HEIGHT)
		-- draw fight choice box box border
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.rectangle("line", self.FIGHT_XPOS, self.PL_HEALTH_YPOS, self.CHOICES_WIDTH + 1, self.CHOICES_HEIGHT)
	end
end

-- draw the player health text
function Battle:DrawPlayerHealthText(pl_obj, gfx_scaler)
	if self.is_battle then
		local font    = love.graphics.newFont("alphbeta.ttf", 20)
		local hp_xmod = 1
		local ypos    = self.PL_HEALTH_YPOS + (self.CHOICES_HEIGHT / 4)
		
		-- draw HP text in choice box
		love.graphics.setFont(font)
		love.graphics.printf("HP: ".. pl_obj.health, (self.FIGHT_XPOS + hp_xmod) * gfx_scaler, ypos * gfx_scaler, self.CHOICES_WIDTH * gfx_scaler)
	end
end

-- draw boxes for choices for battle based on selection
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

-- draw the text for battle UI
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