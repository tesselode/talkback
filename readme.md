Talkback
========
**Talkback** is a tiny observer pattern library for Lua. It allows you to automatically call a function whenever a signal is emitted, making it easy to have different parts of your code communicate with each other without creating spaghetti code. Talkback has a unique feature: listeners (functions tied to a signal) can pass values back to the object that sent the signal.

Examples
-------
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
