local Sunbeam = Class {
	__includes = Rigidbody
}

function Sunbeam:init(properties)
	self.rotation = math.pi / 8

	Rigidbody.init(self, properties)

	self.filterFunction = function(item, other)
		if other.type == 'Player' then
			return 'cross'
		else
			return nil
		end
	end

	self.shape = love.physics.newRectangleShape(self.position.x, self.position.y, self.w, self.h, -self.rotation)

	self.type = 'Sunbeam'
end

function Sunbeam:update(dt)
	if self:checkCollision() then
		Game.player:charge(dt)
	end
end

function Sunbeam:checkCollision()
	return self.shape:testPoint(0, 0, 0, Game.player.position.x, Game.player.position.y)
end

return Sunbeam
