-- This comment enforces unit-test coverage for this file:
-- coverage: 0

function get_abstract(arg)
	channel.say(arg.abstract)
end

function invalid()
    channel.say("No dice")
end

local http = require 'summit.http'
local menu = require 'summit.menu'
local speech = require 'summit.speech'
local json = require 'json'
local inspect = require "inspect"

local res, err = http.get('http://getnewspeak.herokuapp.com/headlines')


if err then
    channel.say('Unable to contact news service, goodbye.')
    channel.hangup()
end

local news_content = json:decode(res.content)

channel.answer()
channel.say('Welcome to Newspeak')

local my_ivr = menu()

my_ivr.add(tostring(1), "Press " .. tostring(1) .. " for " .. news_content[1].title, function() get_abstract(news_content[1]) end)
my_ivr.add(tostring(2), "Press " .. tostring(2) .. " for " .. news_content[2].title, function() get_abstract(news_content[2]) end)
my_ivr.add(tostring(3), "Press " .. tostring(3) .. " for " .. news_content[3].title, function() get_abstract(news_content[3]) end)
my_ivr.add(tostring(4), "Press " .. tostring(4) .. " for " .. news_content[4].title, function() get_abstract(news_content[4]) end)
my_ivr.add(tostring(5), "Press " .. tostring(5) .. " for " .. news_content[5].title, function() get_abstract(news_content[5]) end)
my_ivr.default(invalid)
my_ivr.intro("Make your selection, please")

local selection = my_ivr.run()

channel.say("Goodbye, bitches!")

channel.hangup()

