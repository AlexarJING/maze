local enemy = class("player",Base)
Enemy = enemy
enemy.hp = 100
enemy.speed = 30
enemy.endurance = 100
enemy.endurance_lose = 20
enemy.scale = 20
enemy.visualWidth = Pi/2
enemy.visualRange = 200

function enemy:init(...)
    Base.init(self,...)
    self:setLight(false)
    self:initVisual()
    self.state = "idle"
end

function enemy:update(dt)
    
    self.visual:update()
    self:fineTarget()
    self:setBodyRot(dt)
    self:followTarget(dt)
    Base.update(self,dt)
end

function enemy:draw()
    love.graphics.setColor(150,150,255,255)
    love.graphics.rectangle("line",self.x + self.scale/4,self.y + self.scale/4,self.scale/2,self.scale/2)
    love.graphics.setColor(150,150,255,200)
    love.graphics.rectangle("fill",self.x + self.scale/4,self.y + self.scale/4,self.scale/2,self.scale/2)
    love.graphics.setColor(100,255,100,100)
    self.visual:draw()
    --love.graphics.arc("fill","pie",self.cx,self.cy,self.visual.obj.range,self.rot-self.visualWidth/2,self.rot+self.visualWidth/2)
end

function enemy:initVisual()
    self.visual = Visual(self,self.visualWidth,self.visualRange)
end

function enemy:followTarget(dt)
    if not self.target then return end
    local speed = self.speed*dt
    
    if self.x > self.target.x + 2 then
        self.dx = - speed
    elseif self.x < self.target.x - 2 then
        self.dx = speed
    else
        self.dx = 0
    end
    
    if self.y > self.target.y + 2 then
        self.dy = - speed
    elseif self.y < self.target.y - 2 then
        self.dy = speed
    else
        self.dx = 0
    end
    
end

function enemy:fineTarget()
    if self.visual.colls[game.player] then
        self.target = game.player
        self.state = "chasing"
    else
        if self.state == "chasing" then
            self.state = "searching"
        else
            
        end
    end
end

function enemy:setBodyRot(dt)
    if self.state == "chasing" then
        local dir = math.getRot(self.target.x,self.target.y,self.x,self.y)
        self.rot = -dir 
    elseif self.state == "searching" then
        
    elseif self.state == "patroling" then
        
    elseif self.state == "idle" then
        self.rot = self.rot +  Pi*dt/2
    end
end