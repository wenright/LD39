local Map = Class {tileSize = 8}

function Map:init(filename)
	self.tiles = EntitySystem()

	function addTile(x, y, tileId)
		if tileId == '' or tileId == ' ' then return end

		self.tiles:add(Tile({
			x = x,
			y = y,
			tileId = tileId
		}))
	end

	local y = 0
	for line in love.filesystem.lines(filename) do
		local tileId = ''

		local x = 0
		for c in line:gmatch('.') do
			if c == ',' or c == '\n' then
				addTile(x, y, tileId)

				tileId = ''

				x = x + self.tileSize
			else
				tileId = tileId .. c
			end
		end

		addTile(x, y, tileId)

		y = y + self.tileSize
	end
end

function Map:draw()
	self.tiles:loop('draw')
end

return Map