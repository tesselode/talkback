Talkback
========
Talkback is a tiny observer pattern library for Lua. It allows you to automatically call a function whenever a signal is emitted, making it easy to have different parts of your code communicate with each other without creating spaghetti code. Talkback has a unique feature: listeners (functions tied to a signal) can pass values back to the object that sent the signal.

Examples
--------
### Player controls example
```lua
--in player.lua
shootListener = conversation:listen('player shoot', function()
  spawnBullet()
end)

--in input-manager.lua
if input.pressed('x') then
  conversation:say('player shoot')
end
```

### High score display example
```lua
--in score-manager.lua
returnScoreListener = conversation:listen('get high score', function(place)
  return scores[place]
end)

--in hud.lua
topScore = conversation:say('get high score')
drawText(topScore)
```

API
---
### Requiring the library
```lua
talkback = require 'talkback'
```

I always list how to do this but I don't know why.

### Creating an event handler
```lua
conversation = talkback.new()
```

Event handlers (I call them conversations because it's cute) hold all of the listeners in a project. You'll probably only need one event handler in a project, but you can make as many as you want, I guess.

### Creating a listener
```lua
listener = conversation:listen(s, f)
```

Creates a listener. A listener is a function tied to a signal, so whenever you send a signal, every listener with a matching signal will have their functions called.
- `s` is the signal to look for. I always make them strings, but they can be anything.
- `f` is the function to call when the signal is emitted.
- Returns a handle to the listener. You'll want to keep this so you can remove the listener later.

### Emitting a signal
```lua
returnedValue1, returnedValue2, ... = conversation:say(s, ...)
```

Sends a signal. All of the listeners with a matching signal will have their functions called with the given arguments. Conversation.say also returns all of the values returned by the listeners' functions (in the order that those listeners were created). If you don't know how many values are going to be returned and you want to store all of them, you can put those values in a table like so:
```lua
returnedValues = {conversation:say(s, ...)}
```

- `s` is the signal to look for. I always make them strings, but they can be anything.
- `...` are arguments that will be passed to each listeners' function.
- Returns the values returned by the listeners' functions.

### Disabling listeners
```lua
conversation:stopListening(listener)
```

Disables the listener. The listener's function will no longer be called when a signal is emitted.
- `listener` is the handle of the listener to disable.

### Grouping
You can create listeners as a group:
```lua
group = conversation:group(...)
```

- `...` is a list of signals and functions to use for each listener.

An example usage might look something like this:
```lua
group = conversation.group(
  'player shoot', shoot,
  'player move', move
)
```

This is useful because later you can disable all of the listeners in the group at once with the stopListening function:
```lua
conversation:stopListening(group)
```

It's useful to make a group for each object that creates listeners, such as the player or enemies.
