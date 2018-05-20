local base = class("base")
Base = base
base.hp = 100
base.speed = 100
base.endurance = 100
base.endurance_lose = 20
base.scale = 20

function base:init(x,y)
    self.x = x - base.scale/2
    self.y = y - base.scale/2
    self.cx = x
    self.cy = y
    self.rot = 0
    self.hp = base.hp

   
    self.dx = 0
    self.dy = 0
    self:initColl()
    self:setLight()
    self:initSound()
end

function base:update(dt)
    if self.light then self.light:update(dt) end
    if self.sounder then self.sounder:update(dt) end
    self:translate(self.x+self.dx,self.y+self.dy)
    self.body:setPosition(self.cx,self.cy)
end

function base:draw()
    love.graphics.setColor(150,150,255,255)
    love.graphics.rectangle("line",self.x,self.y,self.scale,self.scale)
    love.graphics.setColor(150,150,255,200)
    love.graphics.rectangle("fill",self.x,self.y,self.scale,self.scale)
    if not self.light then
        self.sounder:draw()
    end
end

-- candle(default)/lamp/flashlight/torch/
function base:setLight(t)
    if self.light then 
        game.light_sys:remove(self.light.obj) 
    end
    if t == false then 
        self.light = nil
        return 
    end
    t = t or "candle"
    self.light = LightSource(self,t)
end

function base:initColl()
    game.coll_sys:add(self,self.cx ,self.cy,self.scale,self.scale)
    self.body = game.light_sys:newRectangle(self.cx , self.cy,self.scale/2,self.scale/2)
end

function base:initSound()
   self.sounder = Sounder(self) 
end


function base.collidefilter(me,other)
	if other.sensor then
        return bump.Response_Cross
    else
        return bump.Response_Slide
	end
end


function base:collision(cols)
	for i,col in ipairs(cols) do
		local other = col.other
		if other.isWall then
			
		end
	end
end

function base:setPosition(x,y)
    self.x = x
    self.y = y
    self.cx = self.x + self.scale/2
    self.cy = self.y + self.scale/2
end

function base:translate(tx,ty)
    local tx,ty ,cols = game.coll_sys:move(self,tx,ty,self.collidefilter)
    self:collision(cols)
	self:setPosition(tx,ty)
end

return base