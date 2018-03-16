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

# Load and process Markdown file
def markdown(path)
  return Kramdown::Document.new(File.read(path), syntax_highlighter: 'rouge').to_html
end

# Display status message
def status(message)
  puts('[' + Time.now.strftime('%X') + '] ' + message)
end

# Loading configuration
data = {
  'version' => 'Motyl 1.0.0',
  'updated' => Time.now.strftime('%Y-%m-%dT%XZ'),
  'site' => YAML.load_file('motyl.conf'),
  'posts' => [],
  'categories' => {}
}

# Loading templates
templates = {
  'categories' => File.read('themes/templates/categories.mustache'),
  'atom' => File.read('themes/templates/atom.mustache'),
  'pages' => File.read('themes/templates/page.mustache'),
  'posts' => File.read('themes/templates/post.mustache')
}

class Mustache
  self.template_path = 'themes/templates/'
end

def render(directory, templates, data)
  Dir.foreach(directory) do |file|
    next if file == '.' || file == '..'
    extension = File.extname(file)

    if extension == '.md'
      basename = File.basename(file, extension)
      data['page'] = YAML.load_file(directory + '/' + basename + '.yaml')
      data['page']['content'] = Mustache.render(markdown(directory + '/' + file), data)
      data['page']['url'] ||= basename + '/'

      status('Rendering ' + data['page']['url'])

      if directory == 'posts'
        data['page']['datetime'] = DateTime.parse(data['page']['date'])

        data['posts'].push(data['page'])

        data['page']['categoryDisplay'] = []

        # Populate category table
        data['page']['categories'].each do |category|
          data['categories'][category] ||= []
          data['categories'][category].push(data['page'])
          data['page']['categoryDisplay'].push('category' => category, 'url' => data['site']['categoryMap'][category])
        end
      end

      Dir.mkdir('public/' + data['page']['url']) unless Dir.exist?('public/' + data['page']['url'])
      File.write('public/' + data['page']['url'] + 'index.html', Mustache.render(templates[directory], data))

      data['page'] = {}
    end
  end
end

# Render posts
Dir.mkdir('public') unless Dir.exist?('public')
render('posts', templates, data)

# Sort post archives
data['posts'].sort! { |a, b| b['date'] <=> a['date'] }

# Renger pages
render('pages', templates, data)

# Feed
data['feed'] = data['posts'][0..20]

File.write('public/atom.xml', Mustache.render(templates['atom'], data))
status('Rendering atom.xml')
data['page'] = {}

# Categories
Dir.mkdir('public/categories') unless Dir.exist?('public/categories')

data['categories'].keys.each do |category|
  category_url = data['site']['categoryMap'][category] + '/'

  data['categories'][category].sort! { |a, b| b['date'] <=> a['date'] }
  data['page']['title'] = category
  data['page']['url'] = 'categories/' + category_url
  data['posts'] = data['categories'][category]

  Dir.mkdir('public/categories/' + category_url) unless Dir.exist?('public/categories/' + category_url)
  File.write('public/categories/' + category_url + 'index.html', Mustache.render(templates['categories'], data))
  status('Rendering ' + category_url)
end
