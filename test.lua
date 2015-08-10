--initial setup
talkback = require 'talkback'
conversation = talkback.new()

--error handling
local f = function()
  conversation:listen('test', 'not a function')
end
assert(not pcall(f), "Conversation.listen should throw an error if the second argument isn't a function")

--further setup
arbitraryNumber = 3
setNumberListener = conversation:listen('set arbitrary number', function(n)
  arbitraryNumber = n
  return n, n + 2
end)
uselessListener = conversation:listen('set arbitrary number', function()
  return 'hi'
end)
a, b, c = conversation:say('set arbitrary number', 5)

--behavior checking
assert(arbitraryNumber == 5, 'conversation.say should be triggering the listener that was just set up')
assert(a == 5 and b == 7 and c == 'hi', 'The listeners should be returning values through conversation.say')
