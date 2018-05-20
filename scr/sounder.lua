local sounder = class("sounder")
Sounder = sounder
sounder.cd = 3
sounder.p_speed = 300
sounder.p_life = 2
sounder.p_count = 36
sounder.tail_length = 30
function sounder:init(target)
    self.target = target
    self.timer = 0
    self.waves = {} --group
end

function sounder:sendWave()
    local step = Pi * 2 / self.p_count
    for i = 1, self.p_count do
       local dx = math.sin(step*i)*self.p_speed
       local dy = math.cos(step*i)*self.p_speed
        local point = {
           x = self.target.cx,
           y = self.target.cy,
           dx = dx,
           dy = dy,
           tail = {},
           sensor = true,
           life = sounder.p_life
        }
        point.box = game.coll_sys:add(point,point.x,point.y,1,1)
        table.insert(self.waves,point)
    end
end

function sounder:update(dt)
    self.timer = self.timer - dt
    if self.timer<0 then
       self:sendWave()
       self.timer = self.cd
    end
    for i = #self.waves , 1 , -1 do
       local p = self.waves[i]
       p.life = p.life - dt
        if p.life<0 then 
            game.coll_sys:remove(p) 
            table.remove(self.waves,i)
        else
            self:move(p,dt)
        end
    end
end

function sounder.collidefilter(me,other)
	if other.sensor then
        return bump.Response_Cross
    else
        return bump.Response_Bounce
	end
end


function sounder:collision(point,cols)
	for i,col in ipairs(cols) do
		local other = col.other
		if not other.sensor then
			if col.normal.y~=0 then
               point.dy = -point.dy 
            end
            
            if col.normal.x~=0 then
               point.dx = -point.dx 
            end
            point.life = point.life - sounder.p_life/10
		end
	end
end
function sounder:move(point,dt)
    point.tail[self.tail_length+1] = nil
    point.tail[self.tail_length+2] = nil
    local tx,ty ,cols = game.coll_sys:move(point,point.x+point.dx*dt,
        point.y + point.dy*dt,self.collidefilter)
    point.x , point.y = tx,ty
    self:collision(point,cols)
    table.insert(point.tail,1,point.y)
    table.insert(point.tail,1,point.x)
end


function sounder:draw()
    love.graphics.setLineWidth(3)
    for i =  1 , #self.waves do
        local p = self.waves[i]
        for i = 1, self.tail_length - 4, 2 do
            local t = p.tail
            if t[i] and t[i+2]  then
            love.graphics.setColor(255,0,0,255*p.life/sounder.p_life-i*5)
            love.graphics.line(t[i],t[i+1],t[i+2],t[i+3])
            end
        end
    end
    love.graphics.setLineWidth(1)
end

return sounder