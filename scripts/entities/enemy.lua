local Enemy = Class {__includes = Actor}

function Enemy:init(properties)
	properties.spritesheet = 'art/hazmat-sheet.png'

	Actor.init(self, properties)

	self.speed = 50

	self.filterFunction = function(item, other)
		if other.type == 'Bullet' then
			return 'cross'
		elseif other.type == 'Enemy' then
			return nil
		elseif other.type == 'Sunbeam' then
			return nil
		else
			return 'slide'
		end
	end

	self.timer = Timer.new()
	self:startMoveTimer()

	self.type = 'Enemy'
end

function Enemy:update(dt)
	Actor.update(self, dt)

	self.timer:update(dt)

	if Game:isOutOfView(self.position.x + self.w) then
		Destroy(self)
	end
end

function Enemy:draw()
	Actor.draw(self)
end

function Enemy:collide(col)
	if col.other.type == 'Bullet' then
		love.audio.newSource('sound/Hit_Hurt91.wav', 'static'):play()

		Timer.after(0, function() Destroy(col.other) end)

		-- TODO damage
		Timer.after(0, function() Destroy(self) end)
	end
end

function Enemy:startMoveTimer()
	local waitTime = self:getRandomMovementTime()
	local moveTime = self:getRandomMovementTime() / 2 + 1

	self.timer:after(waitTime, function()
		local moveLeft = math.random() > 0.5

		self.timer:during(moveTime, function(dt)
			if moveLeft then
				self:moveLeft(dt)
			else
				self:moveRight(dt)
			end
		end, function()
			self:resetAnimation()

			self:startMoveTimer()
		end)
	end)
end

function Enemy:collide(col)
	local other = col.other

	if other.type == 'Tile' then

		if other.id == 'h' then
			if col.normal.y == -1 then
				Destroy(self)
			end
		end
	end
end

function Enemy:getRandomMovementTime()
	local min = 1
	local max = 3
	return math.random(min, max)
end

return Enemy
