local talkback = require 'talkback'

do
	local testVariable = 1
	local testListener = talkback.listen('hi', function()
		testVariable = testVariable + 1
	end)
	talkback.say 'hi'

	assert(testVariable == 2)

	testListener:leave()
	talkback.say 'hi'
	assert(testVariable == 2)
end

do
	local test1 = 1
	local test2 = 1
	local test3 = 1
	talkback.listen('hi', function() test1 = test1 + 1 end)
	talkback.listen('hi', function() test2 = test2 + 1 end)
	talkback.listen('hello', function() test3 = test3 + 1 end)
	talkback.say 'hi'
	talkback.say 'hello'

	assert(test1 == 2)
	assert(test2 == 2)
	assert(test3 == 2)

	talkback.ignore 'hi'
	talkback.say 'hi'
	talkback.say 'hello'

	assert(test1 == 2)
	assert(test2 == 2)
	assert(test3 == 3)

	talkback.reset()
	talkback.say 'hi'
	talkback.say 'hello'

	assert(test1 == 2)
	assert(test2 == 2)
	assert(test3 == 3)
end
