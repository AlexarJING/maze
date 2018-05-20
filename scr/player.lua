local player = class("player",Base)
Player = player
player.hp = 30
player.speed = 50
player.endurance = 100
player.endurance_lose = 20
player.scale = 20
player.player = true
function player:update(dt)
    Base.update(self,dt)
    self:setDirection()
    self:control(dt)
    self:enduranceUpdate(dt)
    game.cam:followTarget(self,10)
end

function player:draw()
   love.graphics.setColor(150,150,255,255)
   love.graphics.rectangle("line",self.x + self.scale/4,self.y + self.scale/4,self.scale/2,self.scale/2)
   love.graphics.setColor(150,150,255,200)
   love.graphics.rectangle("fill",self.x + self.scale/4,self.y + self.scale/4,self.scale/2,self.scale/2)
   if not self.light then
    self.sounder:draw()
   end
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

return player