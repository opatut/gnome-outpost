default: bake run

clean:
	@[[ -d build ]] && rm -r build

bake:
	@mkdir -p build/
	@cd build && cmake .. && make -j4

run:
	@bin/gnome-outpost
