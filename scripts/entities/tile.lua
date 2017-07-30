local Tile = Class {
	__includes = Transform,
	tiles = {
		a = love.graphics.newImage('art/floor-1.png'),
		b = love.graphics.newImage('art/floor-2.png'),
		c = love.graphics.newImage('art/wall-left-1.png'),
		d = love.graphics.newImage('art/corner-bl-1.png'),
		e = love.graphics.newImage('art/wall-right-1.png'),
		f = love.graphics.newImage('art/box-full.png'),
		g = love.graphics.newImage('art/box-middle.png')
	}
}

function Tile:init(properties)
	Transform.init(self, properties)

	-- self.img = properties.img
	self.w, self.h = Map.tileSize, Map.tileSize
	self.id = properties.tileId

	Game.world:add(self)

	self.img = self.tiles[self.id]

	self.type = 'Tile'
end

function Tile:drawBlack()
	love.graphics.setColor(0, 0, 0)
	self:draw()
end

function Tile:drawWhite()
	love.graphics.setColor(255, 255, 255)
	self:draw()
end

function Tile:draw()
	love.graphics.draw(self.img, self.position.x, self.position.y)
end

return Tile
