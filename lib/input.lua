local input={
	clickToggle={},
	lastDown={},
}

function input:test(key)

	if self.clickToggle[key]==nil then
		self.clickToggle[key]=false
		self.lastDown[key]=0
	end

	local dt=love.timer.getTime()-self.lastDown[key]
	if love.keyboard.isDown(key) and self.clickToggle[key]==false then
		self.clickToggle[key]=true
		self.lastDown[key] = love.timer.getTime()
		return "down"
	end	
	if dt>0.2 and self.clickToggle[key]==true and love.keyboard.isDown(key) then
		return "holding"
	end
	if not love.keyboard.isDown(key) and self.clickToggle[key]==true then
		self.clickToggle[key]=false
		if dt<=0.2 then
			return "pressed"
		else
			return "held"
		end
		self.lastDown[key] = 0
	end
end


return input