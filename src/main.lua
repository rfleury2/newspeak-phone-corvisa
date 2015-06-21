-- This comment enforces unit-test coverage for this file:
-- coverage: 0

http = require 'summit.http'
menu = require 'summit.menu'
speech = require 'summit.speech'
json = require 'json'
inspect = require "inspect"
log = require "summit.log"


category_names = { 'u.s.', 'world', 'sports', 'business', 'technology', 'science', 'health' }

function get_abstract(arg)
	channel.say(arg.abstract)
	get_link_menu(arg.url)
end

function invalid()
    channel.say("Not a valid selection")
end

function send_article(selection)
	local url = selection
	sms = require "summit.sms"

	to = channel.data.ani
	from = "+1" .. channel.data.dnis
	message = "You have saved " .. url .. " for later."
	ok, err = sms.send(to, from, message)
	log.debug("This is the ok message: " .. ok)
	get_main_menu()
end

function select_category(cat)
	selected_category = cat
end

function hangup()
	channel.say("Goodbye!")
	channel.hangup()
end

function get_user_info()
	-- phone_number = '6039690489'
	phone_number = channel.data.ani

	user_url = "https://getnewspeak.herokuapp.com/api/v1/users/" .. phone_number
	res, err = http.get(user_url)

	if err or res.data == '' then
		get_main_menu()
	end

	user_info = json:decode(res.content)
	if user_info.categories[1] then
		category_names = {}
		for index, category in ipairs(user_info.categories) do
			category_names[index] = category.abbreviation
		end
	end
	channel.say("Welcome to Newspeak, " .. user_info.name)
end


-- Main menu
function get_main_menu()
	selected_category = ""
	cat_counter = 1
	main_menu = menu()
	main_menu.intro("Select a news topic.")
	for index, category in ipairs(category_names) do 
		main_menu.add(tostring(index), "For " .. category .. ", press " .. tostring(index), function() select_category(category) end)
	end
	main_menu.run()
	channel.say("Selected Category: " .. selected_category)
	get_category_menu()
end


-- API Call
function get_category_menu()
	url = "http://getnewspeak.herokuapp.com/headlines?categories=" .. selected_category
	res, err = http.get(url)

	if err then
	    channel.say('Unable to contact news service, goodbye.')
	    channel.hangup()
	end

	news_content = json:decode(res.content)

	-- Category Menu
	category_menu = menu()

	category_menu.add(tostring(1), "Press " .. tostring(1) .. " for " .. news_content[1].title, function() get_abstract(news_content[1]) end)
	category_menu.add(tostring(2), "Press " .. tostring(2) .. " for " .. news_content[2].title, function() get_abstract(news_content[2]) end)
	category_menu.add(tostring(3), "Press " .. tostring(3) .. " for " .. news_content[3].title, function() get_abstract(news_content[3]) end)
	category_menu.add(tostring(4), "Press " .. tostring(4) .. " for " .. news_content[4].title, function() get_abstract(news_content[4]) end)
	category_menu.add(tostring(5), "Press " .. tostring(5) .. " for " .. news_content[5].title, function() get_abstract(news_content[5]) end)
	category_menu.default(invalid)
	category_menu.intro("Make your selection, please")

	category_menu.run()
	get_link_menu()
end


-- Link Menu
function get_link_menu(selection)
	link_menu = menu()

	link_menu.add(tostring(1), "To receive a link to the full article, press 1", function() send_article(selection) end)
	link_menu.add(tostring(2), "To continue browsing, press 2", get_main_menu)
	link_menu.add(tostring(3), "To close Newspeak, press 3", hangup)
	link_menu.default(invalid)
	link_menu.run()
end

-- Welcome
channel.answer()
get_user_info()
get_main_menu()



