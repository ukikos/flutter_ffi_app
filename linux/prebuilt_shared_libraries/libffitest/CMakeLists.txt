cmake_minimum_required(VERSION 3.13)

project(libffitest LANGUAGES C)

set(target_sources
    libffitest.c
    libffitest.h
)
list(TRANSFORM target_sources PREPEND "source/")

add_library(target SHARED ${target_sources})
set_target_properties(target PROPERTIES LIBRARY_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}")
set_target_properties(target PROPERTIES PREFIX "lib")
set_target_properties(target PROPERTIES OUTPUT_NAME "ffitest")
set_target_properties(target PROPERTIES SUFFIX ".so")