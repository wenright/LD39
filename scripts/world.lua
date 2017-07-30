-- Pretty much just a wrapper around bump's functins. May be useful later on for tweaking bump without modifying the library itself.
local World = Class {
	gravity = -500,
	drag = 50
}

function World:init(properties)
	self.world = Bump.newWorld(8)
end

function World:add(obj)
	assert(obj, 'Physics object is nil')
	assert(obj.position and obj.position.x and obj.position.y, 'Physics objects must have an x and y position')
	assert(obj.w and obj.h, 'Physics objects must have a width and a height')

	self.world:add(obj, obj.position.x, obj.position.y, obj.w, obj.h)
end

function World:remove(obj)
	self.world:remove(obj)
end

function World:hasItem(obj)
	return self.world:hasItem(obj)
end

function World:getItems()
	return self.world:getItems()
end

function World:move(obj, x, y, filter)
	local newX, newY, collisions, len = self.world:move(obj, x, y, filter)

	return {
		x = newX,
		y = newY,
		collisions = collisions,
		collided = len > 0
	}
end

return World
