local Tile = Class {
	__includes = Transform,
	tiles = {
		a = love.graphics.newImage('art/floor-1.png'),
		b = love.graphics.newImage('art/floor-2.png'),
		c = love.graphics.newImage('art/wall-left-1.png'),
		d = love.graphics.newImage('art/corner-bl-1.png'),
		e = love.graphics.newImage('art/wall-right-1.png'),
		f = love.graphics.newImage('art/box-full.png'),
		g = love.graphics.newImage('art/box-middle.png'),
		h = love.graphics.newImage('art/spike.png')
	}
}

function Tile:init(properties)
	Transform.init(self, properties)

	self.w, self.h = Map.tileSize, Map.tileSize
	self.id = properties.tileId

	Game.world:add(self)

	assert(self.tiles[self.id], 'That tile does not exist')
	self.img = self.tiles[self.id]

	self.parentSystem = properties.parentSystem

	self.type = 'Tile'
end

function Tile:drawBlack()
	love.graphics.setColor(Color.black)
	self:draw()
end

function Tile:drawWhite()
	love.graphics.setColor(Color.white)
	self:draw()
end

function Tile:draw()
	love.graphics.draw(self.img, self.position.x, self.position.y)
end

function Tile:destroy()
	if Game.world:hasItem(self) then
		Game.world:remove(self)
	end

	self.parentSystem:remove(self)
end

return Tile
