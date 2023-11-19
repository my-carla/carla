# boost
set(boost_src ${CMAKE_BINARY_DIR}/boost-carla)
set(boost_install_dir ${install_dir}/boost-carla)


file(COPY boost-carla DESTINATION ${CMAKE_BINARY_DIR})

set(BOOST_TOOLSET "clang-10.0")
set(BOOST_CFLAGS "-fPIC -std=c++14 -DBOOST_ERROR_CODE_HEADER_ONLY")

find_package(Python COMPONENTS Interpreter Development)

execute_process(COMMAND ${Python_EXECUTABLE} -c "import sys; print(sys.prefix)"
                OUTPUT_VARIABLE python_root
                OUTPUT_STRIP_TRAILING_WHITESPACE )

execute_process(COMMAND ${Python_EXECUTABLE} -c "import sys;x='{v[0]}.{v[1]}'.format(v=list(sys.version_info[:2]));sys.stdout.write(x)"
                OUTPUT_VARIABLE python_ver
                OUTPUT_STRIP_TRAILING_WHITESPACE )


add_custom_command(
    OUTPUT ${boost_src}/b2
    WORKING_DIRECTORY ${boost_src}
    COMMAND CC=$ENV{CC};CXX=$ENV{CXX};PATH=$ENV{PATH};
        ${boost_src}/bootstrap.sh
        --with-toolset=clang
        --prefix=${boost_install_dir}
        --with-libraries=python,filesystem,system,program_options
        --with-python=${Python_EXECUTABLE}
        --with-python-root=${python_root}
)

add_custom_target(
    boost_stage_release
    DEPENDS ${boost_src}/b2
    WORKING_DIRECTORY ${boost_src}
    COMMAND CC=$ENV{CC};CXX=$ENV{CXX};PATH=$ENV{PATH};
        ${boost_src}/b2 toolset=${BOOST_TOOLSET} cxxflags=${BOOST_CFLAGS}
        --prefix=${boost_install_dir}
        -j ${CARLA_BUILD_CONCURRENCY}
        stage
        release
)


add_custom_target(
    boost_build_install
    DEPENDS ${boost_src}/b2
    WORKING_DIRECTORY ${boost_src}
    COMMAND CC=$ENV{CC};CXX=$ENV{CXX};PATH=$ENV{PATH};
        ${boost_src}/b2
        toolset=${BOOST_TOOLSET} cxxflags=${BOOST_CFLAGS}
        --prefix=${boost_install_dir}
        -j ${CARLA_BUILD_CONCURRENCY}
        install
)

if(${TRAVIS})
    write_file(
        $ENV{HOME}/user-config.jam
        "using python : ${python_ver} : ${python_root}/bin/python${PY_VERSION} ;")
else()
    write_file(
        ${boost_src}/project-config.jam
        "using python : ${python_ver} : ${python_root}/bin/python${PY_VERSION} ;")
endif(${TRAVIS})


add_custom_target(
    install_boost
    DEPENDS boost_stage_release boost_build_install
)


# rpclib
set(OLD_CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS})
set(OLD_CMAKE_INSTALL_PREFIX ${CMAKE_INSTALL_PREFIX})
set(rpclib_libcxx_install_dir ${install_dir}/rpclib-libcxx)
# set(rpclib_libstdcxx_install_dir ${install_dir}/rpclib-libstdcxx)
# file(COPY rpclib DESTINATION ${CMAKE_CURRENT_LIST_DIR}/tmp/rpclib-libcxx)
# file(COPY rpclib DESTINATION ${CMAKE_CURRENT_LIST_DIR}/tmp/rpclib-libstdcxx)

# libc++
set(CMAKE_CXX_FLAGS "-fPIC -std=c++14 -stdlib=libc++ -I${LLVM_INCLUDE} -Wl,-L${LLVM_LIBPATH} -DBOOST_NO_EXCEPTIONS -DASIO_NO_EXCEPTIONS ${UNREAL_HOSTED_CFLAGS}")
set(CMAKE_INSTALL_PREFIX ${rpclib_libcxx_install_dir})
add_subdirectory(rpclib)

# # libstdc++
# set(CMAKE_CXX_FLAGS "-fPIC -std=c++14")
# set(CMAKE_INSTALL_PREFIX ${rpclib_libstdcxx_install_dir})
# add_subdirectory(tmp/rpclib-libstdcxx/rpclib)

# recover cmake var
set(CMAKE_CXX_FLAGS ${OLD_CMAKE_CXX_FLAGS})
set(CMAKE_INSTALL_PREFIX ${OLD_CMAKE_INSTALL_PREFIX})


