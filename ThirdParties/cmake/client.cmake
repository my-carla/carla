# rpclib
set(OLD_CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS})
set(OLD_CMAKE_INSTALL_PREFIX ${CMAKE_INSTALL_PREFIX})
set(RPCLIB_CLIENT_BUILD_DIR ${CLIENT_BUILD_DIR}/rpclib)
file(MAKE_DIRECTORY ${RPCLIB_CLIENT_BUILD_DIR})

set(CLIENT_CMAKE_CXX_FLAGS "-fPIC -std=c++14")


# for client
add_custom_target(
    build_rpclib_client
    COMMAND CC=$ENV{CC};CXX=$ENV{CXX};PATH=$ENV{PATH};
        ${CMAKE_COMMAND}
        -DCMAKE_CXX_FLAGS=${CLIENT_CMAKE_CXX_FLAGS}
        -DCMAKE_INSTALL_PREFIX=${RPCLIB_CLIENT_INSTALL_DIR}
        ${RPCLIB_SRC}
    WORKING_DIRECTORY ${RPCLIB_CLIENT_BUILD_DIR}
)

add_custom_target(
    install_rpclib_client
    DEPENDS build_rpclib_client
    COMMAND CC=$ENV{CC};CXX=$ENV{CXX};PATH=$ENV{PATH};
        make install -j ${CARLA_BUILD_CONCURRENCY}
    WORKING_DIRECTORY ${RPCLIB_CLIENT_BUILD_DIR}
)

# recover cmake var
set(CMAKE_CXX_FLAGS ${OLD_CMAKE_CXX_FLAGS})
set(CMAKE_INSTALL_PREFIX ${OLD_CMAKE_INSTALL_PREFIX})


# gtest
set(OLD_CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS})
set(OLD_CMAKE_INSTALL_PREFIX ${CMAKE_INSTALL_PREFIX})
set(GTEST_CLIENT_BUILD_DIR ${CLIENT_BUILD_DIR}/googletest)
file(MAKE_DIRECTORY ${GTEST_CLIENT_BUILD_DIR})

set(CMAKE_CXX_FLAGS "-std=c++14")

add_custom_target(
    build_gtest_client
    COMMAND CC=$ENV{CC};CXX=$ENV{CXX};PATH=$ENV{PATH};
        ${CMAKE_COMMAND}
        -DCMAKE_CXX_FLAGS=${CMAKE_CXX_FLAGS}
        -DCMAKE_INSTALL_PREFIX=${GTEST_CLIENT_INSTALL_DIR}
        ${GTEST_SRC}
    WORKING_DIRECTORY ${GTEST_CLIENT_BUILD_DIR}
)


add_custom_target(
    install_gtest_client
    DEPENDS build_gtest_client
    COMMAND CC=$ENV{CC};CXX=$ENV{CXX};PATH=$ENV{PATH};
        make install -j ${CARLA_BUILD_CONCURRENCY}
    WORKING_DIRECTORY ${GTEST_CLIENT_BUILD_DIR}
)

# recover cmake var
set(CMAKE_CXX_FLAGS ${OLD_CMAKE_CXX_FLAGS})
set(CMAKE_INSTALL_PREFIX ${OLD_CMAKE_INSTALL_PREFIX})


# Recast&Detour
set(OLD_CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS})
set(OLD_CMAKE_INSTALL_PREFIX ${CMAKE_INSTALL_PREFIX})
set(RECAST_CLIENT_BUILD_DIR ${CLIENT_BUILD_DIR}/recast)
file(MAKE_DIRECTORY ${RECAST_CLIENT_BUILD_DIR})

set(CMAKE_CXX_FLAGS "-std=c++14 -fPIC")
set(RECASTNAVIGATION_DEMO False)
set(RECASTNAVIGATION_TEST False)

add_custom_target(
    build_recast_client
    COMMAND CC=$ENV{CC};CXX=$ENV{CXX};PATH=$ENV{PATH};
        ${CMAKE_COMMAND}
        -DCMAKE_CXX_FLAGS=${CMAKE_CXX_FLAGS}
        -DCMAKE_INSTALL_PREFIX=${RECAST_CLIENT_INSTALL_DIR}
        -DRECASTNAVIGATION_DEMO=${RECASTNAVIGATION_DEMO}
        -DRECASTNAVIGATION_TEST=${RECASTNAVIGATION_TEST}
        ${RECAST_SRC}
    WORKING_DIRECTORY ${RECAST_CLIENT_BUILD_DIR}
)

