# ######################################################################## #
# File:     /CMakeLists.txt
#
# Purpose:  Top-level CMake lists file for ReadDebugString
#
# Created:  15th August 2025
# Updated:  24th August 2026
#
# ######################################################################## #


# ##########################################################
# CMake

cmake_minimum_required(VERSION 3.20 FATAL_ERROR)

# require out-of-source builds
file(TO_CMAKE_PATH "${CMAKE_CURRENT_BINARY_DIR}/CMakeLists.txt" LOC_PATH)
if(EXISTS "${LOC_PATH}")

	message(FATAL_ERROR "You cannot build in a source directory (or any directory with a CMakeLists.txt file). Please make a build subdirectory. Feel free to remove CMakeCache.txt and CMakeFiles.")
endif()

# directory for CMake specific extensions and source files.
set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake" ${CMAKE_MODULE_PATH})


# ##########################################################
# project

project(ReadDebugString
	DESCRIPTION "ReadDebugString is a Windows CLI that reads messages from the Windows debugger."
	HOMEPAGE_URL "https://github.com/sistools/ReadDebugString"
	LANGUAGES C CXX
)

string(TOLOWER ${PROJECT_NAME} PROJECT_NAME_LOWER)
string(TOUPPER ${PROJECT_NAME} PROJECT_NAME_UPPER)

# handle version number
set(RX_PROJ_TAG "${PROJECT_NAME_UPPER}")
set(RX_WS "[ \t]")
file(READ "${CMAKE_SOURCE_DIR}/main.cpp" _impl_file)
string(REGEX MATCH "#${RX_WS}*define${RX_WS}+_?${RX_PROJ_TAG}_VER_MAJOR${RX_WS}+([0-9]+)" MAJOR_DUMMY ${_impl_file})
set(_VERSION_MAJOR ${CMAKE_MATCH_1})
string(REGEX MATCH "#${RX_WS}*define${RX_WS}+_?${RX_PROJ_TAG}_VER_MINOR${RX_WS}+([0-9]+)" MINOR_DUMMY ${_impl_file})
set(_VERSION_MINOR ${CMAKE_MATCH_1})
string(REGEX MATCH "#${RX_WS}*define${RX_WS}+_?${RX_PROJ_TAG}_VER_PATCH${RX_WS}+([0-9]+)" PATCH_DUMMY ${_impl_file})
set(_VERSION_PATCH ${CMAKE_MATCH_1})

# set project version number here
set(PROJECT_VERSION_MAJOR ${_VERSION_MAJOR})
set(PROJECT_VERSION_MINOR ${_VERSION_MINOR})
set(PROJECT_VERSION_PATCH ${_VERSION_PATCH})
set(PROJECT_VERSION "${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}.${PROJECT_VERSION_PATCH}")

# adhere strictly to C and C++ standards plus extensions. These are actually
# useless since we do not compile anything; they merely state our intention.
set(CMAKE_C_STANDARD 17)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS ON) # GNU extensions and POSIX standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS ON)

if(MSVC)

	if(MSVC_VERSION GREATER_EQUAL 1914)

		add_compile_options("/Zc:__cplusplus")

		add_definitions(-D_SILENCE_CXX17_ITERATOR_BASE_CLASS_DEPRECATION_WARNING)
	endif()

	if(MSVC_VERSION LESS 1930)

		set(CMAKE_C_STANDARD 90)
		set(CMAKE_CXX_STANDARD 98)
	endif()

	if(MSVC_USE_MT)

		set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")
	endif(MSVC_USE_MT)
else(MSVC)

	if(MSVC_USE_MT)

		# this here just to absorb warning about not using `MSVC_USE_MT` (to
		# enable **prepare_cmake.sh** to be simple)
	endif(MSVC_USE_MT)
endif(MSVC)


# ##########################################################
# dependencies, includes, options

# ################################################
# includes - 1

if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/cmake/BuildType.cmake")

	include(BuildType)
endif()
#[====[
include(LanguageFullVersion)
include(TargetMacros)
#]====]


# ################################################
# dependencies, features, and options


# ######################################
# options

