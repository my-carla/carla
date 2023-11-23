# boost
file(COPY ${BOOST_SRC} DESTINATION ${COMMON_BUILD_DIR})
set(BOOST_SRC_BAK ${COMMON_BUILD_DIR}/boost-carla)

set(BOOST_TOOLSET "clang-10.0")
set(BOOST_CFLAGS "-fPIC -std=c++14 -DBOOST_ERROR_CODE_HEADER_ONLY")

find_package(Python COMPONENTS Interpreter Development)

execute_process(COMMAND ${Python_EXECUTABLE}
    -c "import sys; print(sys.prefix)"
    OUTPUT_VARIABLE python_root
    OUTPUT_STRIP_TRAILING_WHITESPACE
)

execute_process(COMMAND ${Python_EXECUTABLE}
    -c "import sys;x='{v[0]}.{v[1]}'.format(v=list(sys.version_info[:2]));sys.stdout.write(x)"
    OUTPUT_VARIABLE python_ver
    OUTPUT_STRIP_TRAILING_WHITESPACE
)


add_custom_command(
    OUTPUT ${BOOST_SRC}/b2
    COMMAND CC=$ENV{CC};CXX=$ENV{CXX};PATH=$ENV{PATH};
        ./bootstrap.sh
        --with-toolset=clang
        --prefix=${BOOST_INSTALL_DIR}
        --with-libraries=python,filesystem,system,program_options
        --with-python=${Python_EXECUTABLE}
        --with-python-root=${python_root}
    WORKING_DIRECTORY ${BOOST_SRC_BAK}
)

add_custom_target(
    boost_stage_release
    DEPENDS ${BOOST_SRC}/b2
    COMMAND CC=$ENV{CC};CXX=$ENV{CXX};PATH=$ENV{PATH};
        ./b2
        toolset=${BOOST_TOOLSET}
        cxxflags=${BOOST_CFLAGS}
        --prefix=${BOOST_INSTALL_DIR}
        -j ${CARLA_BUILD_CONCURRENCY}
        stage
        release
    WORKING_DIRECTORY ${BOOST_SRC_BAK}
)

add_custom_target(
    boost_build_install
    DEPENDS ${BOOST_SRC}/b2
    COMMAND CC=$ENV{CC};CXX=$ENV{CXX};PATH=$ENV{PATH};
        ./b2
        toolset=${BOOST_TOOLSET}
        cxxflags=${BOOST_CFLAGS}
        --prefix=${BOOST_INSTALL_DIR}
        -j ${CARLA_BUILD_CONCURRENCY}
        install
    COMMAND mkdir -p ${LIBCARLA_CLIENT_INSTALL_DIR}/include/system
    COMMAND cp -R ${BOOST_INSTALL_DIR}/include/* ${LIBCARLA_CLIENT_INSTALL_DIR}/include/system
    COMMAND cp -R ${BOOST_INSTALL_DIR}/lib ${LIBCARLA_CLIENT_INSTALL_DIR}
    WORKING_DIRECTORY ${BOOST_SRC_BAK}
)

if(${TRAVIS})
    write_file(
        $ENV{HOME}/user-config.jam
        "using python : ${python_ver} : ${python_root}/bin/python${PY_VERSION} ;")
else()
    write_file(
        ${BOOST_SRC_BAK}/project-config.jam
        "using python : ${python_ver} : ${python_root}/bin/python${PY_VERSION} ;")
endif(${TRAVIS})


add_custom_target(
    install_boost
    DEPENDS boost_stage_release boost_build_install
)
