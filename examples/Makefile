default:
	@rm -rf public/
	@motyl
	@echo [`date +"%T"`] Copying assets and static files
	@cp -r themes/fonts themes/scripts themes/styles public/
	@cp -r static/* public/
	@echo [`date +"%T"`] Done

clean:
	@rm -rf public
