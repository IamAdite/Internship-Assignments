cmake_minimum_required(VERSION 2.8 FATAL_ERROR)

if (CMAKE_HOST_WIN32)
	add_library(sqlite3 SHARED ./src/sqlite3.c)
endif()

if (CMAKE_HOST_UNIX)
	add_library(sqlite3 SHARED ./src/sqlite3.c ./src/shell.c)
endif()

