local player = class("player")
Player = player
player.hp = 100
player.speed = 200
player.endurance = 100
player.endurance_lose = 20
player.scale = 20

function player:init(x,y)
    self.x = x - player.scale/2
    self.y = y - player.scale/2
    self.cx = x
    self.cy = y
    self.rot = 0
    self.scale = player.scale
    self.endurance = player.endurance
    self.hp = player.hp
    self.speed = player.speed
    self.endurance_lose = player.endurance_lose
   
    self.dx = 0
    self.dy = 0
    self:initColl()
    self:setLight()
    self:initSound()
end

function player:update(dt)
    self:setDirection()
    if self.light then self.light:update(dt) end
    self.sounder:update(dt)
    self:control(dt)
    self:enduranceUpdate(dt)
    game.cam:followTarget(self,10)
end

function player:draw()
   love.graphics.setColor(150,150,255,255)
   love.graphics.rectangle("line",self.x,self.y,self.scale,self.scale)
   love.graphics.setColor(150,150,255,200)
   love.graphics.rectangle("fill",self.x,self.y,self.scale,self.scale)
   if not self.light then
    self.sounder:draw()
   end
end

-- candle(default)/lamp/flashlight/torch/
function player:setLight(t)
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

function player:initColl()
    game.coll_sys:add(self,self.cx ,self.cy,self.scale,self.scale)
end

function player:initSound()
   self.sounder = Sounder(self) 
end

function player:control(dt)
    local speed = self.speed * dt
    local key = love.keyboard.isDown
    
    if key("lctrl") then
        speed = (self.isTired and 1.5 or 2) * speed 
        self.isRushing = true
    elseif key("lshift") and not self.isPanicky then
        speed = 0.5 * speed
        self.isSneaking = true
    else
        self.isRushing = false
        self.isSneaking = false
    end
    
    if not self.exausted then
        if key("w") then
            self.dy = -speed
        elseif key("s") then
            self.dy = speed
        else
            self.dy = 0
        end
        
        if key("a") then
            self.dx = - speed
        elseif key("d") then
            self.dx = speed
        else
            self.dx = 0
        end
    else
        self.dx = 0
        self.dy = 0
    end
    
    if self.dx == 0 and self.dy == 0 then
        self.still = true
    else
        self.still = false
    end
    
    self:translate(self.x+self.dx,self.y+self.dy)
    
end

function player:enduranceUpdate(dt)
    if self.exausted then
        self.endurance = self.endurance + 3 * self.endurance_lose * dt
        
    elseif self.isSneaking then
        self.endurance = self.endurance + 1 * self.endurance_lose * dt
    elseif self.still then
        self.endurance = self.endurance + 2 * self.endurance_lose * dt
    end
    
    
    if self.endurance >= player.endurance then
        self.endurance = player.endurance
        self.exausted = false
    end
    
    if self.isRunning then
        self.endurance = self.endurance - self.endurance_lose * dt
        if self.endurance<= 0 then
            self.exausted = true
        end
    end
    
    if self.endurance <= 20 then
        self.tired = true
    else
        self.tired = false
    end
    
end

function player:setDirection()
    local mx,my = game:getMouseWorldPos()
    local dir = math.getRot(mx,my,self.x,self.y)
    self.rot = dir + Pi/2
end

function player.collidefilter(me,other)
	if other.isWall then
		return bump.Response_Bounce
	end
end


function player:collision(cols)
	for i,col in ipairs(cols) do
		local other = col.other
		if other.isWall then
			
		end
	end
end

function player:setPosition(x,y)
    self.x = x
    self.y = y
    self.cx = self.x + self.scale/2
    self.cy = self.y + self.scale/2
end

function player:translate(tx,ty)
    local tx,ty ,cols = game.coll_sys:move(self,tx,ty,self.collidefilter)
    self:collision(cols)
	self:setPosition(tx,ty)
end

return player