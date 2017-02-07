default:
	@rm -rf deploy/
	@motyl
	@echo [`date +"%T"`] Copying assets and static files
	@cp -r themes/fonts themes/scripts themes/styles deploy/
	@cp -r static/* deploy/
	@echo [`date +"%T"`] Done

clean:
	@rm -rf deploy
