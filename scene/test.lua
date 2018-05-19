local scene = gamestate.new()
require "scr/game"
function scene:init()
    game:init()
end 

function scene:enter(from,to,how,...)

end

function scene:draw()
    game:draw()
end

function scene:update(dt)
    game:update(dt)
end     

function scene:leave()

end

return scene