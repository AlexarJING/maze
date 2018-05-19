local Feeler = require 'lib/maze/feeler'
local Connector = require 'lib/maze/connector'
local cellWidth, cellHeight = 80, 80
local map, drawMap, scaleX, scaleY, quadWidth, quadHeight,colors
local mazeWidth = 15
local mazeHeight = 8
local offsetX = 10
local offsetY = 10
local done
local a,b,c,d
local maze = {}
local quads = {}
local names = { 'l', 'r', 't', 'b', 'bl', 'br', 'bt', '', 'lt', 'rt', 'blrt', 'blt', 'lr', 'brt', 'lrt', 'blr' }
local mazeImage = love.graphics.newImage( 'lib/maze/maze.png' )
local indicesImage = love.graphics.newImage( 'lib/maze/indices.png' )

function maze.init()
    maze.mazeWidth = mazeWidth
    maze.mazeHeight = mazeHeight
    maze.offsetX = offsetX
    maze.offsetY = offsetY
    maze.cellWidth = cellWidth
    maze.cellHeight = cellHeight
	done = false
	local mazeImageWidth, mazeImageHeight = mazeImage:getDimensions()
	local indicesImageWidth, indicesImageHeight = indicesImage:getDimensions()
	quadWidth, quadHeight = 5, 5
	scaleX, scaleY = cellWidth / quadWidth, cellHeight / quadHeight
	local i = 0
	for y = 0, mazeImageHeight - quadHeight, quadHeight do
		for x = 0, mazeImageWidth - quadWidth, quadWidth do
			i = i + 1
			quads[names[i]] = love.graphics.newQuad( x, y, quadWidth, quadHeight, mazeImageWidth, mazeImageHeight )
		end
	end

	colors = {}
	for y = 0, indicesImageHeight - quadHeight, quadHeight do
		for x = 0, indicesImageWidth - quadWidth, quadWidth do
			table.insert( colors, love.graphics.newQuad( x, y, quadWidth, quadHeight, indicesImageWidth, indicesImageHeight ) )
		end
	end

	map = {}
	for y = 1, mazeHeight do
		map[y] = {}
		for x = 1, mazeWidth do
			map[y][x] = { value = '', id = '' }
		end
	end

	

	a = Feeler( 1, 1, 1, map )
	b = Feeler( #map[1], 1, 2, map )
	c = Feeler( #map[1], #map, 3, map )
	d = Feeler( 1, #map, 4, map )
	e = Feeler( math.floor( #map[1] / 2 ), math.floor( #map / 2 ), 5, map )

	connector = Connector( map, a, b, c, d, e )
    
    return map
end



function maze.generate()
	while not done do
		local adone = a:step()
		local bdone = b:step()
		local cdone = c:step()
		local ddone = d:step()
		local edone = e:step()

		if not ( adone or bdone or cdone or ddone or edone ) then
			done = true
			connector:connect()
		else
			connector:update()
		end
	end
end

function maze.getWall(map)
    local wall = {}
    for y = 1, mazeHeight+1 do
        wall[y] = {}
		for x = 1, mazeWidth+1 do
			wall[y][x] = {l = true, t = true}
		end
	end
    for y = 1, mazeHeight+1 do
        wall[y][mazeWidth+1].t = false
    end
    for x = 1, mazeWidth+1 do
			wall[mazeHeight+1][x].l = false
		end
    
    for y = 1, mazeHeight do
		for x = 1, mazeWidth do
            local value = map[y][x].value
            if string.find(value,"l") then wall[y][x].l = false end
            if string.find(value,"r") then wall[y][x+1].l = false end 
            if string.find(value,"t") then wall[y][x].t = false end
            if string.find(value,"b") then wall[y+1][x].t = false end
		end
	end
   

    return wall
end

function maze.drawMap( map )
		for y = 1, #map do
			for x = 1, #map[y] do
				love.graphics.draw( mazeImage, quads[map[y][x].value], ( x - 1 ) * cellWidth + offsetX, ( y - 1 ) * cellHeight + offsetY, 0, scaleX, scaleY )
                --love.graphics.print(map[y][x].value,( x - 0.8 ) * cellWidth + offsetX, ( y - 0.8 ) * cellHeight + offsetY)
                --love.graphics.rectangle("line",( x - 1 ) * cellWidth + offsetX, ( y - 1 ) * cellHeight + offsetY,scaleX*5, scaleY*5)
            end
		end
	end


function maze.draw()
	love.graphics.setColor( 255, 255, 255 )
	if DEBUG then
		debug( a, cellWidth, cellHeight )
		debug( b, cellWidth, cellHeight )
		debug( c, cellWidth, cellHeight )
		debug( d, cellWidth, cellHeight )
		debug( e, cellWidth, cellHeight )
	end
	maze.drawMap( map )
end

return maze
