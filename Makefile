SHELL := bash


.PHONY: rebuild
rebuild: clean build


.PHONY: build
build: build_ue4 build_client


.PHONY: build_client
build_client: # build_third_party
	@-mkdir -p build
	cd build && \
	cmake -DBUILD_THIRD_PARTY=OFF -DBUILD_CLIENT=ON -DBUILD_PYTHON_API=OFF .. && \
	make install_libcarla


.PHONY: build_server
build_server: # build_third_party
	@-mkdir -p build
	cd build && \
	cmake -DBUILD_THIRD_PARTY=OFF -DBUILD_CLIENT=OFF -DBUILD_PYTHON_API=OFF .. && \
	make install_libcarla

.PHONY: build_ue4
build_ue4: build_server
	@-mkdir -p build
	cd build && \
	make build_carla_ue4

# .PHONY: build_python_api
# build_python_api: build_client
# 	cd build && \
# 	cmake -DBUILD_PYTHON_API=ON .. && \
# 	make install_libcarla


.PHONY: build_third_party
build_third_party:
	@-mkdir -p build
	cd build && \
	cmake -DBUILD_THIRD_PARTY=ON .. && \
	make install_third_party && \
	make install_extra_plugins


.PHONY: clean 
clean:
	@-rm -Rf build Install
	@-rm -Rf PythonAPI/carla/dependencies/include
	@-rm -Rf PythonAPI/carla/dependencies/lib
	@-rm -Rf Unreal/CarlaUE4/Plugins/Carla/CarlaDependencies/include
	@-rm -Rf Unreal/CarlaUE4/Plugins/Carla/CarlaDependencies/share
	@-rm -Rf Unreal/CarlaUE4/Plugins/Carla/CarlaDependencies/lib
	@-rm -Rf Unreal/CarlaUE4/Plugins/Carla/CarlaDependencies/bin