add_custom_target(
    install_rpclib_libcxx
    COMMAND make install -j ${CARLA_BUILD_CONCURRENCY}
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/ThirdParty/rpclib
)

# add_custom_target(
#     install_rpclib_libstdcxx
#     COMMAND make install
#     WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/ThirdParty/tmp/rpclib-libstdcxx/rpclib
# )

# all

# add_custom_target(
#     clean_tmp
#     COMMAND rm -rf ./tmp
#     WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}
# )


# gtest
set(OLD_CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS})
set(OLD_CMAKE_INSTALL_PREFIX ${CMAKE_INSTALL_PREFIX})
set(gtest_install_dir ${install_dir}/gtest)

set(CMAKE_CXX_FLAGS "-std=c++14 -stdlib=libc++ -I${LLVM_INCLUDE} -Wl,-L${LLVM_LIBPATH} -DBOOST_NO_EXCEPTIONS -fno-exceptions ${UNREAL_HOSTED_CFLAGS}")
set(CMAKE_INSTALL_PREFIX "${gtest_install_dir}")
add_subdirectory(googletest)

add_custom_target(
    install_gtest
    COMMAND make install -j ${CARLA_BUILD_CONCURRENCY}
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/ThirdParty/googletest
)

# recover cmake var
set(CMAKE_CXX_FLAGS ${OLD_CMAKE_CXX_FLAGS})
set(CMAKE_INSTALL_PREFIX ${OLD_CMAKE_INSTALL_PREFIX})


# Recast&Detour
set(OLD_CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS})
set(OLD_CMAKE_INSTALL_PREFIX ${CMAKE_INSTALL_PREFIX})
set(recast_install_dir ${install_dir}/recast)

set(CMAKE_CXX_FLAGS "-std=c++14 -fPIC")
set(CMAKE_INSTALL_PREFIX ${recast_install_dir})
set(RECASTNAVIGATION_DEMO False)
set(RECASTNAVIGATION_TEST False)
add_subdirectory(recastnavigation)

add_custom_target(
    install_recast
    COMMAND make install -j ${CARLA_BUILD_CONCURRENCY} &&
        cp ${recast_install_dir}/bin/RecastBuilder ${RECAST_INSTALL_DIR}
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/ThirdParty/recastnavigation
)

# recover cmake var
set(CMAKE_CXX_FLAGS ${OLD_CMAKE_CXX_FLAGS})
set(CMAKE_INSTALL_PREFIX ${OLD_CMAKE_INSTALL_PREFIX})


# libpng
set(libpng_install_dir ${install_dir}/libpng)
file(COPY libpng-carla DESTINATION ${CMAKE_BINARY_DIR})

add_custom_target(
    build_libpng
    COMMAND CC=$ENV{CC};CXX=$ENV{CXX};PATH=$ENV{PATH};
        ./configure --prefix=${libpng_install_dir}
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/libpng-carla
)

add_custom_target(
    install_libpng
    DEPENDS build_libpng
    COMMAND CC=$ENV{CC};CXX=$ENV{CXX};PATH=$ENV{PATH};
        make install -j ${CARLA_BUILD_CONCURRENCY}
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/libpng-carla
)


# libxerces
file(COPY xerces-carla DESTINATION ${CMAKE_BINARY_DIR})
set(xerces_src ${CMAKE_BINARY_DIR}/xerces-carla)
set(xerces_install_dir ${install_dir}/xerces)
set(OLD_CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS})
set(OLD_CMAKE_INSTALL_PREFIX ${CMAKE_INSTALL_PREFIX})

set(CMAKE_CXX_FLAGS "-std=c++14 -stdlib=libc++ -fPIC -w -I${LLVM_INCLUDE} -L${LLVM_LIBPATH}")
set(CMAKE_INSTALL_PREFIX ${xerces_install_dir})
set(CMAKE_BUILD_TYPE Release)
set(BUILD_SHARED_LIBS OFF)
set(transcoder gnuiconv)
set(network OFF)

add_custom_target(
    build_xerces
    COMMAND CC=$ENV{CC};CXX=$ENV{CXX};PATH=$ENV{PATH};
        ${CMAKE_COMMAND}
        -DCMAKE_CXX_FLAGS=${CMAKE_CXX_FLAGS}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DBUILD_SHARED_LIBS=${BUILD_SHARED_LIBS}
        -Dtranscoder=${transcoder}
        -Dnetwork=${network}
        .
    WORKING_DIRECTORY ${xerces_src}
)


