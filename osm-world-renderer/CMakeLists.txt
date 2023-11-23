cmake_minimum_required(VERSION 3.5.1)
project(OsmMapRenderer)

include_directories(
    ${OSMSCOUT_CLIENT_INSTALL_DIR}/include
    ${LUNASVG_CLIENT_INSTALL_DIR}/include/lunasvg
)
link_directories(
    ${LUNASVG_CLIENT_INSTALL_DIR}/lib
    ${OSMSCOUT_CLIENT_INSTALL_DIR}/lib
)

add_definitions(-D_USE_MATH_DEFINES)

# Source Files
add_library(OsmRenderer OsmRenderer/src/OsmRenderer.cpp)
target_sources(OsmRenderer PRIVATE OsmRenderer/src/MapDrawer.cpp)
target_sources(OsmRenderer PRIVATE OsmRenderer/src/MapRasterizer.cpp)
target_compile_features(OsmRenderer PRIVATE cxx_std_17)
target_include_directories( OsmRenderer PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}/OsmRenderer/include
    ${BOOST_INSTALL_DIR}/include
)

add_executable(osm-world-renderer OsmRenderer/main.cpp)
target_link_libraries(osm-world-renderer OsmRenderer)
target_link_libraries(osm-world-renderer osmscout)
target_link_libraries(osm-world-renderer osmscout_map)
target_link_libraries(osm-world-renderer osmscout_map_svg)
target_link_libraries(osm-world-renderer lunasvg)
