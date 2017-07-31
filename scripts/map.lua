local Map = Class {tileSize = 16}

local numTiles = 24
local mapWidth = Map.tileSize * numTiles

function Map:init(filename, xOffset)
	self.xOffset = xOffset or 0

	self.tiles = EntitySystem()

	function addTile(x, y, tileId)
		if tileId == '' or tileId == ' ' then return end

		self.tiles:add(Tile({
			x = x + self.xOffset,
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

function Map:update(dt)
	if self.isFurthest then
		if math.abs(Camera.x - (mapWidth + self.xOffset)) < mapWidth then
			-- Spawn a new map chunk
			local newChunk = Instantiate(Map(
				'maps/map1.csv',
				self.xOffset + mapWidth
			))

			newChunk:addEnemies()
			newChunk:addSunbeams()

			-- Update which chunk is the furthest
			newChunk.isFurthest = true
			self.isFurthest = false
			self.nextChunk = newChunk
		end

		-- Destroy the oldest chunk once it is far enough away
		if Game:isOutOfView(Game.oldestChunk.xOffset + mapWidth) then
			local oldestChunk = Game.oldestChunk
			Game.oldestChunk = oldestChunk.nextChunk

			Destroy(oldestChunk)
		end
	end
end

function Map:addEnemies()
	Game.sunbeams:add(Sunbeam {
		x = self.xOffset + math.random(mapWidth * (1/4), mapWidth * (3/4)),
		y = 0
	})
end

function Map:addSunbeams()
	local numEnemies = math.random(1, 4)
	for i=1, numEnemies do
		Instantiate(Enemy {x = self.xOffset + math.random() * mapWidth, y = -128})
	end
end

function Map:drawBlack()
	self.tiles:loop('drawBlack')
end

function Map:drawWhite()
	self.tiles:loop('drawWhite')
end

function Map:draw()
	self.tiles:loop('draw')
end

return Map
