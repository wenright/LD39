local Bullet = Class {__includes = Actor}

function Bullet:init(properties)
	Actor.init(self, properties)

	self.gravity = 0
	self.filterFunction = function()
		return nil
	end

	self.velocity.x = 150 * (properties.dir or 1)
	self.drag = 0.5
	self.lifetime = 1

	self.type = 'Bullet'

	self.timer = Timer.new()
	self.timer:after(self.lifetime, function()
		Destroy(self)
	end)
end

function Bullet:update(dt)
	Actor.update(self, dt)

	self.timer:update(dt)
end

function Bullet:drawWhite()
	love.graphics.setColor(255, 255, 255)
	self:draw()
end

function Bullet:drawBlack()
	love.graphics.setColor(0, 0, 0)
	self:draw()
end

function Bullet:draw()
	love.graphics.rectangle('fill', self.position.x, self.position.y, 2, 2)
end

return Bullet