add_custom_target(
    install_recast_client
    DEPENDS build_recast_client
    COMMAND CC=$ENV{CC};CXX=$ENV{CXX};PATH=$ENV{PATH};
        make install -j ${CARLA_BUILD_CONCURRENCY}
    # for docker?
    COMMAND cp ${RECAST_CLIENT_INSTALL_DIR}/bin/RecastBuilder ${RECAST_INSTALL_DIR}
    WORKING_DIRECTORY ${RECAST_CLIENT_BUILD_DIR}
)

# recover cmake var
set(CMAKE_CXX_FLAGS ${OLD_CMAKE_CXX_FLAGS})
set(CMAKE_INSTALL_PREFIX ${OLD_CMAKE_INSTALL_PREFIX})


# libpng
file(COPY ${LIBPNG_SRC} DESTINATION ${CLIENT_BUILD_DIR})
set(LIBPNG_SRC_BAK ${CLIENT_BUILD_DIR}/libpng-carla)

add_custom_target(
    build_libpng_client
    COMMAND CC=$ENV{CC};CXX=$ENV{CXX};PATH=$ENV{PATH};
        ./configure --prefix=${LIBPNG_CLIENT_INSTALL_DIR}
    WORKING_DIRECTORY ${LIBPNG_SRC_BAK}
)

add_custom_target(
    install_libpng_client
    DEPENDS build_libpng_client
    COMMAND CC=$ENV{CC};CXX=$ENV{CXX};PATH=$ENV{PATH};
        make install -j ${CARLA_BUILD_CONCURRENCY}
    WORKING_DIRECTORY ${LIBPNG_SRC_BAK}
)


# libxerces
set(OLD_CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS})
set(OLD_CMAKE_INSTALL_PREFIX ${CMAKE_INSTALL_PREFIX})
set(XERCES_CLIENT_BUILD_DIR ${CLIENT_BUILD_DIR}/xerces)
file(MAKE_DIRECTORY ${XERCES_CLIENT_BUILD_DIR})


set(CMAKE_CXX_FLAGS "-std=c++14 -fPIC -w")
set(CMAKE_BUILD_TYPE Release)
set(BUILD_SHARED_LIBS OFF)
set(transcoder gnuiconv)
set(network OFF)

add_custom_target(
    build_xerces_client
    COMMAND CC=$ENV{CC};CXX=$ENV{CXX};PATH=$ENV{PATH};
        ${CMAKE_COMMAND}
        -DCMAKE_CXX_FLAGS=${CMAKE_CXX_FLAGS}
        -DCMAKE_INSTALL_PREFIX=${XERCES_CLIENT_INSTALL_DIR}
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DBUILD_SHARED_LIBS=${BUILD_SHARED_LIBS}
        -Dtranscoder=${transcoder}
        -Dnetwork=${network}
        ${XERCES_SRC}
    WORKING_DIRECTORY ${XERCES_CLIENT_BUILD_DIR}
)


add_custom_target(
    install_xerces_client
    DEPENDS build_xerces_client
    COMMAND CC=$ENV{CC};CXX=$ENV{CXX};PATH=$ENV{PATH};
        make install -j ${CARLA_BUILD_CONCURRENCY}
    WORKING_DIRECTORY ${XERCES_CLIENT_BUILD_DIR}
)

# recover cmake var
set(CMAKE_CXX_FLAGS ${OLD_CMAKE_CXX_FLAGS})
set(CMAKE_INSTALL_PREFIX ${OLD_CMAKE_INSTALL_PREFIX})


# eigen
set(EIGEN_CLIENT_INSTALL_INCLUDE_DIR ${EIGEN_CLIENT_INSTALL_DIR}/include)

add_custom_target(
    install_eigen_client
    COMMAND mkdir -p ${EIGEN_CLIENT_INSTALL_INCLUDE_DIR}/unsupported/Eigen
    COMMAND cp -R ${EIGEN_SRC}/Eigen ${EIGEN_CLIENT_INSTALL_INCLUDE_DIR}
    COMMAND cp -R ${EIGEN_SRC}/unsupported/Eigen ${EIGEN_CLIENT_INSTALL_INCLUDE_DIR}/unsupported
    WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}
)


# Sqlite3
file(COPY ${SQLITE_SRC} DESTINATION ${CLIENT_BUILD_DIR})
set(SQLITE_SRC_BAK ${CLIENT_BUILD_DIR}/sqlite-carla)


add_custom_target(
    build_sqlite_client
    COMMAND CC=$ENV{CC};CXX=$ENV{CXX};PATH=$ENV{PATH};CFLAGS="-fPIC";
        ./configure --prefix=${SQLITE_CLIENT_INSTALL_DIR} &&
        make -j ${CARLA_BUILD_CONCURRENCY}
    WORKING_DIRECTORY ${SQLITE_SRC_BAK}
)

