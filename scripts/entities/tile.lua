local Tile = Class {
	__includes = Transform,
	type = 'tile',
	tiles = {
		g = love.graphics.newImage('art/tile1.png')
	}
}

function Tile:init(properties)
	Transform.init(self, properties)

	-- self.img = properties.img
	self.w, self.h = Map.tileSize, Map.tileSize
	self.id = properties.tileId

	Game.world:add(self)

	self.img = self.tiles[self.id]
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
