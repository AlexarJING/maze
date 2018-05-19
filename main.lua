require "lib/util"
bump=require "lib/bump"
class=require "lib/middleclass"
gamestate= require "lib/hump/gamestate"
tween= require "lib/tween"
delay= require "lib/delay"
input= require "lib/input"
camera= require "lib/gamera"
sti = require "lib/sti"
animation = require "lib/animation"
LightWorld = require "lib/light_10"

font = love.graphics.newImageFont("res/imagefont.png",
    " abcdefghijklmnopqrstuvwxyz" ..
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ0" ..
    "123456789.,!?-+/():;%&`'*#=[]\"")
love.graphics.setFont(font)

function love.load()
	love.graphics.setDefaultFilter( "nearest","nearest" )
    gameState={}
    for _,name in ipairs(love.filesystem.getDirectoryItems("scene")) do
        gameState[name:sub(1,-5)]=require("scene."..name:sub(1,-5))
    end
    gamestate.registerEvents()
    gamestate.switch(gameState.test)
end

function love.update(dt) delay:update(dt) end
function love.mousereleased(x, y, button)  end
function love.mousepressed(x, y, button)  end
function love.textinput(text) end
function love.keypressed(key) end