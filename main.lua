local talkback = require 'talkback'

-- listener adding and leaving
do
	local testVariable = 1
	local testListener = talkback:listen('hi', function()
		testVariable = testVariable + 1
	end)
	talkback:say 'hi'

	assert(testVariable == 2, "test failed: listeners don't respond to group:say()")

	testListener:leave()
	talkback:say 'hi'
	assert(testVariable == 2, "test failed: listeners don't leave")
end

-- ignore and reset
do
	local test1 = 1
	local test2 = 1
	local test3 = 1
	talkback:listen('hi', function() test1 = test1 + 1 end)
	talkback:listen('hi', function() test2 = test2 + 1 end)
	talkback:listen('hello', function() test3 = test3 + 1 end)
	talkback:say 'hi'
	talkback:say 'hello'

	assert(test1 == 2, "test failed: listeners don't respond to group:say()")
	assert(test2 == 2, "test failed: listeners don't respond to group:say()")
	assert(test3 == 2, "test failed: listeners don't respond to group:say()")

	talkback:ignore 'hi'
	talkback:say 'hi'
	talkback:say 'hello'

	assert(test1 == 2, "test failed: group:ignore() doesn't work")
	assert(test2 == 2, "test failed: group:ignore() doesn't work")
	assert(test3 == 3, "test failed: group:ignore() removes listeners it shouldn't remove")

	talkback:reset()
	talkback:say 'hi'
	talkback:say 'hello'

	assert(test1 == 2, "test failed: group:reset() doesn't work")
	assert(test2 == 2, "test failed: group:reset() doesn't work")
	assert(test3 == 3, "test failed: group:reset() doesn't work")
end

-- groups
do
	local group = talkback:newGroup()
	local subGroup = group:newGroup()
	local test = 1
	talkback:listen('hi', function() test = test + 1 end)
	group:listen('hi', function() test = test + 1 end)
	subGroup:listen('hi', function() test = test + 1 end)

	talkback:say 'hi'
	assert(test == 4, "test failed: group:say() doesn't call nested groups correctly")
	group:say 'hi'
	assert(test == 6, "test failed: group:say() doesn't call nested groups correctly")
	subGroup:say 'hi'
	assert(test == 7, "test failed: group:say() doesn't call nested groups correctly")

	group:leave()
	talkback:say 'hi'
	assert(test == 8, "test failed: group:leave() doesn't work")

	group = talkback:newGroup()
	group:listen('hi', function() test = test + 1 end)
	talkback:say 'hi'
	assert(test == 10, "test failed: listeners don't respond to group:say()")
	talkback:reset()
	talkback:say 'hi'
	assert(test == 10, "test failed: talkback:reset() doesn't remove groups")
end

-- returns
do
	local group = talkback:newGroup()
	local subGroup = group:newGroup()
	subGroup:listen('hi', function()
		return 'somebody', 'once'
	end)
	group:listen('hi', function()
		return 'told', 'me', 'the'
	end)
	talkback:listen('hi', function()
		return 'world', 'is', 'gonna', 'roll', 'me'
	end)

	local responses = {talkback:say 'hi'}
	assert(#responses == 10, "talkback:say doesn't return responses correctly")
	assert(responses[1] == 'somebody', "talkback:say doesn't return responses correctly")
	assert(responses[2] == 'once', "talkback:say doesn't return responses correctly")
	assert(responses[3] == 'told', "talkback:say doesn't return responses correctly")
	assert(responses[4] == 'me', "talkback:say doesn't return responses correctly")
	assert(responses[5] == 'the', "talkback:say doesn't return responses correctly")
	assert(responses[6] == 'world', "talkback:say doesn't return responses correctly")
	assert(responses[7] == 'is', "talkback:say doesn't return responses correctly")
	assert(responses[8] == 'gonna', "talkback:say doesn't return responses correctly")
	assert(responses[9] == 'roll', "talkback:say doesn't return responses correctly")
	assert(responses[10] == 'me', "talkback:say doesn't return responses correctly")

	local responses = {group:say 'hi'}
	assert(#responses == 5, "group:say() is returning responses from parent groups, somehow")
	assert(responses[1] == 'somebody', "group:say() is returning responses from parent groups, somehow")
	assert(responses[2] == 'once', "group:say() is returning responses from parent groups, somehow")
	assert(responses[3] == 'told', "group:say() is returning responses from parent groups, somehow")
	assert(responses[4] == 'me', "group:say() is returning responses from parent groups, somehow")
	assert(responses[5] == 'the', "group:say() is returning responses from parent groups, somehow")
end

print 'all tests passed'

love = love or {}

function love.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	end
end

function love.draw()
	love.graphics.print 'all tests passed!'
end