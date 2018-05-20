LightSource = class("light")
local offset = 8
local typeData = {
    candle = {
        range = 60,
        color = {255,255,40},
        angle = 2* Pi,
    },
    flashlight = {
        range = 300,
        color = {200,200,250},
        angle = Pi/4,
    }
}

function LightSource:init(target,lightType)
    self.target = target
    lightType = lightType or "candle"
    local data = typeData[lightType]
    self.data = data
    self.obj = game.light_sys:newLight(0,0,unpack(data.color))
    self.obj:setAngle(data.angle)
    self.obj:setRange(data.range)
    --self.obj:setGlowSize(0)
end


function LightSource:update()
    self.obj:setRange(self.data.range + love.math.random(0,10))
    local x,y = math.axisRot(offset,0,self.target.rot)
    self.obj:setPosition(self.target.cx + x,self.target.cy+ y)
    self.obj:setDirection(self.target.rot)
end


function LightSource:destroy()
    
end