local visual = class("visual")
Visual = visual
local testRate = 10


function visual:init(target,width,range)
    self.target = target
    self.width = width
    self.range = range
end

function visual:newWave()
    self.colls = {}
    self.waves = {}
    local step = self.width / testRate
    for i = 1, testRate do
        local rot = step*i+ self.target.rot - self.width/2
       local tx = math.sin(rot)*self.range + self.target.cx
       local ty = math.cos(rot)*self.range + self.target.cy
        local point = {
            ox = self.target.cx,
            oy = self.target.cy,
            tx = tx,
            ty = ty,
            rot = rot,
            sensor = true
        }
        game.coll_sys:add(point,point.ox,point.oy,1,1)
        table.insert(self.waves,point)
    end
    
end

function visual.collidefilter(me,other)
    return bump.Response_Cross
end
function visual:collision(point,cols)    
    for i,col in ipairs(cols) do
		local other = col.other
		if not other.sensor and self.target~=other then
			--game.coll_sys:remove(point)
            point.tx = col.touch.x
            point.ty = col.touch.y
            point.coll = other
            self.colls[other] = true
            break
		end
	end
end
function visual:move(point)
    local tx,ty ,cols = game.coll_sys:move(point,point.tx,point.ty,self.collidefilter)
    self:collision(point,cols)
end

function visual:coll_step()
    for i , p in ipairs(self.waves) do
        self:move(p)
        game.coll_sys:remove(p)
    end
end

function visual:update()
    self:newWave()
    self:coll_step()
end


function visual:draw()
    
    love.graphics.setColor(50,255,50, 250)
    local pl = self.waves[1]
    love.graphics.line(pl.ox,pl.oy,pl.tx,pl.ty)
    local pr = self.waves[testRate]
    love.graphics.line(pr.ox,pr.oy,pr.tx,pr.ty)
    --[[
    for i =  1 , #self.waves do
        local p = self.waves[i]
        local r = math.getDistance(p.ox,p.oy,p.tx,p.ty)
        local c = self.width / (testRate *2)
        love.graphics.setColor(50,255,50, 50)
        love.graphics.arc("fill","pie",p.ox,p.oy,r,Pi/2 - p.rot-c,Pi/2 - p.rot+c)
    end]]
end

return visual