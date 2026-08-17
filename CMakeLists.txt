cmake_minimum_required(VERSION 3.20 FATAL_ERROR)

project(ReadDebugString
    VERSION 0.0.1
    DESCRIPTION "ReadDebugString is a Windows CLI that reads messages from the Windows debugger."
    HOMEPAGE_URL "https://github.com/sistools/ReadDebugString"
    LANGUAGES C
)

if(NOT WIN32)
    message(FATAL_ERROR "${PROJECT_NAME} targets Windows only")
endif()

set(CMAKE_C_STANDARD 17)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS ON)

include(GNUInstallDirs)

add_executable(${PROJECT_NAME}
    main.c
)

target_compile_options(${PROJECT_NAME}
    PRIVATE
        $<$<C_COMPILER_ID:Clang,AppleClang,GNU>:
            -Werror -Wall -Wextra -pedantic
        >
        $<$<C_COMPILER_ID:MSVC>:
            /WX /W4
        >
)

install(TARGETS ${PROJECT_NAME}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