add_custom_target(
    install_xerces
    DEPENDS build_xerces
    COMMAND CC=$ENV{CC};CXX=$ENV{CXX};PATH=$ENV{PATH};
        make install -j ${CARLA_BUILD_CONCURRENCY}
    WORKING_DIRECTORY ${xerces_src}
)

# recover cmake var
set(CMAKE_CXX_FLAGS ${OLD_CMAKE_CXX_FLAGS})
set(CMAKE_INSTALL_PREFIX ${OLD_CMAKE_INSTALL_PREFIX})


# eigen
set(eigen_src ${CMAKE_CURRENT_LIST_DIR}/eigen-carla)
set(eigen_install_dir ${install_dir}/eigen)
set(eigen_install_include ${eigen_install_dir}/include)

add_custom_target(
    install_eigen
    COMMAND mkdir -p ${eigen_install_include}/unsupported/Eigen
    COMMAND cp -R ${eigen_src}/Eigen ${eigen_install_include}
    COMMAND cp -R ${eigen_src}/unsupported/Eigen ${eigen_install_include}/unsupported
    WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}
)


# Chrono
set(OLD_CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS})
set(OLD_CMAKE_INSTALL_PREFIX ${CMAKE_INSTALL_PREFIX})

# install eigen for chrono
set(eigen4chrono_src ${CMAKE_CURRENT_LIST_DIR}/eigen-for-chrono)
set(eigen4chrono_install_dir ${install_dir}/eigen-for-chrono)
set(eigen4chrono_install_include ${eigen4chrono_install_dir}/include)

add_custom_target(
    install_eigen4chrono
    COMMAND mkdir -p ${eigen4chrono_install_include}/unsupported/Eigen
    COMMAND cp -R ${eigen4chrono_src}/Eigen ${eigen4chrono_install_include}
    COMMAND cp -R ${eigen4chrono_src}/unsupported/Eigen ${eigen4chrono_install_include}/unsupported
    WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}
)

# build and install chrono
file(COPY chrono DESTINATION ${CMAKE_BINARY_DIR})
set(chrono_src ${CMAKE_BINARY_DIR}/chrono)
set(chrono_build_dir ${chrono_src}/build)
set(chrono_install_dir ${install_dir}/chrono)


set(CMAKE_CXX_FLAGS "-fPIC -std=c++14 -stdlib=libc++ -I${LLVM_INCLUDE} -L${LLVM_LIBPATH} -Wno-unused-command-line-argument ${UNREAL_HOSTED_CFLAGS}")
set(EIGEN3_INCLUDE_DIR ${eigen4chrono_install_include})
set(CMAKE_INSTALL_PREFIX ${chrono_install_dir})
set(CMAKE_BUILD_TYPE Release)
set(ENABLE_MODULE_VEHICLE ON)

add_custom_command(
    OUTPUT ${chrono_build_dir}
    COMMAND mkdir -p ${chrono_build_dir}
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
)

add_custom_target(
    build_chrono
    DEPENDS install_eigen4chrono ${chrono_build_dir}
    COMMAND CC=$ENV{CC};CXX=$ENV{CXX};PATH=$ENV{PATH};
        ${CMAKE_COMMAND} ..
        -DCMAKE_CXX_FLAGS=${CMAKE_CXX_FLAGS}
        -DEIGEN3_INCLUDE_DIR=${EIGEN3_INCLUDE_DIR}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DENABLE_MODULE_VEHICLE=${ENABLE_MODULE_VEHICLE}
    WORKING_DIRECTORY ${chrono_build_dir}
)

add_custom_target(
    install_chrono
    DEPENDS build_chrono
    COMMAND CC=$ENV{CC};CXX=$ENV{CXX};PATH=$ENV{PATH};
        make install
    WORKING_DIRECTORY ${chrono_build_dir}
)


# recover cmake var
set(CMAKE_CXX_FLAGS ${OLD_CMAKE_CXX_FLAGS})
set(CMAKE_INSTALL_PREFIX ${OLD_CMAKE_INSTALL_PREFIX})


# Sqlite3
file(COPY sqlite-carla DESTINATION ${CMAKE_BINARY_DIR})
set(sqlite_src ${CMAKE_BINARY_DIR}/sqlite-carla)
set(sqlite_install_dir ${install_dir}/sqlite)


add_custom_target(
    build_sqlite
    COMMAND CC=$ENV{CC};CXX=$ENV{CXX};PATH=$ENV{PATH};CFLAGS="-fPIC -w";
        ./configure --prefix=${sqlite_install_dir}
    WORKING_DIRECTORY ${sqlite_src}
)

add_custom_target(
    install_sqlite
    DEPENDS build_sqlite
    COMMAND CC=$ENV{CC};CXX=$ENV{CXX};PATH=$ENV{PATH};CFLAGS="-fPIC -w";
        make && make install
    WORKING_DIRECTORY ${sqlite_src}
)


