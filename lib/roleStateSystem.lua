local M={}

function M.init(obj)
	return {
		name = "stateSystem for: "..tostring(obj),
		stack = {},
		update = M.update,
		switch = M.switch,
		reg = M.reg,
		current = nil,
		default = nil,
		role = obj
	}
end

function M.reg(state,name, action, isDefault)
	action.name = name
	state.stack[name]=action
	if isDefault then
		state.default = action
		state.current = action
		state.current.onEnter(state.role)
	end
end


function M.update(state)
	if state.current.update then state.current.update(state.role) end
	for _ , actionName in pairs( state.current.relative) do
		if state.stack[actionName].condition(state.role) then
			M.switch(state , state.current, state.stack[actionName]) 
			return
		end
	end
	
	if not state.current.lasting and not state.current.condition(state.role) and 
		state.current ~= state.default then 
		M.switch(state, state.current , state.default)
	end
end

function M.switch(state , from , to, force)
	if from == to and (not force) then return end
	state.current=to
	if from and from.onExit then from.onExit(state.role,to) end 
	if to.onEnter then to.onEnter(state.role,from) end
end

return M

