set(UE4_ROOT $ENV{UE4_ROOT})
set(CC $ENV{CC})
set(CXX $ENV{CXX})

set(CARLA_BUILD_CONCURRENCY 8)
set(PY_VERSION 3)

set(INSTALL_DIR ${PROJECT_SOURCE_DIR}/Install)
set(SERVER_INSTALL_DIR ${INSTALL_DIR}/Server)
set(CLIENT_INSTALL_DIR ${INSTALL_DIR}/Client)

set(CARLA_PYTHONAPI_DIR ${PROJECT_SOURCE_DIR}/PythonAPI)
set(CARLA_PYTHONAPI_CARLA_DIR ${CARLA_PYTHONAPI_DIR}/carla)
set(CARLAUE4_DIR ${PROJECT_SOURCE_DIR}/Unreal/CarlaUE4)
set(CARLAUE4_PLUGIN_DIR ${CARLAUE4_DIR}/Plugins/Carla)

################## envs ################
# common
set(LLVM_INCLUDE "${UE4_ROOT}/Engine/Source/ThirdParty/Linux/LibCxx/include/c++/v1")
set(LLVM_LIBPATH "${UE4_ROOT}/Engine/Source/ThirdParty/Linux/LibCxx/lib/Linux/x86_64-unknown-linux-gnu")
set(UNREAL_HOSTED_CFLAGS "--sysroot=${UE4_ROOT}/Engine/Extras/ThirdPartyNotUE/SDKs/HostLinux/Linux_x64/v17_clang-10.0.1-centos7/x86_64-unknown-linux-gnu/")

# file or dirs
set(CLIENT_BUILD_DIR ${CMAKE_BINARY_DIR}/client)
set(SERVER_BUILD_DIR ${CMAKE_BINARY_DIR}/server)
set(COMMON_BUILD_DIR ${CMAKE_BINARY_DIR}/common)
set(CARLA_CONFIG_CMAKE ${CMAKE_CURRENT_LIST_DIR}/config.cmake)
set(CARLA_VAR_CMAKE ${CMAKE_CURRENT_LIST_DIR}/var.cmake)
set(CLIENT_TOOLCHAIN_CMAKE_IN ${CMAKE_CURRENT_LIST_DIR}/ClientToolChain.cmake.in)
set(SERVER_TOOLCHAIN_CMAKE_IN ${CMAKE_CURRENT_LIST_DIR}/ServerToolChain.cmake.in)
set(CLIENT_TOOLCHAIN_CMAKE ${CMAKE_BINARY_DIR}/ClientToolChain.cmake)
set(SERVER_TOOLCHAIN_CMAKE ${CMAKE_BINARY_DIR}/ServerToolChain.cmake)
set(CARLA_THIRD_PARTIES_INFO_CMAKE_IN ${CMAKE_CURRENT_LIST_DIR}/ThirdPartiesInfo.cmake.in)
set(CARLA_THIRD_PARTIES_INFO_CMAKE ${CMAKE_BINARY_DIR}/ThirdPartiesInfo.cmake)
