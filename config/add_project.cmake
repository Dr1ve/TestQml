INCLUDE(CMakeParseArguments)

function(add_cmake_project NAME TYPE)

	CMAKE_PARSE_ARGUMENTS(ARGUM
		""
		""
		"HEADERS;SOURCES;QRC;UI;QTMODULES;LIBS;INCLUDEDIRS;EXTRASOURCES"
		${ARGN}
	)

	message (STATUS "---------------------------------------")
	#message (STATUS " ")
	message (STATUS "Project Name  ${NAME}")
	message (STATUS "Type          ${TYPE}")
	message (STATUS "Input Files")
	message (STATUS "Qt Modules:   ${ARGUM_QTMODULES}")
	#message (STATUS "        Headers   : ${ARGUM_HEADERS}")
	#message (STATUS "        Sources   : ${ARGUM_SOURCES}")
	#message (STATUS "        Qt Rcs    : ${ARGUM_QRC}")
	#message (STATUS "        Qt UIs    : ${ARGUM_UI}")
	#message (STATUS "        Incl dirs : ${ARGUM_INCLUDEDIRS}")
	message (STATUS "Libs:         ${ARGUM_LIBS}")

	if (ARGUM_UNPARSED_ARGUMENTS)
		message (FATAL_ERROR " add_project unknown arguments ${ARGUM_UNPARSED_ARGUMENTS}")
	endif()

	qt5_wrap_cpp     (MOCS ${ARGUM_HEADERS})
	qt5_add_resources(QRCS ${ARGUM_QRC})
	qt5_wrap_ui      (UIS  ${ARGUM_UI})

	#message (STATUS "    Generated Files:")
	#message (STATUS "        Moc Files : ${MOCS}")
	#message (STATUS "        Qrc Files : ${QRCS}")
	#message (STATUS "         Ui Files : ${UIS}")

	#message (STATUS "         moc.exe : ${QT_MOC_EXECUTABLE}")

	set(ALL_SOURCES ${ARGUM_HEADERS} ${ARGUM_SOURCES} ${ARGUM_QRC} ${ARGUM_UI})
	set(GENERATED_FILES ${MOCS} ${QRCS} ${UIS} ${ARGUM_EXTRASOURCES})
	
	source_group ("Source Files" FILES ${ALL_SOURCES})
	source_group ("Generated Files" FILES ${GENERATED_FILES})

	if (TYPE STREQUAL "DLL")
        	add_library (${NAME} SHARED ${ALL_SOURCES} ${GENERATED_FILES})
	elseif (TYPE STREQUAL "LIB")
        	add_library (${NAME} STATIC ${ALL_SOURCES} ${GENERATED_FILES})
        elseif (TYPE STREQUAL "EXE")    
        	add_executable (${NAME} WIN32 ${ALL_SOURCES} ${GENERATED_FILES})
	elseif (TYPE STREQUAL "CMD")
        	add_executable (${NAME} ${ALL_SOURCES} ${GENERATED_FILES})
	else()
		message (FATAL_ERROR "Unknown project type '${TYPE}'")
	endif()

	target_include_directories(${NAME} PUBLIC ${ARGUM_INCLUDEDIRS})
	target_link_libraries (${NAME} ${ARGUM_LIBS})
	qt5_use_modules(${NAME} ${ARGUM_QTMODULES})

	# добавляем SDK
	target_compile_definitions( ${NAME} PRIVATE MIRROR_STATIC_LIB)

	# добавляем либу удалённого запуска Диггера
	target_link_libraries( ${NAME} 
	debug ${SDK_SRC_DIR}/DiggerWrapper/RemoteServiceConnecterd.lib
	optimized ${SDK_SRC_DIR}/DiggerWrapper/RemoteServiceConnecter.lib
	)

	# добавляем либу менеджера устройств + сканера
	target_compile_definitions( ${NAME} PRIVATE LOCALDEVICESERVICE_STATIC_LIB)

	target_link_libraries( ${NAME} ${MIRROR_DEVICE_SERVICE})

endfunction()

