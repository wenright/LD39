-- A transform has only a position
local Transform = Class {}

function Transform:init(properties)
	assert(properties, 'All transforms must have a properties table as input')

	self.position = {
		x = properties.x or 0,
		y = properties.y or 0
	}

	self.velocity = {
		x = properties.vx or 0,
		y = properties.vy or 0
	}
end

function Transform:getX()
	return math.floor(self.position.x + 0.5)
end

function Transform:getY()
	return math.floor(self.position.y + 0.5)
end

return Transform