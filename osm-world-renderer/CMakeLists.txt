cmake_minimum_required(VERSION 3.5.1)
project(OsmMapRenderer)
set(osm_3rd_install_dir ${install_dir}/OsmRenderer3rd)

# Libosmscout and Luna SVG Library
add_subdirectory(ThirdParties)

include_directories(${osm_3rd_install_dir}/include)
include_directories(${osm_3rd_install_dir}/include/lunasvg)
link_directories(${osm_3rd_install_dir}/lib)

add_definitions(-D_USE_MATH_DEFINES)

# Source Files
add_library(OsmRenderer OsmRenderer/src/OsmRenderer.cpp)
target_sources(OsmRenderer PRIVATE OsmRenderer/src/MapDrawer.cpp)
target_sources(OsmRenderer PRIVATE OsmRenderer/src/MapRasterizer.cpp)
target_include_directories( OsmRenderer PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/OsmRenderer/include)

add_executable(osm-world-renderer OsmRenderer/main.cpp)
target_link_libraries(osm-world-renderer OsmRenderer)
target_link_libraries(osm-world-renderer osmscout)
target_link_libraries(osm-world-renderer osmscout_map)
target_link_libraries(osm-world-renderer osmscout_map_svg)
target_link_libraries(osm-world-renderer lunasvg)
