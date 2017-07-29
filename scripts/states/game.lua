local Game = {}

function Game:enter()
	self.world = World()

	self.entities = EntitySystem()
	self.map = Instantiate(Map 'maps/map1.csv')
	self.player = Instantiate(Player {x = 24, y = 16})
	self.enemies = {
		Instantiate(Enemy {x = 128, y = 0}),
		Instantiate(Enemy {x = 96, y = 12}),
		Instantiate(Enemy {x = 64, y = 24})
	}

	love.graphics.setBackgroundColor(160, 160, 160)

	Camera:lookAt(24, 16)

	self.timescale = 1

	self.timer = Timer.new()

	self.stencilFunction = function()
		love.graphics.push()

		love.graphics.rotate(45)
		love.graphics.setColor(255, 255, 255)
		love.graphics.rectangle('fill', 0, 0, 1000, 1000)

		love.graphics.pop()
	end
end

function Game:update(dt)
	dt = dt * self.timescale

	self.timer:update(dt)

	self.entities:loop('update', dt)
end

function Game:draw()
	Camera:attach()

	love.graphics.stencil(Game.stencilFunction, 'replace', 1)
	love.graphics.setStencilTest('greater', 0)

	Game.entities:loop('drawBlack')

	love.graphics.setStencilTest('equal', 0)

	Game.entities:loop('drawWhite')

	Camera:detach()

	love.graphics.setColor(255, 0, 0)
end

function Game:mousepressed(x, y, button)
	Game.player:mousepressed(button, x, y)
end

function Game:restart()
	Game.timer:clear()
	Game.timer = nil

	Game.timescale = 1

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