# proj
file(COPY proj-carla DESTINATION ${CMAKE_BINARY_DIR})
set(OLD_CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS})
set(OLD_CMAKE_INSTALL_PREFIX ${CMAKE_INSTALL_PREFIX})
set(proj_install_dir ${install_dir}/proj)
set(proj_src ${CMAKE_BINARY_DIR}/proj-carla)


set(CMAKE_CXX_FLAGS "-std=c++14 -fPIC -stdlib=libc++ -I${LLVM_INCLUDE} -Wl,-L${LLVM_LIBPATH}")
set(SQLITE3_INCLUDE_DIR ${sqlite_install_dir}/include)
set(SQLITE3_LIBRARY ${sqlite_install_dir}/lib/libsqlite3.a)
set(EXE_SQLITE3 ${sqlite_install_dir}/bin/sqlite3)
set(ENABLE_TIFF OFF)
set(ENABLE_CURL OFF)
set(BUILD_SHARED_LIBS OFF)
set(BUILD_PROJSYNC OFF)
set(CMAKE_BUILD_TYPE Release)
set(BUILD_PROJINFO OFF)
set(BUILD_CCT OFF)
set(BUILD_CS2CS OFF)
set(BUILD_GEOD OFF)
set(BUILD_GIE OFF)
set(BUILD_PROJ OFF)
set(BUILD_TESTING OFF)
set(CMAKE_INSTALL_PREFIX ${proj_install_dir})

add_custom_target(
    build_proj
    DEPENDS install_sqlite
    COMMAND CC=$ENV{CC};CXX=$ENV{CXX};PATH=$ENV{PATH};
        ${CMAKE_COMMAND}
        -DCMAKE_CXX_FLAGS=${CMAKE_CXX_FLAGS}
        -DSQLITE3_INCLUDE_DIR=${SQLITE3_INCLUDE_DIR}
        -DSQLITE3_LIBRARY=${SQLITE3_LIBRARY}
        -DEXE_SQLITE3=${EXE_SQLITE3}
        -DENABLE_TIFF=${ENABLE_TIFF}
        -DENABLE_CURL=${ENABLE_CURL}
        -DBUILD_SHARED_LIBS=${BUILD_SHARED_LIBS}
        -DBUILD_PROJSYNC=${BUILD_PROJSYNC}
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DBUILD_PROJINFO=${BUILD_PROJINFO}
        -DBUILD_CCT=${BUILD_CCT}
        -DBUILD_CS2CS=${BUILD_CS2CS}
        -DBUILD_GEOD=${BUILD_GEOD}
        -DBUILD_GIE=${BUILD_GIE}
        -DBUILD_PROJ=${BUILD_PROJ}
        -DBUILD_TESTING=${BUILD_TESTING}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        .
    WORKING_DIRECTORY ${proj_src}
)

add_custom_target(
    install_proj
    DEPENDS build_proj
    COMMAND CC=$ENV{CC};CXX=$ENV{CXX};PATH=$ENV{PATH};
        make install
    WORKING_DIRECTORY ${proj_src}
)


# patchelf
file(COPY patchelf DESTINATION ${CMAKE_BINARY_DIR})
set(patchelf_src ${CMAKE_BINARY_DIR}/patchelf)
set(patchelf_install_dir ${install_dir}/patchelf)

add_custom_target(
    build_patchelf
    COMMAND CC=$ENV{CC};CXX=$ENV{CXX};PATH=$ENV{PATH};
        ./bootstrap.sh
        ./configure --prefix=${patchelf_install_dir}
    WORKING_DIRECTORY ${patchelf_src}
)

add_custom_target(
    install_patchelf
    DEPENDS build_patchelf
    COMMAND CC=$ENV{CC};CXX=$ENV{CXX};PATH=$ENV{PATH};
        make && make install
    WORKING_DIRECTORY ${patchelf_src}
)


# # pytorch

# include(ExternalProject)
# ExternalProject_Add(
#     download_pytorch
#     PREFIX extract_pytorch
#     URL https://download.pytorch.org/libtorch/cu113/libtorch-shared-with-deps-1.11.0%2Bcu113.zip
#     DOWNLOAD_DIR ${CMAKE_BINARY_DIR}
#     DOWNLOAD_NAME pytorch.zip
#     CONFIGURE_COMMAND ""
#     BUILD_COMMAND ""
#     INSTALL_COMMAND ""
#     DOWNLOAD_NO_EXTRACT ON
# )

