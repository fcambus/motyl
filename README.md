## Description

Motyl is an opinionated static site generator written in Lua. It uses Mustache as templating system, and all content is written in Markdown.

For the record, motyl means butterfly in Polish.

## Features

- Small and easy to understand code (only 130 sloc)
- Minimal dependencies (only four Lua rocks)
- Pages and posts written in Markdown
- Templates are logic-less and use Mustache
- Support for categories
- Customizable URLs (constructed from filename)
- Atom feed generator

## Requirements

Motyl requires Lua 5.1+ and Make.

### Lua modules

Motyl requires the following Lua modules:

- LuaFileSystem
- lunamark
- lustache
- lyaml

Installing via LuaRocks:

	luarocks install luafilesystem
	luarocks install lunamark
	luarocks install lustache
	luarocks install lyaml

Alternatively, those modules can be installed directly using binary packages.

## Installation

## Usage

## License

Motyl is released under the BSD 2-Clause license. See `LICENSE` file
for details.

## Author

Motyl is developed by Frederic Cambus.

- Site : http://www.cambus.net
- Twitter: http://twitter.com/fcambus

## Resources

Project Homepage : http://www.cambus.net/motyl/

GitHub : https://github.com/fcambus/motyl
