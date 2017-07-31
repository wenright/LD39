local Bullet = Class {__includes = Actor}

function Bullet:init(properties)
	properties.w, properties.h = 4, 4

	Actor.init(self, properties)

	self.gravity = 0
	self.filterFunction = function(item, other)
		if other.type == 'Tile' then
			return 'touch'
		else
			return nil
		end
	end

	self.velocity.x = (150 + properties.parentVx / 4) * (properties.dir or 1)
	self.drag = 0.5
	self.lifetime = 1

	self.timer = Timer.new()
	self.timer:after(self.lifetime, function()
		Destroy(self)
	end)

	love.audio.newSource('sound/laser2.wav', 'static'):play()

	self.type = 'Bullet'
end

function Bullet:update(dt)
	Actor.update(self, dt)

	self.timer:update(dt)
end

function Bullet:drawWhite()
	love.graphics.setColor(Color.white)
	self:draw()
end

function Bullet:drawBlack()
	love.graphics.setColor(Color.black)
	self:draw()
end

function Bullet:draw()
	love.graphics.rectangle('fill', self.position.x, self.position.y, 2, 2)
end

function Bullet:collide(col)
	love.audio.newSource('sound/Hit_Hurt90.wav', 'static'):play()

	if col.other.type == 'Tile' then
		Timer.after(0, function() Destroy(self) end)

		Timer.after(0, function() col.other:destroy() end)
	end
end


return Bullet
