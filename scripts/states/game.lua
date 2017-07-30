local Game = {}

function Game:enter()
	self.world = World()

	self.entities = EntitySystem()
	self.map = Instantiate(Map 'maps/map1.csv')
	self.player = Instantiate(Player {x = 24, y = 64})
	self.enemies = {
		Instantiate(Enemy {x = 128, y = 64}),
		Instantiate(Enemy {x = 96, y = 64}),
		Instantiate(Enemy {x = 64, y = 36})
	}

	love.graphics.setBackgroundColor(255, 255, 255)

	Camera:lookAt(24, 16)

	self.timer = Timer.new()

	self.sunbeams = EntitySystem()

	self.sunbeams:add(Sunbeam {x = 100, y = -100, w = 50, h = 1000})

	self.stencilFunction = function()
		self.sunbeams:forEach(function(sunbeam)
			love.graphics.setColor(255, 255, 255)
			love.graphics.polygon('fill', sunbeam.shape:getPoints())
		end)
	end
end

function Game:update(dt)
	self.timer:update(dt)

	self.entities:loop('update', dt)
	self.sunbeams:loop('update', dt)
end

function Game:draw()
	Camera:attach()

	love.graphics.stencil(Game.stencilFunction, 'replace', 1)
	love.graphics.setStencilTest('greater', 0)

	Game.entities:loop('drawBlack')

	love.graphics.setStencilTest('equal', 0)

	Camera:detach()

	love.graphics.setColor(0, 0, 0)
	-- TODO use screen res.
	love.graphics.rectangle('fill', 0, 0, 1000, 1000)

	Camera:attach()

	Game.entities:loop('drawWhite')

	Camera:detach()
end

function Game:keypressed(key)
	Game.player:keypressed(key)
end

function Game:restart()
	Game.timer:clear()
	Game.timer = nil

	Game:enter()
end

-- Wrapper function to add a new object to the entity system
function Instantiate(obj)
	return Game.entities:add(obj)
end

function Destroy(obj)
	if Game.world:hasItem(obj) then
		Game.world:remove(obj)
	end

	Game.entities:remove(obj)
	return obj
end

return Game
