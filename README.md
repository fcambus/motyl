## Description

Motyl is an opinionated blog-aware static site generator written in Lua.
It uses Mustache as templating system, and all content is written in Markdown.

For the record, motyl means butterfly in Polish.

## Features

- Small and easy to understand code (only 131 sloc)
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

Installing dependencies via LuaRocks:

	luarocks install luafilesystem
	luarocks install lunamark
	luarocks install lustache
	luarocks install lyaml

Alternatively, those modules can be installed directly using binary packages.

## Configuration

The 'examples' directory contains a sample site which can be used as a
starting point.

### Installing a theme

Clone the [Chrysalide](https://github.com/fcambus/chrysalide) theme repository
and place the files in the `themes` directory.

## Usage

Simply run `make` to build the site, it will generate posts and pages into
the `public` directory, and will also copy static assets.

## License

Motyl is released under the BSD 2-Clause license. See `LICENSE` file
for details.

## Author

Motyl is developed by Frederic Cambus.

- Site: https://www.cambus.net

## Resources

GitHub: https://github.com/fcambus/motyl