add_custom_target(
    install_sqlite_client
    DEPENDS build_sqlite_client
    COMMAND CC=$ENV{CC};CXX=$ENV{CXX};PATH=$ENV{PATH};CFLAGS="-fPIC";
        make install
    WORKING_DIRECTORY ${SQLITE_SRC_BAK}
)


# proj
set(OLD_CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS})
set(OLD_CMAKE_INSTALL_PREFIX ${CMAKE_INSTALL_PREFIX})
set(PROJ_CLIENT_BUILD_DIR ${CLIENT_BUILD_DIR}/proj)
file(MAKE_DIRECTORY ${PROJ_CLIENT_BUILD_DIR})

set(PROJ_CMAKE_CXX_FLAGS "-std=c++14 -fPIC")
set(SQLITE3_CLIENT_INCLUDE_DIR ${SQLITE_CLIENT_INSTALL_DIR}/include)
set(SQLITE3_CLIENT_LIBRARY ${SQLITE_CLIENT_INSTALL_DIR}/lib/libsqlite3.a)
set(SQLITE3_CLIENT_EXE ${SQLITE_CLIENT_INSTALL_DIR}/bin/sqlite3)
set(PROJ_CLIENT_ENABLE_TIFF OFF)
set(PROJ_CLIENT_ENABLE_CURL OFF)
set(PROJ_CLIENT_BUILD_SHARED_LIBS OFF)
set(PROJ_CLIENT_BUILD_PROJSYNC OFF)
set(PROJ_CLIENT_CMAKE_BUILD_TYPE Release)
set(PROJ_CLIENT_BUILD_PROJINFO OFF)
set(PROJ_CLIENT_BUILD_CCT OFF)
set(PROJ_CLIENT_BUILD_CS2CS OFF)
set(PROJ_CLIENT_BUILD_GEOD OFF)
set(PROJ_CLIENT_BUILD_GIE OFF)
set(PROJ_CLIENT_BUILD_PROJ OFF)
set(PROJ_CLIENT_BUILD_TESTING OFF)

add_custom_target(
    build_proj_client
    DEPENDS install_sqlite_client
    COMMAND CC=$ENV{CC};CXX=$ENV{CXX};PATH=$ENV{PATH};
        ${CMAKE_COMMAND}
        -DCMAKE_POSITION_INDEPENDENT_CODE=ON
        -DCMAKE_CXX_FLAGS=${PROJ_CMAKE_CXX_FLAGS}
        -DSQLITE3_INCLUDE_DIR=${SQLITE3_CLIENT_INCLUDE_DIR}
        -DSQLITE3_LIBRARY=${SQLITE3_CLIENT_LIBRARY}
        -DEXE_SQLITE3=${SQLITE3_CLIENT_EXE}
        -DENABLE_TIFF=${PROJ_CLIENT_ENABLE_TIFF}
        -DENABLE_CURL=${PROJ_CLIENT_ENABLE_CURL}
        -DBUILD_SHARED_LIBS=${PROJ_CLIENT_BUILD_SHARED_LIBS}
        -DBUILD_PROJSYNC=${PROJ_CLIENT_BUILD_PROJSYNC}
        -DCMAKE_BUILD_TYPE=${PROJ_CLIENT_CMAKE_BUILD_TYPE}
        -DBUILD_PROJINFO=${PROJ_CLIENT_BUILD_PROJINFO}
        -DBUILD_CCT=${PROJ_CLIENT_BUILD_CCT}
        -DBUILD_CS2CS=${PROJ_CLIENT_BUILD_CS2CS}
        -DBUILD_GEOD=${PROJ_CLIENT_BUILD_GEOD}
        -DBUILD_GIE=${PROJ_CLIENT_BUILD_GIE}
        -DBUILD_PROJ=${PROJ_CLIENT_BUILD_PROJ}
        -DBUILD_TESTING=${PROJ_CLIENT_BUILD_TESTING}
        -DCMAKE_INSTALL_PREFIX=${PROJ_CLIENT_INSTALL_DIR}
        ${PROJ_SRC}
    WORKING_DIRECTORY ${PROJ_CLIENT_BUILD_DIR}
)

add_custom_target(
    install_proj_client
    DEPENDS build_proj_client
    COMMAND CC=$ENV{CC};CXX=$ENV{CXX};PATH=$ENV{PATH};
        make install -j ${CARLA_BUILD_CONCURRENCY}
    WORKING_DIRECTORY ${PROJ_CLIENT_BUILD_DIR}
)


