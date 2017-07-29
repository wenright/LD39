-- A rigidbody is an object that has a position and is influenced by both gravity and world physics. Also has a width and height.
local Rigidbody = Class {__includes = Transform}

function Rigidbody:init(properties)
  Transform.init(self, properties)

  self.w = properties.colliderW or properties.w or Map.tileSize
  self.h = properties.colliderH or properties.h or Map.tileSize

	self.colliderOffsetX, self.colliderOffsetY = properties.colliderOffsetX or 0, properties.colliderOffsetY or 0

  self.gravity = properties.gravity or World.gravity
  self.drag = properties.drag or World.drag

  Game.world:add(self)
end

function Rigidbody:update(dt)
	-- Apply gravity
	self:addForce(0, -self.gravity * dt)

	-- Apply linear drag
	self.velocity.x = self.velocity.x * (1 / (1 + (dt * self.drag)))

	-- Attempt to move rigidby in physics environment
	local data = Game.world:move(self, self.position.x + self.velocity.x * dt, self.position.y + self.velocity.y * dt, self.filterFunction)

	self.position.x = data.x
	self.position.y = data.y

	if data.collided then
		for k, col in pairs(data.collisions) do
			if self.collide then
				self:collide(col)
			end

			if col.normal.x ~= 0 then
				self.velocity.x = 0
			end

			if col.normal.y ~= 0 then
				self.velocity.y = 0
			end

			if col.normal.y == -1 then
				self.canJump = true;
			end
		end
	end
end

function Rigidbody:addForce(fx, fy)
	assert(fx and fy, 'Invalid parameters to function addForce')

	self.velocity.x = self.velocity.x + fx
	self.velocity.y = self.velocity.y + fy
end

function Rigidbody:setForce(fx, fy)
	assert(fx and fy, 'Invalid parameters to function setForce')

	self.velocity.x = fx
	self.velocity.y = fy
end

return Rigidbody
