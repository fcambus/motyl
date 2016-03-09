#!/usr/bin/env lua
--[[
###############################################################################
#                                                                             #
# Motyl                                                                       #
# Copyright (c) 2016, Frederic Cambus                                         #
# http://www.cambus.net/motyl/                                                #
#                                                                             #
# Created: 2016-02-16                                                         #
# Last Updated: 2016-03-05                                                    #
#                                                                             #
# Motyl is released under the BSD 3-Clause license.                           #
# See LICENSE file for details.                                               #
#                                                                             #
###############################################################################
]]--

local cjson = require "cjson"
local lfs = require "lfs"
local lustache = require "lustache"
local markdown = require "markdown"

-- Read data from file
local function readFile(path)
	local file = assert(io.open(path, "rb"))

	local data = file:read "*all"
	file:close()

	return data
end

-- Write data to file
local function writeFile(path, data)
	local file = assert(io.open(path, "wb"))

	file:write(data)
	file:close()
end

-- Load JSON from file
local function loadJSON(path)
	return cjson.decode(readFile(path))
end

-- Load and process Markdown file 
local function loadMD(path)
	return markdown(readFile(path))
end

-- Render a mustache template
local function renderTemplate(template, data, templates) 
	return lustache:render(template, data, templates)
end

-- Sorting function to sort posts by date
local function sortDates(a,b)
	return a.date > b.date
end

-- Display status message
local function status(message)
	print("[" .. os.date("%X") .. "] " .. message)
end

-- Loading configuration
local data = {}
data.site = loadJSON("config.json")
data.site.year = os.date('%Y')

-- Loading templates
local templates = {
	header = readFile("themes/templates/header.mustache"),
	archives = readFile("themes/templates/archives.mustache"),
	atom = readFile("themes/templates/atom.mustache"),
	pages = readFile("themes/templates/page.mustache"),
	posts = readFile("themes/templates/post.mustache"),
	footer = readFile("themes/templates/footer.mustache")
}

data.site.feed = {}
data.site.posts = {}
data.site.categories = {}

local function render(directory)
	for file in lfs.dir(directory) do
		if file ~= "." and file ~= ".." then
			local extension = file:match "[^.]+$"

			if extension == "md" then
				local path = file:match "(.*).md$"
				data.page = loadJSON(directory .. "/" .. path .. ".json")
				data.page.content = loadMD(directory .. "/" .. file)
				data.page.url = path .. "/"

				status("Rendering " .. data.page.url)

				if directory == "posts" then 
					local year, month, day, hour, min = data.page.date:match("(%d+)%-(%d+)%-(%d+) (%d+)%:(%d+)")
					data.page.datetime = os.date("%c", os.time{year=year, month=month, day=day, hour=hour, min=min})

					table.insert(data.site.posts, data.page)

					data.page.categoryDisplay = {}

					-- Populate category table
					for i, category in ipairs(data.page.categories) do
						if not data.site.categories[category] then
							data.site.categories[category] = {}
						end

						table.insert(data.site.categories[category], data.page)
						table.insert(data.page.categoryDisplay, { category = category, url = data.site.categoryMap[category]})
					end
				end

				lfs.mkdir(data.site.destination .. path)
				writeFile(data.site.destination .. path .. "/index.html", renderTemplate(templates[directory], data, templates))

				data.page = {}
			end
		end
	end
end

-- Render posts and pages
lfs.mkdir(data.site.destination)

render("posts")
render("pages")

table.sort(data.site.posts, sortDates)

-- Index
data.page.title = data.site.title
data.page.description = data.site.description
data.page.keywords = data.site.keywords

writeFile(data.site.destination .. "index.html", renderTemplate(templates.archives, data, templates))
status("Rendering index.html")

-- Feed
for loop=1, 20 do
	data.site.feed[loop] = data.site.posts[loop]
end

writeFile(data.site.destination .. "atom.xml", renderTemplate(templates.atom, data, templates))
status("Rendering atom.xml")
data.page = {}

-- Categories
lfs.mkdir(data.site.destination .. "categories")

for category in pairs(data.site.categories) do
	local categoryURL = data.site.categoryMap[category] .. "/"

	table.sort(data.site.categories[category], sortDates)

	data.page.title = category
	data.page.url = "categories/" .. categoryURL
	data.site.posts = data.site.categories[category]

	lfs.mkdir(data.site.destination .. "categories/" .. categoryURL)
	writeFile(data.site.destination .. "categories/" .. categoryURL .. "index.html", renderTemplate(templates.archives, data, templates))
	status("Rendering " .. categoryURL)
end