# patchelf
file(COPY ${PATCHELF_SRC} DESTINATION ${CLIENT_BUILD_DIR})
set(PATCHELF_SRC_BAK ${CLIENT_BUILD_DIR}/patchelf)

add_custom_target(
    build_patchelf_client
    COMMAND CC=$ENV{CC};CXX=$ENV{CXX};PATH=$ENV{PATH};
        ./bootstrap.sh &&
        ./configure --prefix=${PATCHELF_CLIENT_INSTALL_DIR}
    WORKING_DIRECTORY ${PATCHELF_SRC_BAK}
)

add_custom_target(
    install_patchelf_client
    DEPENDS build_patchelf_client
    COMMAND CC=$ENV{CC};CXX=$ENV{CXX};PATH=$ENV{PATH};
        make -j ${CARLA_BUILD_CONCURRENCY} && make install
    WORKING_DIRECTORY ${PATCHELF_SRC_BAK}
)


# OSM2ODR
set(OSM2ODR_CLIENT_BUILD_DIR ${CLIENT_BUILD_DIR}/sumo)
file(MAKE_DIRECTORY ${OSM2ODR_CLIENT_BUILD_DIR})

# for client
set(CLIENT_G "Eclipse CDT4 - Unix Makefiles")
set(CLIENT_CMAKE_CXX_FLAGS "-stdlib=libstdc++")
set(CLIENT_CMAKE_INSTALL_PREFIX ${LIBCARLA_CLIENT_INSTALL_DIR})
set(CLIENT_PROJ_INCLUDE_DIR ${PROJ_CLIENT_INSTALL_DIR}/include)
set(CLIENT_PROJ_LIBRARY ${PROJ_CLIENT_INSTALL_DIR}/lib/libproj.a)
set(CLIENT_XERCES_INCLUDE_DIR ${XERCES_CLIENT_INSTALL_DIR}/include)
set(CLIENT_XERCES_LIBRARY ${XERCES_CLIENT_INSTALL_DIR}/lib/libxerces-c.a)

add_custom_target(
    build_osm2odr_client
    DEPENDS install_proj_client install_xerces_client
    COMMAND CC=$ENV{CC};CXX=$ENV{CXX};PATH=$ENV{PATH};
        ${CMAKE_COMMAND}
        -G ${CLIENT_G}
        -DCMAKE_CXX_FLAGS=${CLIENT_CMAKE_CXX_FLAGS}
        -DCMAKE_INSTALL_PREFIX=${CLIENT_CMAKE_INSTALL_PREFIX}
        -DPROJ_INCLUDE_DIR=${CLIENT_PROJ_INCLUDE_DIR}
        -DPROJ_LIBRARY=${CLIENT_PROJ_LIBRARY}
        -DXercesC_INCLUDE_DIR=${CLIENT_XERCES_INCLUDE_DIR}
        -DXercesC_LIBRARY=${CLIENT_XERCES_LIBRARY}
        ${SUMO_SRC}
    WORKING_DIRECTORY ${OSM2ODR_CLIENT_BUILD_DIR}
)

add_custom_target(
    install_osm2odr_client
    DEPENDS build_osm2odr_client
    COMMAND CC=$ENV{CC};CXX=$ENV{CXX};PATH=$ENV{PATH};
        make install -j ${CARLA_BUILD_CONCURRENCY}
    WORKING_DIRECTORY ${OSM2ODR_CLIENT_BUILD_DIR}
)


# libosmscout
set(OSMSCOUT_CLIENT_BUILD_DIR ${CLIENT_BUILD_DIR}/osmscout)
file(MAKE_DIRECTORY ${OSMSCOUT_CLIENT_BUILD_DIR})

add_custom_target(
    build_libosmscout_client
    COMMAND ${CMAKE_COMMAND}
        -DCMAKE_INSTALL_PREFIX=${OSMSCOUT_CLIENT_INSTALL_DIR}
        ${OSMSCOUT_SRC}
    WORKING_DIRECTORY ${OSMSCOUT_CLIENT_BUILD_DIR}
)

add_custom_target(
    install_libosmscout_client
    DEPENDS build_libosmscout_client
    COMMAND make install -j ${CARLA_BUILD_CONCURRENCY}
    WORKING_DIRECTORY ${OSMSCOUT_CLIENT_BUILD_DIR}
)


# lunasvg
set(LUNASVG_CLIENT_BUILD_DIR ${CLIENT_BUILD_DIR}/lunasvg)
file(MAKE_DIRECTORY ${LUNASVG_CLIENT_BUILD_DIR})

