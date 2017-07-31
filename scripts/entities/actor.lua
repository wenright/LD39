-- An actor is simulated in physics and will make decisions that influence its position
local Actor = Class {__includes = Rigidbody}

function Actor:init(properties)
	properties.colliderW, properties.colliderH = properties.w or 6, properties.h or 16
	properties.colliderOffsetX, properties.colliderOffsetY = 5, 0

	Rigidbody.init(self, properties)

	self.speed = properties.speed or 100
	self.jumpForce = properties.jumpForce or 200
	self.canJump = true

	self.w, self.h = 16, 16
	self.image = love.graphics.newImage(properties.spritesheet or 'art/player-sheet.png')
	local g = Animation.newGrid(self.w, self.h, self.image:getWidth(), self.image:getHeight())
	self.animation = Animation.newAnimation(g('1-8', 1), 0.075)

	self.flipped = 1
end

function Actor:update(dt)
	Rigidbody.update(self, dt)
end

function Actor:drawBlack()
	love.graphics.setColor(Color.black)
	self:draw()
end

function Actor:drawWhite()
	love.graphics.setColor(Color.white)
	self:draw()
end

function Actor:draw()
	self.animation:draw(self.image, self.position.x + self.w / 2 - self.colliderOffsetX, self.position.y, 0, self.flipped, 1, self.w / 2)
end

function Actor:jump()
	if self.canJump then
		self:addForce(0, -self.jumpForce)
		self.canJump = false
	end
end

return Actor
