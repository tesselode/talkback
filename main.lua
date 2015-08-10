function love.load()
  talkback = require 'talkback'
  conversation = talkback.new()

  quitListener = conversation:listen('quit', function(arbitrary)
    return arbitrary + 2
  end)
  conversation:stopListening(quitListener)
end

function love.keypressed(key)
  local arbitrary
  if key == 'escape' then
    arbitrary = conversation:say('quit', 3)
  elseif key == 'return' then
    arbitrary = conversation:say('quit', 5)
  end
  if arbitrary == 7 then
    love.event.quit()
  end
end
