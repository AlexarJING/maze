local normal_map = {}

function normal_map.fromHeightMap(heightMap, strength)
	local imgData = heightMap:getData()
	local imgData2 = love.image.newImageData(heightMap:getWidth(), heightMap:getHeight())
	local red, green, blue, alpha
	local x, y
	local matrix = {}
	matrix[1] = {}
	matrix[2] = {}
	matrix[3] = {}
	strength = strength or 1.0

	for i = 0, heightMap:getHeight() - 1 do
		for k = 0, heightMap:getWidth() - 1 do
			for l = 1, 3 do
				for m = 1, 3 do
					if k + (l - 1) < 1 then
						x = heightMap:getWidth() - 1
					elseif k + (l - 1) > heightMap:getWidth() - 1 then
						x = 1
					else
						x = k + l - 1
					end

					if i + (m - 1) < 1 then
						y = heightMap:getHeight() - 1
					elseif i + (m - 1) > heightMap:getHeight() - 1 then
						y = 1
					else
						y = i + m - 1
					end

					local red, green, blue, alpha = imgData:getPixel(x, y)
					matrix[l][m] = red
				end
			end

			red = ( ((matrix[1][2] - matrix[2][2]) + (matrix[2][2] - matrix[3][2])) * strength) / 2.0
			green = (((matrix[2][2] - matrix[1][1]) + (matrix[2][3] - matrix[2][2])) * strength) / 2.0
			blue = 0.75

			imgData2:setPixel(k, i, red, green, blue)
		end
	end

	return love.graphics.newImage(imgData2)
end

function normal_map.generateFlat(img,img_data, mode)
  local imgData = img_data
  local imgNormalData = love.image.newImageData(img:getWidth(), img:getHeight())
  local color

  if mode == "top" then
    color = {0.5 , 0.5, 1}
  elseif mode == "front" then
    color = {0.5, 0, 0.5}
  elseif mode == "back" then
    color = {0.5, 1, 0.5}
  elseif mode == "left" then
    color = {0.12, 0, 0.87}
  elseif mode == "right" then
    color = {0.87, 0, 0.12}
  end

  for i = 0, img:getHeight() - 1 do
    for k = 0, img:getWidth() - 1 do
      local r, g, b, a = imgData:getPixel(k, i)
      imgNormalData:setPixel(k, i, color[1], color[2], color[3], a)
    end
  end

  return love.graphics.newImage(imgNormalData)
end

function normal_map.generateGradient(img, horizontalGradient, verticalGradient)
  horizontalGradient = horizontalGradient or "gradient"
  verticalGradient = verticalGradient or horizontalGradient

  local imgData = img:getData()
  local imgWidth, imgHeight = img:getWidth(), img:getHeight()
  local imgNormalData = love.image.newImageData(imgWidth, imgHeight)
  local dx = 1 / imgWidth
  local dy = 1 / imgHeight
  local nx
  local ny
  local nz

  for i = 0, imgWidth - 1 do
    for k = 0, imgHeight - 1 do
      local r, g, b, a = imgData:getPixel(i, k)
      if a > 0 then
        if horizontalGradient == "gradient" then
          nx = i * dx
        elseif horizontalGradient == "inverse" then
          nx = 1 - i * dx
        else
          nx = 0.5
        end

        if verticalGradient == "gradient" then
          ny = 0.5 - k * dy * 0.5
          nz = 1 - k * dy * 0.5
        elseif verticalGradient == "inverse" then
          ny = 0.5 + k * dy * 0.5
          nz = 0.5 - k * dy * 0.25
        else
          ny = 1
          nz = 0.5
        end

        imgNormalData:setPixel(i, k, nx, ny, nz, 1)
      end
    end
  end

  return love.graphics.newImage(imgNormalData)
end

return normal_map
