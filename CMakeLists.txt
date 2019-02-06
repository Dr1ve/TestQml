# Проверка версии CMake
# Если версия CMake меньше указанной, то произойдет аварийный выход
cmake_minimum_required(VERSION 3.6.0 FATAL_ERROR)

# Название проекта
project (TestQml)

if (CMAKE_SIZEOF_VOID_P MATCHES "8")
    set (PLATFORM_SIZE 64)
elseif (CMAKE_SIZEOF_VOID_P MATCHES "4")
    set (PLATFORM_SIZE 32)
else ()
    message (FATAL_ERROR "Unknown platform")
endif ()

if (UNIX)
    set (PLATFORM_TYPE unix)
elseif (WIN32)
    set (PLATFORM_TYPE WIN)
else ()
    message (FATAL_ERROR "Unknown system type")
endif ()

set (PLATFORM ${PLATFORM_TYPE}${PLATFORM_SIZE})
message (STATUS "Platform ${PLATFORM}")

include (_settings.cmake)
message (STATUS "Output dir:    ${PROJECTS_DST_DIR}")
message (STATUS "Qt:            ${QT_DIR}")

set(CMAKE_PREFIX_PATH ${QT_DIR})

# Пути для exe файлов
set (CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECTS_DST_DIR}/_BIN/${PLATFORM})

# Пути для статических библиотек lib
set (CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${PROJECTS_DST_DIR}/_LIB/${PLATFORM})

find_package(Qt5Core REQUIRED)
find_package(Qt5Gui REQUIRED)
find_package(Qt5Quick REQUIRED)

# Компилируем проект

include (config/add_project.cmake)

set (HEADERS

	game.h
	gamecontroller.h
	mainmenu.h
)

set (MOC_HEADERS

	game.h
	gamecontroller.h
	mainmenu.h
)

set (SOURCES

	game.cpp
	gamecontroller.cpp
	main.cpp
	mainmenu.cpp
)

set (RESOURCES

	qml.qrc
)

qt5_wrap_cpp(MOCS ${MOC_HEADERS})
qt5_add_resources(RCC ${RESOURCES})

source_group ("Sources" FILES ${SOURCES})
source_group ("Headers" FILES ${HEADERS})
source_group ("Resource" FILES ${RESOURCES} ${RCC})
source_group ("Generated Files" FILES ${MOCS})

add_executable (TestQml WIN32
	${HEADERS}
	${SOURCES}
	${RCC}
	${MOCS}
)

qt5_use_modules(TestQml Core Gui Quick)

set_directory_properties(PROPERTIES VS_STARTUP_PROJECT TestQml)