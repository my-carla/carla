set(install_dir ${PROJECT_SOURCE_DIR}/Install)
set(UE4_ROOT $ENV{UE4_ROOT})
set(CARLA_BUILD_CONCURRENCY 8)
set(PY_VERSION 3)
set(LLVM_INCLUDE "$ENV{UE4_ROOT}/Engine/Source/ThirdParty/Linux/LibCxx/include/c++/v1")
set(LLVM_LIBPATH "$ENV{UE4_ROOT}/Engine/Source/ThirdParty/Linux/LibCxx/lib/Linux/x86_64-unknown-linux-gnu")
set(UNREAL_HOSTED_CFLAGS "--sysroot=$ENV{UE4_ROOT}/Engine/Extras/ThirdPartyNotUE/SDKs/HostLinux/Linux_x64/v17_clang-10.0.1-centos7/x86_64-unknown-linux-gnu/")
set(RECAST_INSTALL_DIR "${PROJECT_SOURCE_DIR}/Util/DockerUtils/dist")
