function love.load()
  talkback = require 'talkback'
  conversation = talkback.new()

  group = conversation:group(
    'quit', function(arbitrary)
      return arbitrary + 2
    end,
    'stupid', function()
      love.graphics.setBackgroundColor(255, 255, 255, 255)
    end
  )

  conversation:stopListening(group)
end

function love.keypressed(key)
  local arbitrary

  if key == 'escape' then
    arbitrary = conversation:say('quit', 3)
  elseif key == 'return' then
    arbitrary = conversation:say('quit', 5)
  elseif key == ' ' then
    conversation:say('stupid')
  end

  if arbitrary == 7 then
    love.event.quit()
  end
end