add_custom_target(
    build_lunasvg_client
    COMMAND ${CMAKE_COMMAND}
        -DCMAKE_INSTALL_PREFIX=${LUNASVG_CLIENT_INSTALL_DIR}
        ${LUNASVG_SRC}
    WORKING_DIRECTORY ${LUNASVG_CLIENT_BUILD_DIR}
)

add_custom_target(
    install_lunasvg_client
    DEPENDS build_lunasvg_client
    COMMAND make install -j ${CARLA_BUILD_CONCURRENCY}
    WORKING_DIRECTORY ${LUNASVG_CLIENT_BUILD_DIR}
)

# all

add_custom_target(
    third_party_client
    DEPENDS install_rpclib_client
            install_gtest_client install_recast_client install_libpng_client
            install_eigen_client install_patchelf_client install_osm2odr_client
            install_libosmscout_client install_lunasvg_client
    COMMAND mkdir -p ${LIBCARLA_CLIENT_INSTALL_DIR}/include
    COMMAND mkdir -p ${LIBCARLA_CLIENT_INSTALL_DIR}/lib
    COMMAND mkdir -p ${LIBCARLA_CLIENT_INSTALL_DIR}/bin
    # bin
    COMMAND cp -R ${PATCHELF_CLIENT_INSTALL_DIR}/bin/*  ${LIBCARLA_CLIENT_INSTALL_DIR}/bin
    # include
    COMMAND cp -R ${RPCLIB_CLIENT_INSTALL_DIR}/include/*  ${LIBCARLA_CLIENT_INSTALL_DIR}/include
    COMMAND cp -R ${GTEST_CLIENT_INSTALL_DIR}/include/*  ${LIBCARLA_CLIENT_INSTALL_DIR}/include
    COMMAND cp -R ${SQLITE_CLIENT_INSTALL_DIR}/include/*  ${LIBCARLA_CLIENT_INSTALL_DIR}/include
    COMMAND cp -R ${EIGEN_CLIENT_INSTALL_DIR}/include/*  ${LIBCARLA_CLIENT_INSTALL_DIR}/include
    COMMAND cp -R ${PROJ_CLIENT_INSTALL_DIR}/include/*  ${LIBCARLA_CLIENT_INSTALL_DIR}/include
    COMMAND cp -R ${XERCES_CLIENT_INSTALL_DIR}/include/*  ${LIBCARLA_CLIENT_INSTALL_DIR}/include
    COMMAND cp -R ${LUNASVG_CLIENT_INSTALL_DIR}/include/*  ${LIBCARLA_CLIENT_INSTALL_DIR}/include
    COMMAND cp -R ${OSMSCOUT_CLIENT_INSTALL_DIR}/include/*  ${LIBCARLA_CLIENT_INSTALL_DIR}/include
    COMMAND cp -R ${LIBPNG_CLIENT_INSTALL_DIR}/include/*  ${LIBCARLA_CLIENT_INSTALL_DIR}/include
    COMMAND cp -R ${RECAST_CLIENT_INSTALL_DIR}/include/*  ${LIBCARLA_CLIENT_INSTALL_DIR}/include
    # lib
    COMMAND cp -R ${RPCLIB_CLIENT_INSTALL_DIR}/lib/*  ${LIBCARLA_CLIENT_INSTALL_DIR}/lib
    COMMAND cp -R ${GTEST_CLIENT_INSTALL_DIR}/lib/*  ${LIBCARLA_CLIENT_INSTALL_DIR}/lib
    COMMAND cp -R ${SQLITE_CLIENT_INSTALL_DIR}/lib/*  ${LIBCARLA_CLIENT_INSTALL_DIR}/lib
    COMMAND cp -R ${PROJ_CLIENT_INSTALL_DIR}/lib/*  ${LIBCARLA_CLIENT_INSTALL_DIR}/lib
    COMMAND cp -R ${XERCES_CLIENT_INSTALL_DIR}/lib/*  ${LIBCARLA_CLIENT_INSTALL_DIR}/lib
    COMMAND cp -R ${LUNASVG_CLIENT_INSTALL_DIR}/lib/*  ${LIBCARLA_CLIENT_INSTALL_DIR}/lib
    COMMAND cp -R ${OSMSCOUT_CLIENT_INSTALL_DIR}/lib/*  ${LIBCARLA_CLIENT_INSTALL_DIR}/lib
    COMMAND cp -R ${LIBPNG_CLIENT_INSTALL_DIR}/lib/*  ${LIBCARLA_CLIENT_INSTALL_DIR}/lib
    COMMAND cp -R ${RECAST_CLIENT_INSTALL_DIR}/lib/*  ${LIBCARLA_CLIENT_INSTALL_DIR}/lib
)
