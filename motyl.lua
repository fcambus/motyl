#!/usr/bin/env lua
--[[
###############################################################################
#                                                                             #
# Motyl                                                                       #
# Copyright (c) 2016, Frederic Cambus                                         #
# http://www.cambus.net/motyl/                                                #
#                                                                             #
# Created: 2016-02-16                                                         #
# Last Updated: 2016-03-03                                                    #
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

local function readFile(path)
	local file = io.open(path, "rb")

	local content = file:read "*all"
	file:close()

	return content
end

local function writeFile(path, data)
	local file = io.open(path, "wb")

	file:write(data)
	file:close()
end

local function loadJSON(path)
	return cjson.decode(readFile(path))
end

local function loadMD(path)
	return markdown(readFile(path))
end

local function sortDates(a,b)
	return a.date > b.date
end

local function status(message)
	print("[" .. os.date("%X") .. "] " .. message)
end

-- Loading configuration
local data = {}
data.site = loadJSON("config.json")
data.site.datetime = os.date("%c")
data.site.year = os.date('%Y')

-- Loading templates
local templates = {
	header = readFile("templates/header.mustache"),
	archives = readFile("templates/archives.mustache"),
	pages = readFile("templates/page.mustache"),
	posts = readFile("templates/post.mustache"),
	footer = readFile("templates/footer.mustache")
}

data.site.posts = {}
data.site.categories = {}

local function render(directory)
	for file in lfs.dir(directory) do
		if file ~= "." and file ~= ".." then
			extension = file:match "[^.]+$"

			if extension == "md" then
				path = file:match "(.*).md$"
				data.page = loadJSON(directory .. "/" .. path .. ".json")
				data.page.content = loadMD(directory .. "/" .. file)
				data.page.url = path .. "/"

				status("Rendering " .. data.page.url)

				if directory == "posts" then 
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

				output = lustache:render(templates[directory], data, templates)

				lfs.mkdir(data.site.destination .. path)
				writeFile(data.site.destination .. path .. "/index.html", output)
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
data.page.url = nil
output = lustache:render(templates.archives, data, templates)
writeFile(data.site.destination .. "index.html", output)
status("Rendering index.html")

-- Categories
lfs.mkdir(data.site.destination .. "categories")

for category in pairs(data.site.categories) do
	local categoryURL = data.site.categoryMap[category] .. "/"

	table.sort(data.site.categories[category], sortDates)

	data.page.title = category
	data.page.url = categoryURL
	data.site.posts = data.site.categories[category]
	output = lustache:render(templates.archives, data, templates)

	lfs.mkdir(data.site.destination .. "categories/" .. categoryURL)
	writeFile(data.site.destination .. "categories/" .. categoryURL .. "index.html", output)
	status("Rendering " .. categoryURL)
end
