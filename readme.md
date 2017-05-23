# Talkback

**Talkback** is a tiny observer pattern library for Lua. It allows you to associate functions with messages that you can send from anywhere in your code, allowing for easy communication across different parts of your code. Talkback has a unique feature: listeners (which are functions tied to a message) can pass values back to the sender.

The library uses a conversation metaphor: *listeners* execute a function when a message is sent, and you can *say* a message to execute those functions.

## Examples

### Player controls example
```lua
--in player.lua
shootListener = conversation:listen('player jump', function()
  jump()
end)

--in input-manager.lua
if input.pressed('x') then
  conversation:say('player jump')
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

## Installation

To use the library, place talkback.lua in the root folder of your project or in a subfolder.
```lua
talkback = require 'talkback' -- if talkback.lua is in the root folder
talkback = require 'path.to.talkback' -- if it's in a subfolder
```

## Usage

### Creating a new conversation
```lua
conversation = talkback.new()
```
**Conversations** contain and manage listeners. You'll probably only need one for your project, so keep this in a global variable.

### Creating a listener
```lua
listener = conversation:listen(m, f)
```
Creates a listener. A listener executes a function `f` when a certain message `m` sent.
- `m` is the message to listen for. I always make them strings, but they can be anything.
- `f` is the function to call when the message is sent.
- Returns a handle to the listener. You'll want to keep this so you can remove the listener later.

### Sending a message
```lua
returnedValue1, returnedValue2, ... = conversation:say(m, ...)
```
Sends a message `m`. All of the listeners listening for that message will have their functions called with the given arguments. `Conversation.say` also returns all of the values returned by the listeners' functions (in the order that those listeners were created). If you don't know how many values are going to be returned and you want to store all of them, you can put those values in a table like so:
```lua
returnedValues = {conversation:say(m, ...)}
```
- `m` is the message to look for. I always make them strings, but they can be anything.
- `...` are arguments that will be passed to each listeners' function.
- Returns the values returned by the listeners' functions.

### Disabling listeners
```lua
conversation:stopListening(listener)
```
Disables the listener. The listener's function will no longer be called.
- `listener` is the listener to disable.

### Listener groups
You can create groups that hold multiple listeners:
```lua
group = conversation:newGroup()
group:listen(m, f)
```

An example usage might look something like this:
```lua
group = conversation:newGroup()
group:listen('player jump', jump)
group:listen('player move', move)
```

This is useful because later you can disable all of the listeners in the group at once with the stopListening function:
```lua
conversation:stopListening(group)
```

It's useful to make a group for each object that creates listeners, such as the player or enemies.

## Contributing

Feel free to open issues or pull requests! To run the tests, just run test.lua with any Lua interpreter.

## License

The MIT License (MIT)

Copyright (c) 2015 Andrew Minnich

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
