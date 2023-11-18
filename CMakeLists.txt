cmake_minimum_required(VERSION 3.5.1)
include(${CMAKE_CURRENT_LIST_DIR}/cmake/env.cmake)
set(CMAKE_C_COMPILER $ENV{CC})
set(CMAKE_CXX_COMPILER $ENV{CXX})

project(CARLA)

include(${CMAKE_CURRENT_LIST_DIR}/cmake/var.cmake)

# include("Build/CMakeLists.txt.in")

add_subdirectory("ThirdParty")
# add_subdirectory("LibCarla/cmake")
