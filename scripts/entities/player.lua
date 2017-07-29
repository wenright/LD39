local Player = Class {__includes = Actor}

function Player:init(properties)
	Actor.init(self, properties)

	self.canShoot = true

	self.timer = Timer.new()
	self.timeRunning = 0

	self.filterFunction = function(item, other)
		if other.type == 'Bullet' then
			return nil
		else
			return 'slide'
		end
	end

	self.type = 'Player'
end

function Player:update(dt)
	self.timer:update(dt)
	self.timeRunning = self.timeRunning + dt

	self.canJump = false

	Actor.update(self, dt)

	self:move(dt)

	Camera:lockPosition(self.position.x, self.position.y, Camera.smooth.damped(5))
end

function Player:move(dt)
	if love.keyboard.isDown('a', 'left') then
		self.flipped = -1
		self.animation:update(dt)

		self:setForce(-self.speed, self.velocity.y)
	elseif love.keyboard.isDown('d', 'right') then
		self.flipped = 1
		self.animation:update(dt)

		self:setForce(self.speed, self.velocity.y)
	else
		self.animation:gotoFrame(1)
		self.position.x = self:getX()
		self.position.y = self:getY()
	end

	if love.keyboard.isDown('space', 'w', 'up') then
		self:jump()
	end
end

function Player:mousepressed(btn, x, y)
	if btn == 1 and self.canShoot then
		self.canShoot = false
		print('Player shot')

		local bullet = {
			x = self.position.x,
			y = self.position.y,
			time = self.timeRunning,
			dir = self.flipped
		}

		Instantiate(Bullet(bullet))
	end
end

function Player:draw()
	Actor.draw(self)
end

return Player
