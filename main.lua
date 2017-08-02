love.graphics.setDefaultFilter('nearest', 'nearest')
love.audio.setVolume(0.3)

math.randomseed(os.time())

Lume = require 'lib.lume.lume'

Timer = require 'lib.hump.timer'
Gamestate = require 'lib.hump.gamestate'
Class = require 'lib.hump.class'
Camera = require 'lib.hump.camera'(0, 0)

Bump = require 'lib.bump.bump'

EntitySystem = require 'lib.entitysystem'

Animation = require 'lib.anim8'

Transform = require 'scripts.transform'
Rigidbody = require 'scripts.entities.rigidbody'
Actor = require 'scripts.entities.actor'
Player = require 'scripts.entities.player'
Enemy = require 'scripts.entities.enemy'
Bullet = require 'scripts.entities.bullet'
Sunbeam = require 'scripts.entities.sunbeam'
Tile = require 'scripts.entities.tile'
Map = require 'scripts.map'
World = require 'scripts.world'

Game = require 'scripts.states.game'
Menu = require 'scripts.states.menu'

Debug = true

Color = {
	white = {255, 255, 255},
	black = {0, 0, 0},
	grey = {150, 150, 150}
}

function love.load(args)
	-- Allows printing in sublime text
	io.stdout:setvbuf('no')

	Camera:zoom(5)

	-- Setup main menu (Just start in game state for playtesting purposes)
	Gamestate.registerEvents()
	Gamestate.switch(Game)

	LargeFont = love.graphics.newFont('font/kenpixel_high.ttf', 64)
	SmallFont = love.graphics.newFont('font/kenpixel_high.ttf', 32)
	love.graphics.setFont(LargeFont)
end

function love.update(dt)
	Timer.update(dt)
end

function love.draw()
	love.graphics.setColor(Color.white)
	love.graphics.print(love.timer.getFPS())
end

function love.keypressed(key)
	if key == 'escape' then love.event.quit() end
end
