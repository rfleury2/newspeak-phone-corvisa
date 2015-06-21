-- This comment enforces unit-test coverage for this file:
-- coverage: 0

function get_abstract(arg)
	channel.say(arg.abstract)
end

function invalid()
    channel.say("Not a valid selection")
end

function select_category(cat)
	selected_category = cat
end

local http = require 'summit.http'
local menu = require 'summit.menu'
local speech = require 'summit.speech'
local json = require 'json'
local inspect = require "inspect"

local phone_number = channel.data.remotenumber
channel.say(phone_number)


channel.answer()
channel.say('Welcome to Newspeak')

-- Main menu
selected_category = ""
local category_names = { 'u.s.', 'world', 'entertainment', 'sports', 'business', 'politics', 'technology', 'science', 'health' }
local cat_counter = 1
local main_menu = menu()

main_menu.intro("Select a news topic.")
for index, category in ipairs(category_names) do 
	main_menu.add(tostring(index), "For " .. category .. ", press " .. tostring(index), function() select_category(category) end)
end
main_menu.run()

channel.say("Selected Category: " .. selected_category)





-- param passed back (category name)

local url = "http://getnewspeak.herokuapp.com/headlines?categories=" .. selected_category
local res, err = http.get(url)

if err then
    channel.say('Unable to contact news service, goodbye.')
    channel.hangup()
end

local news_content = json:decode(res.content)




local category_menu = menu()

category_menu.add(tostring(1), "Press " .. tostring(1) .. " for " .. news_content[1].title, function() get_abstract(news_content[1]) end)
category_menu.add(tostring(2), "Press " .. tostring(2) .. " for " .. news_content[2].title, function() get_abstract(news_content[2]) end)
category_menu.add(tostring(3), "Press " .. tostring(3) .. " for " .. news_content[3].title, function() get_abstract(news_content[3]) end)
category_menu.add(tostring(4), "Press " .. tostring(4) .. " for " .. news_content[4].title, function() get_abstract(news_content[4]) end)
category_menu.add(tostring(5), "Press " .. tostring(5) .. " for " .. news_content[5].title, function() get_abstract(news_content[5]) end)
category_menu.default(invalid)
category_menu.intro("Make your selection, please")

local selection = category_menu.run()

channel.say("Goodbye, bitches!")

channel.hangup()

