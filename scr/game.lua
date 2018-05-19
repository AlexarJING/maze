local maze = require "scr/maze"
require"scr/player"
require"scr/lightSource"
require"scr/sounder"
game = {}

function game:init()
    self.coll_sys = bump.newWorld(32)
    self.cam = camera.new(0,0,w()*32,h()*32)	
    self.cam:setScale(1)
    self.light_sys = LightWorld({
   		ambient = {0,0,0},
    	shadowBlur = 3.0
 	})
	self.light_sys:setCamera(self.cam)
    self.map = maze.init()
    maze.generate()
    self:generate_walls()
    
    self.player = Player(650,360)
end

function game:update(dt)
    if input:test("1") == "pressed" then
        self.player:setLight("candle")
    elseif input:test("2") == "pressed" then
        self.player:setLight("flashlight")
    elseif input:test("3") == "pressed" then
        self.player:setLight(false)
    end
    self.player:update(dt)
    self.light_sys:update(dt)
end


function game:draw()
    self.light_sys:draw(function()
        love.graphics.setColor(255,255,255,100)
        love.graphics.rectangle("fill",0,0,1280,720)
        love.graphics.setColor(255,255,255,255)
		for i,wall in ipairs(self.walls) do
            love.graphics.rectangle("fill",wall.x,wall.y,wall.w,wall.h)
        end
        --self.player:draw()
        --maze.draw()
	end)
    --love.graphics.setColor(1,1,1,1)
	self.cam:draw(function()
        self.player:draw()
    end)
end

function game:generate_walls()
    local walls = {}
    self.walls = walls
    local maze_wall = maze.getWall(self.map)
    for x = 1,maze.mazeWidth+1 do
        for y = 1,maze.mazeHeight+1 do
            if maze_wall[y][x].t then
                local wall = {
                    x = (x - 1) * maze.cellWidth + maze.offsetX, 
                    y = (y - 1) * maze.cellHeight + maze.offsetY-2,
                    w = maze.cellWidth,
                    h = 4,
                    isWall =true
                }
                table.insert(walls,wall)
                self.coll_sys:add(wall,wall.x,wall.y,wall.w,wall.h)
                self.light_sys:newRectangle(wall.x + wall.w/2, wall.y + wall.h/2,wall.w,wall.h)
            end
            if maze_wall[y][x].l then
                local wall = {
                    x = (x - 1) * maze.cellWidth + maze.offsetX -2, 
                    y = (y - 1) * maze.cellHeight + maze.offsetY,
                    w = 4,
                    h = maze.cellHeight,
                    isWall = true
                }
                table.insert(walls,wall)
                self.coll_sys:add(wall,wall.x,wall.y,wall.w,wall.h)
                self.light_sys:newRectangle(wall.x + wall.w/2, wall.y + wall.h/2,wall.w,wall.h)
            end
            
        end
    end
    
end

function game:getMouseWorldPos()
    return self.cam:toWorld(love.mouse.getPosition())
end

return game