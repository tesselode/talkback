function love.load()
  talkback = require 'talkback'
  conversation = talkback.new()

  group = conversation:group(
    'quit', function(arbitrary)
      return arbitrary + 2
    end,
    'quit', function(arbitrary)
      return arbitrary + 3
    end,
    'quit', function(arbitrary)
      return arbitrary + 4
    end,
    'stupid', function()
      love.graphics.setBackgroundColor(255, 255, 255, 255)
    end
  )

  --conversation:stopListening(group)
end

function love.keypressed(key)
  local arbitrary

  if key == 'escape' then
    arbitrary = {conversation:say('quit', 3)}
    for k, v in pairs(arbitrary) do
      print(k, v)
    end
  elseif key == 'return' then
    arbitrary = {conversation:say('quit', 5)}
    for k, v in pairs(arbitrary) do
      print(k, v)
    end
  elseif key == ' ' then
    conversation:say('stupid')
  end
end
