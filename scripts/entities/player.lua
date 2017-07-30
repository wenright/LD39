local Player = Class {__includes = Actor}

function Player:init(properties)
	Actor.init(self, properties)

	self.canShoot = true
	self.ROF = 0.2

	self.timer = Timer.new()

	self.filterFunction = function(item, other)
		if other.type == 'Bullet' then
			return nil
		elseif other.type == 'Sunbeam' then
			return nil
		else
			return 'slide'
		end
	end

	self.maxCharges = 3
	self.weaponCharges = self.maxCharges

	self.type = 'Player'
end

function Player:update(dt)
	self.timer:update(dt)

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

-- Charge the player's weapon at each tick
function Player:charge(dt)
	-- TODO does weapon charge more the longer stood in light, or even a split second would be full charge?
	self.weaponCharges = self.maxCharges
end

function Player:keypressed(btn)
	if btn == 'z' and self.canShoot and self.weaponCharges > 0 then
		local bullet = {
			x = self.position.x,
			y = self.position.y,
			time = self.timeRunning,
			dir = self.flipped
		}

		Instantiate(Bullet(bullet))

		self.weaponCharges = self.weaponCharges - 1

		self.canShoot = false
		self.timer:after(self.ROF, function()
			self.canShoot = true
		end)
	end
end

function Player:drawBlack()
	love.graphics.setColor(0, 0, 0)
	self:draw()

	Camera:detach()
	self:drawBlackGUI()
	Camera:attach()
end

function Player:drawWhite()
	love.graphics.setColor(255, 255, 255)
	self:draw()

	Camera:detach()
	self:drawWhiteGUI()
	Camera:attach()
end

function Player:drawGUI()

end

function Player:drawWhiteGUI()
	love.graphics.setColor(255, 255, 255)
	self:drawGUI()
end

function Player:drawBlackGUI()
	love.graphics.setColor(0, 0, 0)
	self:drawGUI()
end

function Player:drawGUI()
	-- Draw player's weapon charges
	for i=1, Game.player.maxCharges do
		local x = 60 * i - 30
		local y = 30
		local w = 30
		local h = 15

		if i <= Game.player.weaponCharges then
			love.graphics.rectangle('fill', x, y, w, h)
			love.graphics.rectangle('line', x, y, w, h)
		else
			love.graphics.rectangle('line', x, y, w, h)
		end
	end
end

return Player
