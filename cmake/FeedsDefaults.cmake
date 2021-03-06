if(__feeds_defaults_included)
    return()
endif()
set(__feeds_defaults_included TRUE)

# Third-party dependency tarballs directory
set(FEEDS_DEPS_TARBALL_DIR ${CMAKE_SOURCE_DIR}/build/.tarballs)
set(FEEDS_DEPS_BUILD_PREFIX external)

# Intermediate distribution directory
set(FEEDS_INT_DIST_DIR ${CMAKE_BINARY_DIR}/intermediates)

# Host tools directory
set(FEEDS_HOST_TOOLS_DIR ${CMAKE_BINARY_DIR}/host)

set(PATCH_EXE patch)

set(CMAKE_MACOSX_RPATH TRUE)
set(CMAKE_BUILD_RPATH_USE_ORIGIN TRUE)
set(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE)
set(CMAKE_BUILD_RPATH ${FEEDS_INT_DIST_DIR}/lib)
set(CMAKE_INSTALL_RPATH ${CMAKE_INSTALL_PREFIX}/lib ../lib)

set(EXTERNAL_CMAKE_PROJECT_ADDITIONAL_ARGS
    -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE})

if(RASPBERRYPI)
    get_filename_component(CMAKE_TOOLCHAIN_FILE
        "${CMAKE_TOOLCHAIN_FILE}"
        ABSOLUTE
        BASE_DIR ${CMAKE_BINARY_DIR})

    set(EXTERNAL_CMAKE_PROJECT_ADDITIONAL_ARGS
        ${EXTERNAL_CMAKE_PROJECT_ADDITIONAL_ARGS}
        -DRPI_TOOLCHAIN_HOME=${RPI_TOOLCHAIN_HOME}
        -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}
        -DCMAKE_FIND_ROOT_PATH=${FEEDS_INT_DIST_DIR})

    set(EXTERNAL_AUTOCONF_PROJECT_ADDITIONAL_ARGS
        --host=${RPI_HOST}
        CC=${CMAKE_C_COMPILER}
        CXX=${CMAKE_CXX_COMPILER}
        CPP=${CMAKE_CPP_COMPILER}
        AR=${CMAKE_AR}
        RANLIB=${CMAKE_RANLIB}
        CPPFLAGS=--sysroot=${CMAKE_SYSROOT}
        CFLAGS=${CMAKE_C_FLAGS_INIT}
        CXXFLAGS=${CMAKE_CXX_FLAGS_INIT}
        LDFLAGS=--sysroot=${CMAKE_SYSROOT})
endif()

function(export_static_library MODULE_NAME)
    set(_INSTALL_DESTINATION lib)

    string(CONCAT STATIC_LIBRARY_NAME
        ${FEEDS_INT_DIST_DIR}/${_INSTALL_DESTINATION}/
        ${CMAKE_STATIC_LIBRARY_PREFIX}
        ${MODULE_NAME}
        ${CMAKE_STATIC_LIBRARY_SUFFIX})

    file(RELATIVE_PATH STATIC_LIBRARY_NAME ${CMAKE_CURRENT_LIST_DIR}
        ${STATIC_LIBRARY_NAME})

    install(FILES ${STATIC_LIBRARY_NAME}
        DESTINATION ${_INSTALL_DESTINATION})
endfunction()

function(export_shared_library MODULE_NAME)
    set(_INSTALL_DESTINATION lib)

    string(CONCAT SHARED_LIBRARY_PATTERN
        ${FEEDS_INT_DIST_DIR}/${_INSTALL_DESTINATION}/
        ${CMAKE_SHARED_LIBRARY_PREFIX}
        ${MODULE_NAME}*
        ${CMAKE_SHARED_LIBRARY_SUFFIX}*)

    install(CODE
        "file(GLOB SHARED_LIBRARY_FILES \"${SHARED_LIBRARY_PATTERN}\")
         file(INSTALL \${SHARED_LIBRARY_FILES}
              DESTINATION \"\${CMAKE_INSTALL_PREFIX}/${_INSTALL_DESTINATION}\")")

endfunction()
