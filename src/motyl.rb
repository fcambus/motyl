#!/usr/bin/env ruby
###############################################################################
#                                                                             #
# Motyl                                                                       #
# Copyright (c) 2016-2018, Frederic Cambus                                    #
# https://github.com/fcambus/motyl                                            #
#                                                                             #
# Created: 2016-02-16                                                         #
# Last Updated: 2018-03-13                                                    #
#                                                                             #
# Motyl is released under the BSD 2-Clause license.                           #
# See LICENSE file for details.                                               #
#                                                                             #
###############################################################################

require 'kramdown'
require 'mustache'
require 'yaml'

# Load YAML from file
def loadYAML(path)
	return YAML.load_file(path)
end

# Load and process Markdown file
def loadMD(path)
	return Kramdown::Document.new(File.read(path)).to_html
end

# Display status message
def status(message)
	puts("[" + Time.now.strftime("%X") + "] " + message)
end

# Loading configuration
data = {}
data["version"] = "Motyl 1.00"
data["updated"] = Time.now.strftime("%Y-%m-%dT%XZ")
data["site"] = loadYAML("motyl.conf")
data["site"]["feed"] = {}
data["site"]["posts"] = []
data["site"]["categories"] = {}

# Loading templates
templates = {
	"categories" => File.read("themes/templates/categories.mustache"),
	"atom" => File.read("themes/templates/atom.mustache"),
	"pages" => File.read("themes/templates/page.mustache"),
	"posts" => File.read("themes/templates/post.mustache")
}

class Mustache
	self.template_path = "themes/templates/"
end

def render(directory, templates, data)
	Dir.foreach(directory) do |file|
		next if file == '.' or file == '..'
		extension = File.extname(file)

		if extension == ".md"
			basename = File.basename(file, extension)
			data["page"] = loadYAML(directory + "/" + basename + ".yaml")
			data["page"]["content"] = Mustache.render(loadMD(directory + "/" + file), data)
			if data["page"]["url"].nil?
				data["page"]["url"] = basename + "/"
			end

			status("Rendering " + data["page"]["url"])

			if directory == "posts" then
				data["page"]["datetime"] = DateTime.parse(data["page"]["date"])

				data["site"]["posts"].push(data["page"])

				data["page"]["categoryDisplay"] = []

				# Populate category table
				data["page"]["categories"].each do |category|
					if data["site"]["categories"][category].nil?
						data["site"]["categories"][category] = []
					end
					data["site"]["categories"][category].push(data["page"])
					data["page"]["categoryDisplay"].push({ "category" => category, "url" => data["site"]["categoryMap"][category]})
				end
			end

			Dir.mkdir("public/" + data["page"]["url"]) unless Dir.exist?("public/" + data["page"]["url"])
			File.write("public/" + data["page"]["url"] + "index.html", Mustache.render(templates[directory], data))

			data["page"] = {}
		end
	end
end

# Render posts
Dir.mkdir("public") unless Dir.exist?("public")
render("posts", templates, data)

# Sort post archives
data["site"]["posts"] = data["site"]["posts"].sort { |a,b| b["date"] <=> a["date"] }

# Renger pages
render("pages", templates, data)

# Feed
data["site"]["feed"] = data["site"]["posts"][0..20]

File.write("public/atom.xml", Mustache.render(templates["atom"], data))
status("Rendering atom.xml")
data["page"] = {}

# Categories
Dir.mkdir("public/categories") unless Dir.exist?("public/categories")

data["site"]["categories"].keys.each do |category|
	categoryURL = data["site"]["categoryMap"][category] + "/"

	data["site"]["categories"][category] = data["site"]["categories"][category].sort { |a,b| b["date"] <=> a["date"] }
	data["page"]["title"] = category
	data["page"]["url"] = "categories/" + categoryURL
	data["site"]["posts"] = data["site"]["categories"][category]

	Dir.mkdir("public/categories/" + categoryURL) unless Dir.exist?("public/categories/" + categoryURL)
	File.write("public/categories/" + categoryURL + "index.html", Mustache.render(templates["categories"], data))
	status("Rendering " + categoryURL)
end
