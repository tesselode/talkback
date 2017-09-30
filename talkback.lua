local unpack = unpack or table.unpack

local function filter(t, f)
	for i = #t, 1, -1 do
		if f(t[i]) then
			table.remove(t, i)
		end
	end
end

local function remove(t, v)
	for i = #t, 1, -1 do
		if t[i] == v then
			table.remove(t, i)
			break
		end
	end
end

local Listener = {}

function Listener:leave()
	remove(self._parent._listeners, self)
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

function Group:say(message, ...)
	local responses = {}
	for _, listener in pairs(self._listeners) do
		if listener._message == message then
			for _, response in ipairs {listener._f(...)} do
				table.insert(responses, response)
			end
		end
	end
	for _, group in ipairs(self._groups) do
		for _, response in ipairs {group:say(message, ...)} do
			table.insert(responses, response)
		end
	end
	return unpack(responses)
end

function Group:leave()
	if self._parent == Group then
		error "can't call :leave() on a group without a parent"
	end
	remove(self._parent._groups, self)
end

function Group:ignore(message)
  for _, group in ipairs(self._groups) do
    group:ignore(message)
  end
	filter(self._listeners, function(l)
		return l._message == message
	end)
end

function Group:reset()
	self._groups, self._listeners = {}, {}
end

function Group:newGroup()
	local group = setmetatable({
		_listeners = {},
		_groups = {},
		_parent = self,
	}, {__index = Group})
	if self ~= Group then
		table.insert(self._groups, group)
	end
	return group
end

return Group:newGroup()