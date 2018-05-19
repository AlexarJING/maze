local util = {}
--TODO: the whole stencil/canvas system should be reviewed since it has been changed in a naive way

function util.process(temp,canvas, options)
  --TODO: now you cannot draw a canvas to itself 
  love.graphics.setCanvas(temp)
  love.graphics.clear()
  love.graphics.setCanvas()
  util.drawCanvasToCanvas(canvas, temp, options)
  util.drawCanvasToCanvas(temp, canvas, options)
end

function util.drawCanvasToCanvas(canvas, other_canvas, options)
  options = options or {}

  util.drawto(other_canvas, 0, 0, 1, function()
    if options["blendmode"] then
        local m = options["blendmode"]
      love.graphics.setBlendMode(m,m == "multiply" and "premultiplied" or "alphamultiply")
    end
    if options["shader"] then
      love.graphics.setShader(options["shader"])
    end
    if options["stencil"] then
      love.graphics.stencil(options["stencil"])
      love.graphics.setStencilTest("greater",0)
    end
    if options["istencil"] then
      love.graphics.stencil(options["istencil"])
      love.graphics.setStencilTest("equal", 0)
    end
    if options["color"] then
      love.graphics.setColor(unpack(options["color"]))
    else
      love.graphics.setColor(1,1,1)
    end
    if love.graphics.getCanvas() ~= canvas then
      love.graphics.draw(canvas,0,0)
    end
    if options["blendmode"] then
      love.graphics.setBlendMode("alpha")
    end
    if options["shader"] then
      love.graphics.setShader()
    end
    if options["stencil"] or options["istencil"] then
      --love.graphics.setInvertedStencil()
      love.graphics.setStencilTest()
    end
  end)
end


function util.drawto(canvas, x, y, scale, cb)
  local last_buffer = love.graphics.getCanvas()
  love.graphics.push()
    love.graphics.origin()
    if canvas then
        --love.graphics.setCanvas({canvas, stencil=true})
     love.graphics.setCanvas({canvas, stencil=true}) 
    end     
      love.graphics.translate(x, y)
      love.graphics.scale(scale)
      cb()
    love.graphics.setCanvas()
  love.graphics.pop()
end

return util
