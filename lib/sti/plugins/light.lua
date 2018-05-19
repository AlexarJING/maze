
local function newLight(light,t)
	local color = t.properties.color or {255,200,0}
	local x = t.x+t.w/2
	local y = t.y+t.h/2
	local l = light:newLight(x,y,unpack(color))
	l:setRange(100)
	return l 
end

local function newBlock(light,t)
	local b = light:newRectangle(t.x+t.w/2, t.y+t.h/2, t.w, t.h)
	return b
end


return {
	light_init = function(map, light)
		local lights = {}
		local blocks = {}
		for _, tileset in ipairs(map.tilesets) do
			for _, tile in ipairs(tileset.tiles) do
				local gid = tileset.firstgid + tile.id
				-- Every object in every instance of a tile
				if tile.properties and map.tileInstances[gid] then
					if tile.properties.light == true then
						for _, instance in ipairs(map.tileInstances[gid]) do
							local t = {properties = tile.properties, x = instance.x + map.offsetx, y = instance.y + map.offsety, w = map.tilewidth, h = map.tileheight, layer = instance.layer }
							local l = newLight(light,t)
							table.insert(lights,l)
						end
					elseif tile.properties.collidable  then
						for _, instance in ipairs(map.tileInstances[gid]) do
							local t = {properties = tile.properties, x = instance.x + map.offsetx, y = instance.y + map.offsety, w = map.tilewidth, h = map.tileheight, layer = instance.layer}
							local b = newBlock(light,t)
							table.insert(blocks,b)
						end

					end
				end
			end
		end

		map.lights = lights
		map.blocks = blocks
	end,
}
