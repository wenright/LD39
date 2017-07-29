--- A collection of entities
-- @classmod Entities

local Entities = Class {
	type = 'entitysystem'
}

--- Initialize a new Entities object
function Entities:init()
  self.pool = {}
end

--- Add a new entity to the system
function Entities:add(obj)
	table.insert(self.pool, obj)
	return obj
end

--- Remove an entity from the system
function Entities:remove(e)
	for key, entity in pairs(self.pool) do
		if entity == e then
			self.pool[key] = nil
		end
	end
end

--- Draw all entities in the system
function Entities:loop(func, ...)
	for _, entity in pairs(self.pool) do
		if entity[func] then
			entity[func](entity, ...)
		end
	end
end

--- Find the entity at the given point
function Entities:getAtPoint(x, y)
	x, y = Camera:worldCoords(x, y)
	for _, entity in pairs(self.pool) do
		if entity:checkCollision(x, y) then
			return entity
		end
	end
end

--- Loop over each object, calling the given function on each entity
function Entities:forEach(func)
	for _, entity in pairs(self.pool) do
		func(entity)
	end
end

return Entities