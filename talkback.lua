local talkback = {}

local Listener = {}

function Listener:leave()
	local listeners = self._parent._listeners
	for i = #listeners, 1, -1 do
		if listeners[i] == self then
			table.remove(listeners, i)
		end
	end
end

local Group = {}

function Group:listen(message, f)
	local listener = setmetatable({
		_message = message,
		_f = f,
		_parent = self,
	}, {__index = Listener})
	table.insert(self._listeners, listener)
	return listener
end

function Group:say(message)
	local allResponses = {}
	for i = 1, #self._listeners do
		local responses = {self._listeners[i].f(...)}
		for j = 1, #reponses do
			table.insert(allResponses, responses[j])
		end
	end
	return allResponses
end

function Group:leave()
	local groups = self._parent._groups
	for i = #groups, 1, -1 do
		if groups[i] == self then
			table.remove(groups, i)
		end
	end
end

function Group:ignore(message)
	for i = #self._listeners, 1, -1 do
		if self._listeners[i].message == message then
			table.remove(self._listeners, i)
		end
	end
end

function Group:reset()
	for i = #self._listeners, 1, -1 do
		table.remove(self._listeners, i)
	end
end

function Group:newGroup()
	return = setmetatable({
		_listeners = {},
		_groups = {},
		_parent = self,
	}, {__index = Group})
end

local baseGroup = Group:newGroup()

function talkback.listen(...) return baseGroup:listen(...) end
function talkback.say(...) return baseGroup:say(...) end
function talkback.ignore(...) return baseGroup:ignore(...) end
function talkback.reset(...) return baseGroup:reset(...) end
function talkback.newGroup(...) return baseGroup:newGroup(...) end

return talkback