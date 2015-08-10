--initial setup
talkback = require 'talkback'
conversation = talkback.new()

--error handling
fun = function()
  conversation:listen('test', 'not a function')
end
assert(not pcall(fun), "Conversation.listen should throw an error if the second argument isn't a function")

--basic behavior
arbitraryNumber = 3
setNumberListener = conversation:listen('set arbitrary number', function(n)
  arbitraryNumber = n
  return n, n + 2
end)
anotherListener = conversation:listen('set arbitrary number', function(n)
  return n * 2
end)
a, b, c = conversation:say('set arbitrary number', 5)

assert(arbitraryNumber == 5, 'conversation.say should be triggering the listener that was just set up')
assert(a == 5 and b == 7 and c == 10, 'The listeners should be returning values through conversation.say')

--stop listening function
conversation:stopListening(setNumberListener)
conversation:stopListening(anotherListener)
d, e, f = conversation:say('set arbitrary number', 7)

assert(not (d or e or f), 'No more values should be passed since the listeners should be disabled')

--listener grouping
group = conversation:group(
  'set arbitrary number', function(n)
    arbitraryNumber = n
    return n, n + 2
  end,
  'set arbitrary number', function(n)
    return n * 2
  end
)
a, b, c = conversation:say('set arbitrary number', 10)
assert(a == 10 and b == 12 and c == 20, 'Listeners created as groups should work the same way as listeners created individually')

--group stop listening function
conversation:stopListening(group)
d, e, f = conversation:say('set arbitrary number', 7)

assert(not (d or e or f), 'All of the listeners in the group should have been disabled')

print('Everything looks good!')
