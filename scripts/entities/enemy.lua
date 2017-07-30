local Enemy = Class {__includes = Actor}

function Enemy:init(properties)
	properties.spritesheet = 'art/hazmat-sheet.png'

	Actor.init(self, properties)

	self.filterFunction = function(item, other)
		if other.type == 'Bullet' then
			return 'cross'
		elseif other.type == 'Sunbeam' then
			return nil
		else
			return 'slide'
		end
	end

	self.type = 'Enemy'
end

function Enemy:update(dt)
	Actor.update(self, dt)
end

function Enemy:draw()
	Actor.draw(self)
end

function Enemy:collide(col)
	if col.other.type == 'Bullet' then
		Timer.after(0, function() Destroy(col.other) end)

		-- TODO damage
		Timer.after(0, function() Destroy(self) end)
	end
end

return Enemy
