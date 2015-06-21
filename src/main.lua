-- This comment enforces unit-test coverage for this file:
-- coverage: 0

function get_abstract(article)
    channel.say(article.abstract)
end

function get_title(article)
    channel.say(article.title)
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

local selection = 0
local my_ivr = menu()

local i = 1
while i < 5 do
	my_ivr.add(tostring(i), "Press " .. tostring(i) .. " for " .. news_content[i].title, function() get_abstract(news_content[i]) end)
	i = i+1
end
my_ivr.default(invalid)

channel.say('Make your selection, please')
local selection = my_ivr.run()
repl()


channel.hangup()

