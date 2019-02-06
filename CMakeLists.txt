# Проверка версии CMake
# Если версия CMake меньше указанной, то произойдет аварийный выход
cmake_minimum_required(VERSION 3.6.0 FATAL_ERROR)

# Название проекта
project (TestQml LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

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

find_package(Qt5 COMPONENTS Core Quick REQUIRED)

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

set (QML
	MenuItem.qml
	MainMenu.qml
	main.qml
)

qt5_wrap_cpp(MOCS ${MOC_HEADERS})
qt5_add_resources(RCC ${RESOURCES})

source_group ("Sources" FILES ${SOURCES})
source_group ("Headers" FILES ${HEADERS})
source_group ("Resource" FILES ${RESOURCES})
source_group ("qml" FILES ${QML})
source_group ("Generated Files" FILES ${MOCS} ${RCC})

add_executable (TestQml WIN32
	${HEADERS}
	${SOURCES}
	${RCC}
	${MOCS}
	${QML}
)

target_link_libraries(${PROJECT_NAME} PRIVATE Qt5::Core Qt5::Quick)

set_directory_properties(PROPERTIES VS_STARTUP_PROJECT TestQml)