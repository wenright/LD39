local Bullet = Class {__includes = Actor}

function Bullet:init(properties)
	Actor.init(self, properties)

	self.gravity = 0
	self.filterFunction = function()
		return nil
	end

	self.velocity.x = 150 * (properties.dir or 1)
	self.drag = 1

	self.type = 'Bullet'

	self.timer = Timer.new()
	self.timer:after(1, function()
		Destroy(self)
	end)
end

function Bullet:update(dt)
	Actor.update(self, dt)

	self.timer:update(dt)
end

function Bullet:draw()
	love.graphics.setColor(255, 0, 0)
	love.graphics.rectangle('fill', self.position.x, self.position.y, 2, 2)
end

return Bullet
