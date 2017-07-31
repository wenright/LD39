local Player = Class {__includes = Actor}

function Player:init(properties)
	properties.spritesheet = 'art/player-weapon-sheet.png'

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
	self.weaponCharges = 0
	self.chargeSpeed = 1

	self.chargeSound = love.audio.newSource('sound/charge.wav', 'static')

	self.type = 'Player'
end

function Player:update(dt)
	self.timer:update(dt)

	self.canJump = false

	Actor.update(self, dt)

	if not Game.isOver then
		self:move(dt)
	end

	if not self.isCharging then
		self.chargeSound:stop()
	end

	self.isCharging = false
end

function Player:move(dt)
	if not Game.isOver and Game:isOutOfView(self.position.x) then
		Game.isOver = true

		Game.cameraAcceleration = 0
		Game.cameraSpeed = 0
	end

	if love.keyboard.isDown('a', 'left') then
		self:moveLeft(dt)
	elseif love.keyboard.isDown('d', 'right') then
		-- Prevent player from past camera view on the right
		if self:canMoveRight() then
			self:moveRight(dt)
		end
	else
		self:resetAnimation()
	end

	if not self.canJump then
		self:pauseAnimation()
	end

	if love.keyboard.isDown('space', 'w', 'up') then
		self:jump()
	end
end

-- Charge the player's weapon at each tick
function Player:charge(dt)
	if not self.chargeSound:isPlaying() and self.weaponCharges < self.maxCharges then
		self.chargeSound:play()
	end

	if self.weaponCharges == self.maxCharges then
		self.chargeSound:stop()
	end

	-- TODO does weapon charge more the longer stood in light, or even a split second would be full charge?
	self.weaponCharges = math.min(self.weaponCharges + dt * self.chargeSpeed, self.maxCharges)

	self.isCharging = true
end

function Player:keypressed(btn)
	if btn == 'z' and self.canShoot and self.weaponCharges >= 1 then
		local bullet = {
			x = self.position.x + self.flipped * 7,
			y = self.position.y + 8,
			time = self.timeRunning,
			dir = self.flipped,
			parentVx = self.velocity.x
		}

		Instantiate(Bullet(bullet))

		self.weaponCharges = self.weaponCharges - 1

		self.canShoot = false
		self.timer:after(self.ROF, function()
			self.canShoot = true
		end)
	end

	if Game.isOver and btn == 'r' then
		Game:enter()
	end
end

function Player:drawBlack()
	love.graphics.setColor(Color.black)
	self:draw()

	Camera:detach()
	self:drawBlackGUI()
	Camera:attach()
end

function Player:drawWhite()
	love.graphics.setColor(Color.white)
	self:draw()

	Camera:detach()
	self:drawWhiteGUI()
	Camera:attach()
end

function Player:drawWhiteGUI()
	love.graphics.setColor(Color.white)
	self:drawGUI()
end

function Player:drawBlackGUI()
	love.graphics.setColor(Color.black)
	self:drawGUI()
end

function Player:drawGUI()
	-- Draw game over if that's the case
	if Game.isOver then
		love.graphics.printf('Game over!', 0, love.graphics.getHeight() / 2, love.graphics.getWidth(), 'center')
		love.graphics.printf('\'r\' to retry', 0, love.graphics.getHeight() / 2 + 60, love.graphics.getWidth(), 'center')
	end

	-- Draw player's weapon charges
	for i=1, Game.player.maxCharges do
		local oldColor = {love.graphics.getColor()}

		local x = 45 * i - 30
		local y = 30
		local w = 30
		local h = 15

		if i <= Game.player.weaponCharges then
			love.graphics.rectangle('fill', x, y, w, h)
		elseif i > Game.player.weaponCharges and i < Game.player.weaponCharges + 1 then
			love.graphics.setColor(Color.grey)
			local diff = (Game.player.weaponCharges - math.floor(Game.player.weaponCharges))
			love.graphics.rectangle('fill', x, y, diff * w, h)

			love.graphics.setColor(oldColor)
			love.graphics.rectangle('line', x, y, w, h)
		else
			love.graphics.rectangle('line', x, y, w, h)
		end
	end
end

function Player:canMoveRight()
	return not (math.abs(self.position.x + self.w / 2 - Camera.x) > (love.graphics.getWidth() / 2) / Camera.scale)
end

return Player
