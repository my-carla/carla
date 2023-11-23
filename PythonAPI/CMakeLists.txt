set(PATH ${LIBCARLA_INSTALL_CLIENT_FOLDER}/bin:$ENV{PATH})

find_package(Python COMPONENTS Interpreter Development)


add_custom_target(
    clean_intermediate
    COMMAND rm -Rf build dist source/carla.egg-info
    COMMAND find source -name "*.so" -delete
    COMMAND find source -name "__pycache__" -type d -exec rm -r "{}"
    WORKING_DIRECTORY ${CARLA_PYTHONAPI_SOURCE_FOLDER}
)


add_custom_target(
    build_python_api
    DEPENDS clean_intermediate
    COMMAND PATH=${PATH}; ${Python_EXECUTABLE}
        setup.py bdist_egg bdist_wheel --dist-dir dist/.tmp
    COMMAND cp dist/.tmp/$(ls dist/.tmp | grep .whl) dist
    COMMAND rm -rf dist/.tmp
    WORKING_DIRECTORY ${CARLA_PYTHONAPI_SOURCE_FOLDER}
)


add_custom_target(
    install_python_api ALL
    DEPENDS build_python_api
)
