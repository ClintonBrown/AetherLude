-- Collision detection

local Collision = {}

-- perform collision checks for an object with 4-direction movement
-- object must have xpos, ypos, and sprite
function Collision.UpdateCollision(object, map_w, map_h, m1c)
	-- reset collision check
	local is_collision = { left = false, right = false, up = false, down = false }
	
	-- some equal same value now, set up is for modularity if non-square sprites are ever used
	local C_GAPY    = object.collider.height / 4
	local C_GAPX    = object.collider.width / 4
	local C_THICK   = 1
	
	-- check for collisions with boxes on map
	for y = 1, map_w do
		for x = 1, map_h do
			-- if there is a collision report it
			if m1c[y][x] ~= nil then
				
				-- Check for collisions on left, right, top, and bottom of player collision box
				if Collision.CheckCollision(object.collider.x, (object.collider.y + C_THICK), C_THICK, (object.collider.height - C_GAPY),
										    (m1c[y][x].x + C_GAPX), m1c[y][x].y, (m1c[y][x].width - C_GAPX), m1c[y][x].height) then
				-- there was a collision between LEFT of player and RIGHT of collidable tile
				is_collision.left = true
				end
				
				if Collision.CheckCollision((object.collider.x + (object.collider.width - C_THICK)), (object.collider.y + C_THICK), C_THICK, (object.collider.height - C_GAPY),
											 m1c[y][x].x, m1c[y][x].y, (m1c[y][x].width - C_GAPX), m1c[y][x].height) then
				-- there was a collision between RIGHT of player and LEFT of collidable tile
				is_collision.right = true
				end
				
				if Collision.CheckCollision((object.collider.x + C_THICK), object.collider.y, (object.collider.width - C_GAPX), C_THICK,
										     m1c[y][x].x, (m1c[y][x].y + C_GAPY), m1c[y][x].width, (m1c[y][x].height - C_GAPY)) then
				-- there was a collision between TOP of player and BOTTOM of collidable tile
				is_collision.up = true
				end
				
				if Collision.CheckCollision((object.collider.x + C_THICK), (object.collider.y + (object.collider.height - C_THICK)), (object.collider.width - C_GAPX), C_THICK,
										     m1c[y][x].x, m1c[y][x].y, m1c[y][x].width, (m1c[y][x].height - C_GAPY)) then
				-- there was a collision between BOTTOM of player and TOP of collidable tile
				is_collision.down = true
				end
			
			end
		end
	end
	
	return is_collision
end

-- checks if box is overlapping another box
-- returns: true if boxes are colliding
function Collision.CheckCollision(x1, y1, w1, h1, x2, y2, w2, h2)
	return  x1 < x2+w2 and
			x2 < x1+w1 and
            y1 < y2+h2 and
            y2 < y1+h1
end

return Collision