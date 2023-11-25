cmake_minimum_required(VERSION 3.5.1)
include(cmake/env.cmake)
set(CMAKE_C_COMPILER $ENV{CC})
set(CMAKE_CXX_COMPILER $ENV{CXX})

project(CARLA)


option(BUILD_THIRD_PARTY "Build just build third party" OFF)
option(BUILD_CLIENT "Build carla client" ON)
option(BUILD_PYTHON_API "Build carla python api" OFF)

option(LIBCARLA_BUILD_DEBUG "Build debug configuration" ON)
option(LIBCARLA_BUILD_RELEASE "Build release configuration" ON)
option(LIBCARLA_BUILD_TEST "Build unit tests" OFF)

include(cmake/var.cmake)
configure_file(${CARLA_THIRD_PARTIES_INFO_CMAKE_IN}
    ${CARLA_THIRD_PARTIES_INFO_CMAKE}
)
include(${CARLA_THIRD_PARTIES_INFO_CMAKE})


if(BUILD_THIRD_PARTY)
    add_subdirectory(ExtraPlugins)
    add_subdirectory(ThirdParties)
else()
    if(BUILD_CLIENT)
        set(CMAKE_BUILD_TYPE "Client")
    else()
        set(CMAKE_BUILD_TYPE "Server")
    endif(BUILD_CLIENT)

    # add_subdirectory(osm-world-renderer)
    add_subdirectory(LibCarla)

    if(NOT BUILD_CLIENT)
        add_subdirectory(Unreal/CarlaUE4/cmake)
    endif(NOT BUILD_CLIENT)

    if(BUILD_PYTHON_API)
        add_subdirectory(PythonAPI)
    endif(BUILD_PYTHON_API)
endif(BUILD_THIRD_PARTY)