# add_custom_command(
#     OUTPUT ${CMAKE_BINARY_DIR}/libtorch
#     DEPENDS download_pytorch
#     COMMAND unzip pytorch.zip
#     WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
# )

# OSM2ODR
file(COPY sumo DESTINATION ${CMAKE_BINARY_DIR}/server)
file(COPY sumo DESTINATION ${CMAKE_BINARY_DIR}/client)
set(osm2odr_client_src ${CMAKE_BINARY_DIR}/client/sumo)
set(osm2odr_server_src ${CMAKE_BINARY_DIR}/server/sumo)

# for client
set(client_G "Eclipse CDT4 - Unix Makefiles")
set(client_CMAKE_CXX_FLAGS "-stdlib=libstdc++")
set(client_CMAKE_INSTALL_PREFIX ${LIBCARLA_INSTALL_CLIENT_FOLDER})
set(client_PROJ_INCLUDE_DIR ${proj_install_dir}/include)
set(client_PROJ_LIBRARY ${proj_install_dir}/lib/libproj.a)
set(client_XercesC_INCLUDE_DIR ${proj_install_dir}/include)
set(client_XercesC_LIBRARY ${proj_install_dir}/lib/libxerces-c.a)

add_custom_target(
    build_osm2odr_client
    DEPENDS install_proj
    COMMAND CC=$ENV{CC};CXX=$ENV{CXX};PATH=$ENV{PATH};
        ${CMAKE_COMMAND}
        -G ${client_G}
        -DCMAKE_CXX_FLAGS=${client_CMAKE_CXX_FLAGS}
        -DCMAKE_INSTALL_PREFIX=${client_CMAKE_INSTALL_PREFIX}
        -DPROJ_INCLUDE_DIR=${client_PROJ_INCLUDE_DIR}
        -DPROJ_LIBRARY=${client_PROJ_LIBRARY}
        -DXercesC_INCLUDE_DIR=${client_XercesC_INCLUDE_DIR}
        -DXercesC_LIBRARY=${client_XercesC_LIBRARY}
        .
    WORKING_DIRECTORY ${osm2odr_client_src}
)

add_custom_target(
    install_osm2odr_client
    DEPENDS build_osm2odr_client
    COMMAND CC=$ENV{CC};CXX=$ENV{CXX};PATH=$ENV{PATH};
        make install
    WORKING_DIRECTORY ${osm2odr_client_src}
)


# for server
set(server_G "Eclipse CDT4 - Unix Makefiles")
set(server_CMAKE_CXX_FLAGS "-fPIC -std=c++14 -stdlib=libc++ -I${LLVM_INCLUDE} -L${LLVM_LIBPATH}")
set(server_CMAKE_INSTALL_PREFIX ${LIBCARLA_INSTALL_SERVER_FOLDER})
set(server_PROJ_INCLUDE_DIR ${proj_install_dir}/include)
set(server_PROJ_LIBRARY ${proj_install_dir}/lib/libproj.a)
set(server_XercesC_INCLUDE_DIR ${proj_install_dir}/include)
set(server_XercesC_LIBRARY ${proj_install_dir}/lib/libxerces-c.a)

add_custom_target(
    build_osm2odr_server
    DEPENDS install_proj
    COMMAND CC=$ENV{CC};CXX=$ENV{CXX};PATH=$ENV{PATH};
        ${CMAKE_COMMAND}
        -G ${server_G}
        -DCMAKE_CXX_FLAGS=${server_CMAKE_CXX_FLAGS}
        -DCMAKE_INSTALL_PREFIX=${server_CMAKE_INSTALL_PREFIX}
        -DPROJ_INCLUDE_DIR=${server_PROJ_INCLUDE_DIR}
        -DPROJ_LIBRARY=${server_PROJ_LIBRARY}
        -DXercesC_INCLUDE_DIR=${server_XercesC_INCLUDE_DIR}
        -DXercesC_LIBRARY=${server_XercesC_LIBRARY}
        .
    WORKING_DIRECTORY ${osm2odr_server_src}
)

add_custom_target(
    install_osm2odr_server
    DEPENDS build_osm2odr_server
    COMMAND CC=$ENV{CC};CXX=$ENV{CXX};PATH=$ENV{PATH};
        make install
    WORKING_DIRECTORY ${osm2odr_server_src}
)


add_custom_target(
    install_osm2odr
    DEPENDS install_osm2odr_client install_osm2odr_client
)


# all

add_custom_target(
    third_party ALL
    DEPENDS install_boost install_rpclib_libcxx
            install_gtest install_recast install_libpng
            install_xerces install_eigen install_chrono
            install_patchelf install_osm2odr
)
