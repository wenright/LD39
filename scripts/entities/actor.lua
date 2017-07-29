-- An actor is simulated in physics and will make decisions that influence its position
local Actor = Class {__includes = Rigidbody}

function Actor:init(properties)
	Rigidbody.init(self, properties)

	self.speed = properties.speed or 100
	self.jumpForce = properties.jumpForce or 150
	self.canJump = true

	self.image = love.graphics.newImage('art/player_walking.png')
	local g = Animation.newGrid(self.w, self.h, self.image:getWidth(), self.image:getHeight())
	self.animation = Animation.newAnimation(g('1-4', 1), 0.075)

	self.flipped = 1
end

function Actor:update(dt)
	Rigidbody.update(self, dt)
end

function Actor:draw()
	-- love.graphics.setColor(55, 55, 123)
	-- love.graphics.rectangle('fill', self:getX(), self:getY(), self.w, self.h)

	love.graphics.setColor(255, 255, 255)
	self.animation:draw(self.image, self.position.x + self.w / 2, self.position.y, 0, self.flipped, 1, self.w / 2)
end

function Actor:jump()
	if self.canJump then
		self:addForce(0, -self.jumpForce)
		self.canJump = false
	end
end

return Actor
