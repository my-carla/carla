set(PATH ${LIBCARLA_INSTALL_CLIENT_FOLDER}/bin:$ENV{PATH})

find_package(Python COMPONENTS Interpreter Development)


add_custom_target(
    clean_intermediate
    COMMAND rm -Rf build dist source/carla.egg-info
    COMMAND find source -name "*.so" -delete
    COMMAND find source -name "__pycache__" -type d | xargs rm -rf
    WORKING_DIRECTORY ${CARLA_PYTHONAPI_CARLA_DIR}
)


add_custom_target(
    build_python_api
    DEPENDS clean_intermediate
    COMMAND CC=$ENV{CC};CXX=$ENV{CXX};PATH=$ENV{PATH};
        ${Python_EXECUTABLE}
        setup.py bdist_egg bdist_wheel --dist-dir dist/.tmp
    COMMAND cp dist/.tmp/*.whl dist
    COMMAND rm -rf dist/.tmp
    WORKING_DIRECTORY ${CARLA_PYTHONAPI_CARLA_DIR}
)


add_custom_target(
    install_python_api ALL
    DEPENDS build_python_api
)
