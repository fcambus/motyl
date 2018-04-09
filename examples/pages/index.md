## Description

Motyl is an opinionated blog-aware static site generator written in Ruby.
It uses Mustache as templating system, and all content is written in Markdown.

For the record, motyl means butterfly in Polish.

## Features

- Small and easy to understand codebase
- Minimal dependencies (only three gems)
- Pages and posts written in Markdown
- Templates are logic-less and use Mustache
- Support for multiple categories per post
- Syntax highlighting (using Rouge)
- Customizable URLs (constructed from filename)
- Atom feed generator

## Requirements

Motyl requires Ruby.

### Ruby modules

Motyl requires the following Ruby modules:

- kramdown
- mustache
- rouge

Installing dependencies via gem:

	gem install kramdown mustache rouge

Alternatively, those modules can be installed directly using binary packages.

## Configuration

The 'examples' directory contains a sample site which can be used as a
starting point.

### Installing a theme

Clone the [Chrysalide](https://github.com/fcambus/chrysalide) theme repository
and place the files in the `themes` directory.

## Usage

Simply run `motyl` to build the site, it will generate posts and pages into
the `public` directory, and will also copy static assets.

## License

Motyl is released under the BSD 2-Clause license. See `LICENSE` file
for details.

## Author

Motyl is developed by Frederic Cambus.

- Site: https://www.cambus.net

## Resources

GitHub: https://github.com/fcambus/motyl
