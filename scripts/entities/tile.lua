local Tile = Class {
	__includes = Transform,
	type = 'tile',
	tiles = {
		g = love.graphics.newImage('art/grass.png'),
		m = love.graphics.newImage('art/metal.png'),
		d = love.graphics.newImage('art/dirt.png'),
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

function Tile:draw()
	love.graphics.draw(self.img, self.position.x, self.position.y)
end

return Tile