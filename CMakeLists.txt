cmake_minimum_required(VERSION 2.8)
set(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake-modules)
set(CMAKE_D_USE_PHOBOS True)
include(UseDDoc)

project(gnome-outpost D)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/lib)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/lib)

include_directories(
    ${CMAKE_BINARY_DIR}
    ${CMAKE_SOURCE_DIR}
    "externals/LuaD/"
)

link_directories(
    ${CMAKE_SOURCE_DIR}/externals/LuaD/lib/
)

file(GLOB_RECURSE SOURCES src/*.d)

add_executable(gnome-outpost
    ${SOURCES}
)

target_link_libraries(gnome-outpost
    luajit-5.1
    luad
    )
