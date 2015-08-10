local Conversation = {}
Conversation.__index = Conversation

function Conversation:listen(s, f)
  local listener = {s = s, f = f}
  table.insert(self.listeners, listener)
  return listener
end

function Conversation:say(s, ...)
  local returned = {}
  for i = 1, #self.listeners do
    local listener = self.listeners[i]
    if s == listener.s then
      local returnedValue = listener.f(...)
      if returnedValue then
        table.insert(returned, returnedValue)
      end
    end
  end
  return unpack(returned)
end

local talkback = {}

function talkback.new()
  local conversation = setmetatable({}, Conversation)
  conversation.listeners = {}
  return conversation
end

return talkback
