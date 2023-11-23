set(BOOST_SRC ${CMAKE_CURRENT_LIST_DIR}/boost-carla)
set(CHRONO_SRC ${CMAKE_CURRENT_LIST_DIR}/chrono)
set(EIGEN_SRC ${CMAKE_CURRENT_LIST_DIR}/eigen-carla)
set(EIGEN_CHRONO_SRC ${CMAKE_CURRENT_LIST_DIR}/eigen-for-chrono)
set(GTEST_SRC ${CMAKE_CURRENT_LIST_DIR}/googletest)
set(LIBPNG_SRC ${CMAKE_CURRENT_LIST_DIR}/libpng-carla)
set(PATCHELF_SRC ${CMAKE_CURRENT_LIST_DIR}/patchelf)
set(PROJ_SRC ${CMAKE_CURRENT_LIST_DIR}/proj-carla)
set(RECAST_SRC ${CMAKE_CURRENT_LIST_DIR}/recastnavigation)
set(RPCLIB_SRC ${CMAKE_CURRENT_LIST_DIR}/rpclib)
set(SQLITE_SRC ${CMAKE_CURRENT_LIST_DIR}/sqlite-carla)
set(SUMO_SRC ${CMAKE_CURRENT_LIST_DIR}/sumo)
set(XERCES_SRC ${CMAKE_CURRENT_LIST_DIR}/xerces-carla)
set(LUNASVG_SRC ${CMAKE_CURRENT_LIST_DIR}/lunasvg)
set(OSMSCOUT_SRC ${CMAKE_CURRENT_LIST_DIR}/libosmscout)

include(cmake/common.cmake)
include(cmake/client.cmake)
include(cmake/server.cmake)


add_custom_target(
    install_third_party
    DEPENDS install_boost third_party_server third_party_client
)