option(BUILD_EXAMPLES "Build examples" ON)

option(BUILD_TESTING "Build tests" ON)


# ######################################
# features

# This tool targets Windows only (WinSTL).
if(NOT WIN32)

	message(FATAL_ERROR "${PROJECT_NAME} targets Windows only")
endif()


# ######################################
# dependencies
#
# required:
# - STLSoft;
#
# required if testing enabled:
# - (none);
#
# optional:


# ############################
# STLSoft
#
# NOTE: This is resolved before other dependencies because imported targets
# may reference STLSoft::STLSoft in their link interfaces.

if(DEFINED STLSOFT)

	message("-- STLSOFT provided as CMake variable with value '${STLSOFT}'")
	set(STLSOFT_INCLUDE_DIR "${STLSOFT}/include")
elseif(DEFINED ENV{STLSOFT})

	message("-- STLSOFT provided as environment variable with value '$ENV{STLSOFT}'")
	set(STLSOFT_INCLUDE_DIR "$ENV{STLSOFT}/include")
endif()

if(DEFINED STLSOFT_INCLUDE_DIR)

	if(NOT IS_DIRECTORY "${STLSOFT_INCLUDE_DIR}")

		message(FATAL_ERROR "STLSoft include directory not found: ${STLSOFT_INCLUDE_DIR}")
	endif()

	if(NOT TARGET STLSoft::STLSoft)

		add_library(STLSoft::STLSoft INTERFACE IMPORTED GLOBAL)
		set_target_properties(STLSoft::STLSoft PROPERTIES
			INTERFACE_INCLUDE_DIRECTORIES "${STLSOFT_INCLUDE_DIR}"
		)
	endif()
else()

	set(STLSoft_REQUIRED_VERSION_ 1.11.1)

	find_package(STLSoft ${STLSoft_REQUIRED_VERSION_} REQUIRED)

	message("-- CMake package STLSoft found (version ${STLSoft_VERSION}; ${STLSoft_REQUIRED_VERSION_} requested)")
endif()

if(DEFINED STLSOFT_INCLUDE_DIR)

	include_directories("${STLSOFT_INCLUDE_DIR}")
endif()


# ################################################
# includes - 2

include(CMakePackageConfigHelpers)
if(BUILD_TESTING)

	include(CTest)
endif(BUILD_TESTING)
include(GNUInstallDirs)


# ##########################################################
# tool

add_executable(${PROJECT_NAME}
	main.cpp
)

target_compile_options(${PROJECT_NAME}
	PRIVATE
		$<$<OR:$<CXX_COMPILER_ID:Clang>,$<CXX_COMPILER_ID:AppleClang>,$<CXX_COMPILER_ID:GNU>>:
			-Werror -Wall -Wextra -pedantic
		>
		$<$<OR:$<CXX_COMPILER_ID:Clang>,$<CXX_COMPILER_ID:AppleClang>>:
			-Wno-anonymous-structs
		>
		$<$<CXX_COMPILER_ID:MSVC>:
			/WX /W4

			/wd4201
			/wd4702
		>
)

target_link_options(${PROJECT_NAME}
	PRIVATE
		$<$<CXX_COMPILER_ID:GNU>:-municode>
)

target_link_libraries(${PROJECT_NAME}
	$<$<STREQUAL:${STLSOFT_INCLUDE_DIR},>:STLSoft::STLSoft>
)

install(TARGETS ${PROJECT_NAME}
	RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

install(FILES
	doc/${PROJECT_NAME_LOWER}.1
	DESTINATION ${CMAKE_INSTALL_MANDIR}/man1
)


# ################################################
# examples


# ################################################
# tests

if(BUILD_TESTING)

	message("-- enabled building of tests ...")
else(BUILD_TESTING)

	message("-- disabled building of tests - define BUILD_TESTING to enable")
endif(BUILD_TESTING)


# ##########################################################
# completion

message(NOTICE "Generating CMake build scripts for ${PROJECT_NAME} ${PROJECT_VERSION}, for C${CMAKE_C_STANDARD} C++${CMAKE_CXX_STANDARD}")


# ############################## end of file ############################# #
