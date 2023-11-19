set(CMAKE_C_COMPILER ${CC})
set(CMAKE_CXX_COMPILER ${CXX})

# disable -Werror since the boost 1.72 doesn't compile with ad_rss without warnings (i.e. the geometry headers)
set(CMAKE_CXX_FLAGS "\${CMAKE_CXX_FLAGS} -std=c++14 -pthread -fPIC" CACHE STRING "" FORCE)
set(CMAKE_CXX_FLAGS "\${CMAKE_CXX_FLAGS} -Wall -Wextra -Wpedantic" CACHE STRING "" FORCE)
set(CMAKE_CXX_FLAGS "\${CMAKE_CXX_FLAGS} -Wdeprecated -Wshadow -Wuninitialized -Wunreachable-code" CACHE STRING "" FORCE)
set(CMAKE_CXX_FLAGS "\${CMAKE_CXX_FLAGS} -Wpessimizing-move -Wold-style-cast -Wnull-dereference" CACHE STRING "" FORCE)
set(CMAKE_CXX_FLAGS "\${CMAKE_CXX_FLAGS} -Wduplicate-enum -Wnon-virtual-dtor -Wheader-hygiene" CACHE STRING "" FORCE)
set(CMAKE_CXX_FLAGS "\${CMAKE_CXX_FLAGS} -Wconversion -Wfloat-overflow-conversion" CACHE STRING "" FORCE)

# @todo These flags need to be compatible with setup.py compilation.
set(CMAKE_CXX_FLAGS_RELEASE_CLIENT "\${CMAKE_CXX_FLAGS_RELEASE} -DNDEBUG -g -fwrapv -O2 -Wall -Wstrict-prototypes -fno-strict-aliasing -Wdate-time -D_FORTIFY_SOURCE=2 -g -fstack-protector-strong -Wformat -Werror=format-security -fPIC -std=c++14 -Wno-missing-braces -DBOOST_ERROR_CODE_HEADER_ONLY" CACHE STRING "" FORCE)

set(CMAKE_CXX_FLAGS "\${CMAKE_CXX_FLAGS} -stdlib=libc++" CACHE STRING "" FORCE)
set(CMAKE_CXX_FLAGS "\${CMAKE_CXX_FLAGS} -isystem ${LLVM_INCLUDE} ${UNREAL_HOSTED_CFLAGS}" CACHE STRING "" FORCE)
set(CMAKE_CXX_FLAGS "\${CMAKE_CXX_FLAGS} -fno-exceptions" CACHE STRING "" FORCE)
set(CMAKE_CXX_LINK_FLAGS "\${CMAKE_CXX_LINK_FLAGS} -L${LLVM_LIBPATH} ${UNREAL_HOSTED_CFLAGS}" CACHE STRING "" FORCE)
set(CMAKE_CXX_LINK_FLAGS "\${CMAKE_CXX_LINK_FLAGS} -lc++ -lc++abi" CACHE STRING "" FORCE)