function (add_project NAME TYPE)

	set (QTMODS 
		"Core"
		"Gui"
		"Widgets"
		"Network"
		)
	set (HEADERS "")
	set (SOURCES "")
	set (QRCS "")
	set (LIBS
		"MirrorSDK"
		"MirrorOutputWidget"
		)
	set (INCLDIRS
		${CMAKE_CURRENT_BINARY_DIR}
		${SDK_SRC_DIR}
		${INCLUDE_SRC_DIR}
		${SUBS_SRC_DIR}/constructionset/include
		${SUBS_SRC_DIR}/protocol/include
		${SUBS_SRC_DIR}/protocol_andromeda/include
		${SUBS_SRC_DIR}/protocol_dvb/include
		${SUBS_SRC_DIR}/protocol_dvbs2/include
		${PROJECT_SOURCE_DIR}/SRC/MirrorOutputWidget
		)
	
	set (EXTRASOURCES "")

	LIST (REMOVE_ITEM LIBS ${NAME})

#	if ((DEFINED AD_HASPKEY_LINES) AND (TYPE STREQUAL DLL) AND (NAME MATCHES "Proc*"))
#		message (STATUS "        Using HASP Helper Code")
#		file (WRITE 
#			"${CMAKE_CURRENT_BINARY_DIR}/${NAME}_HASPHelperCode.cpp" 
#			"#include \"HASP\\digger_key.h\"\n"
#			"#include \"SDK/DProcInterface.h\"\n"
#			"using namespace Digger2;\n"
#			"extern \"C\" DProcInterface* _NewProcInterface(){KeyOwner hasp; return (hasp.check()?NewProcInterface():0);}"
#		)
#		file (WRITE
#			"${CMAKE_CURRENT_BINARY_DIR}/${NAME}_HASPHelperCode.def" 
#			"LIBRARY ${NAME}\nEXPORTS\n\tNewProcInterface=_NewProcInterface"
#		)
#		LIST(APPEND EXTRASOURCES
#			"${CMAKE_CURRENT_BINARY_DIR}/${NAME}_HASPHelperCode.cpp"
#			"${CMAKE_CURRENT_BINARY_DIR}/${NAME}_HASPHelperCode.def" 
#		)
#	endif()

	foreach(SRC ${ARGN})
		if(SRC MATCHES "\\.lib$")
			STRING(LENGTH ${SRC} SRCLEN)
			MATH(EXPR CORRLEN "${SRCLEN}-4")
			STRING(SUBSTRING ${SRC} 0 ${CORRLEN} LIBNAME)
			LIST(APPEND LIBS ${LIBNAME})
		elseif(SRC MATCHES "^Qt5")
			STRING(LENGTH ${SRC} SRCLEN)
			MATH(EXPR CORRLEN "${SRCLEN}-3")
			STRING(SUBSTRING ${SRC} 3 ${CORRLEN} MODNAME)
			LIST(APPEND QTMODS ${MODNAME})
		elseif(SRC MATCHES "\\.h$")
			LIST(APPEND HEADERS ${SRC})
		elseif(SRC MATCHES "\\.qrc$")
			LIST(APPEND QRCS ${SRC})
		elseif(SRC MATCHES "/$")
			LIST(APPEND INCLDIRS ${SRC})
		elseif(SRC MATCHES "\\.ui$")
			LIST(APPEND UIS ${SRC})
		else()
			LIST(APPEND SOURCES ${SRC} )
		endif()		
	endforeach()

	add_cmake_project ( 
		${NAME} 
		${TYPE}
	HEADERS
		${HEADERS}
	SOURCES
		${SOURCES}
	QRC
		${QRCS}
	UI
		${UIS}
	QTMODULES
		${QTMODS}
	LIBS
		${LIBS}
	INCLUDEDIRS
		${INCLDIRS}
	EXTRASOURCES
		${EXTRASOURCES}
	)

	string (CONCAT CURRENT_VS_FOLDER_STACK ${VS_FOLDER_STACK})
	#message (STATUS "    VS Folder: ${CURRENT_VS_FOLDER_STACK}")

endfunction()
