local sourceData = {}
local sources = {}
local mainV = 0.5
local soundV = 1
local musicV =  1
love.audio.setVolume(mainV)
local function setVolume(mainVolume,musicVolume,soundVolume)
	mainV = mainVolume or 1
	musicV = musicVolume or 1
	soundV = soundVolume or 1
	love.audio.setVolume(mainV)
	for k,v in pairs(sources) do
		v:setVolume(musicV)
	end
end



return function(name,...)

	if type(name) == "number" then
		return setVolume(name,...)
	end

	if sourceData[name] then	
		local source = love.audio.newSource(sourceData[name], "static")
		source:setVolume(soundV)
		source:play()
	elseif sources[name] then
		local toggle = ...
		if toggle == "stop" then
			love.audio.stop(sources[name])
			sources[name] = nil
		end
	else
		if love.filesystem.exists("res/sound/"..name..".mp3") then
			local soundData = love.sound.newSoundData("res/sound/"..name..".mp3")
			sourceData[name] = soundData
			local source = love.audio.newSource(soundData, "static")
			source:setVolume(soundV)
			source:play()
		elseif love.filesystem.exists("res/sound/"..name..".wav") then
			local soundData = love.sound.newSoundData("res/sound/"..name..".wav")
			sourceData[name] = soundData
			local source = love.audio.newSource(soundData, "static")
			source:setVolume(soundV)
			source:play()
		elseif love.filesystem.exists("res/music/"..name..".mp3") then
			local source = love.audio.newSource("res/music/"..name..".mp3", "stream")
			source:setLooping(true)
			source:setVolume(musicV)
			source:play()
			sources[name] = source
		end
	end
end