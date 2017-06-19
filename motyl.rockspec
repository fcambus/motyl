package = "Motyl"
version = ""

source = {
	url = "git://github.com/fcambus/motyl",
	tag = ""
}

description = {
	summary = "Opinionated blog-aware static site generator written in Lua.",
	homepage = "https://github.com/fcambus/motyl",
	license = "BSD"
}

dependencies = {
	"lua ~> 5.1",
	"luafilesystem",
	"lunamark",
	"lustache",
	"lyaml"
}

build = {
	install = {
		bin = {
			motyl = "src/motyl.lua"
		}
	}
}
