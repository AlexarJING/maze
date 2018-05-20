local sounder = class("sounder")
Sounder = sounder
sounder.cd = 2
sounder.p_speed = 200
sounder.p_life = 2
sounder.p_count = 32
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
          ox = self.target.cx,
          oy = self.target.cy,
           x = self.target.cx,
           y = self.target.cy,
           dx = dx,
           dy = dy,
           life = sounder.p_life,
           sensor = true
        }
        point.box = game.coll_sys:add(point,point.x,point.y,1,1)
        table.insert(self.waves,point)
    end
end

function sounder:update(dt)
    self.timer = self.timer - dt
    if self.timer<0 then
       delay:new(0.2,function() self:sendWave() end)
       delay:new(0.4,function() self:sendWave() end)
       delay:new(0.6,function() self:sendWave() end)
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
		if not other.sensor and not other.player then
            point.life = point.life - sounder.p_life/4
			if col.normal.y~=0 then
                local dist = math.abs(point.oy - col.touch.y)
                if col.normal.y > 0  then
                  point.oy = col.touch.y - dist
                else
                  point.oy = col.touch.y + dist
                end
                point.dy = -point.dy 
            end
      
            if col.normal.x~=0 then
                local dist = math.abs(point.ox - col.touch.x)
                if col.normal.x > 0  then
                  point.ox = col.touch.x - dist
                else
                  point.ox = col.touch.x + dist
                end
                
                point.dx = -point.dx 
            end
		end
	end
end
function sounder:move(point,dt)
    local tx,ty ,cols = game.coll_sys:move(point,point.x+point.dx*dt,
        point.y + point.dy*dt,self.collidefilter)
    point.x , point.y = tx,ty
    self:collision(point,cols)
end
function sounder:draw()
    --
    for i =  1 , #self.waves do
        local p = self.waves[i]
        local r = (sounder.p_life - p.life)*sounder.p_speed
        local c = Pi/sounder.p_count
        local a = 255*(p.life/sounder.p_life)^3
        love.graphics.setLineWidth(1*p.life/sounder.p_life)
        love.graphics.setColor(255,255,250, a < 40 and 0 or a)
        --love.graphics.rectangle("fill",p.x,p.y,3,3)
        local rot = math.getRot(0,0,p.dy,-p.dx)
        love.graphics.arc("line","open",p.ox,p.oy,r,rot-c,rot+c)
    end
end

return sounder