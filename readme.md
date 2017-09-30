# Talkback

**Talkback** is a small Lua library that lets you create "conversations". You can send messages from within a conversation, and you can create listeners that will do something (and optionally send back a response) when they receive a certain message. This is a powerful organizational tool that allows different parts of your code to interact with each other.

## Examples

### Player controls example

```lua
-- in main.lua
conversation = require 'lib.talkback'

-- in player.lua
conversation:listen('player jump', function()
  jump()
end)

-- in input-manager.lua
if input.pressed('x') then
  conversation:say('player jump')
end
```

### High score display example

```lua
-- in score-manager.lua
conversation:listen('get high score', function(place)
  return scores[place]
end)

-- in hud.lua
topScore = conversation:say('get high score')
drawText(topScore)
```

## Installation

To use the library, place talkback.lua in the root folder of your project or in a subfolder, and load it with `require`.

```lua
conversation = require 'talkback' -- if talkback.lua is in the root folder
conversation = require 'path.to.talkback' -- if it's in a subfolder
```

## Usage

### Listening for a message

```lua
listener = conversation:listen(message, f)
```

Creates a new listener. The listener will execute a function `f` when `message` is sent. `message` can be any Lua value.
- Returns a handle to the listener. Store this in a variable if you want to remove the individual listener later.

### Sending a message

```lua
response1, response2, ... = conversation:say(message, ...)
```

Sends `message` to every listener and returns each listener's response.
- '...' are arguments that will be passed to each listener's function

#### Responses

If a listener's function returns values, `conversation:say()` will return those values if the listener's function is called. All of the responses will be returned in the order that each listener returns them and in the order that the listeners were added.

```lua
conversation:listen('lyrics', function() return 'some', 'body' end)
conversation:listen('lyrics', function() return 'once', 'told', 'me' end)
a, b, c, d, e = conversation:say('lyrics')
print(a) -- prints "some"
print(b) -- prints "body"
print(c) -- prints "once"
print(d) -- prints "told"
print(e) -- prints "me"
```

If you're not sure how many responses you'll get, and you want to collect all of them, you can collect the responses in a table:

```lua
lyrics = {conversation:say('lyrics')}
-- lyrics is now the table {'some', 'body', 'once', 'told', 'me'}
```

### Removing listeners

```lua
listener:leave()
```

### Removing all listeners for a certain message

```lua
conversation:ignore(message)
```

### Removing all listeners

```lua
conversation:reset()
```

### Groups

You can create sub-groups from the main `conversation` group. When you say or ignore messages from inside a group, only that group (and child groups) will listen. Groups can be nested infinitely, and Talkback itself is a group.

```lua
conversation = require 'talkback'

conversation:listen('greeting', function() print 'hello' end)
group = conversation:newGroup()
group:listen('greeting', function() print 'world' end)

conversation:say 'greeting' -- prints "hello" and "world"
group:say 'greeting' -- only prints "world"
group:ignore 'greeting'
conversation:say 'greeting' -- now only prints "hello"
```

#### Creating new groups

```lua
group = conversation:newGroup()
subGroup = group:newGroup()
-- etc.
```

#### Removing groups

```lua
group:leave()
```

*Note:* don't call `group:leave()` on the main Talkback group, as this will cause an error, since that group doesn't have a parent.