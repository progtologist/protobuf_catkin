# This function is used to force a build on a dependant project at cmake configuration phase.
# 
function(build_external_project_autotools target url tag) #FOLLOWING ARGUMENTS are the CMAKE_ARGS of ExternalProject_Add

    set(trigger_build_dir ${CMAKE_BINARY_DIR}/force_${target})

    #mktemp dir in build tree
    file(MAKE_DIRECTORY ${CATKIN_DEVEL_PREFIX}/include)

    #generate false dependency project
    set(CMAKE_LIST_CONTENT "
    cmake_minimum_required(VERSION 2.8)

    include(ExternalProject)
    ExternalProject_add(${target}
            GIT_REPOSITORY ${url}
            GIT_TAG ${tag}
            UPDATE_COMMAND \"\"
            CONFIGURE_COMMAND cd ../${target} && ./autogen.sh && ./configure --with-pic --prefix=${CATKIN_DEVEL_PREFIX}
            BUILD_COMMAND cd ../${target} && make -j8 && cd python && python setup.py build --build-purelib build
            INSTALL_COMMAND cd ../${target} && make install -j8 &&
                  cd python && python setup.py install --root ${CATKIN_DEVEL_PREFIX} --install-lib ${CATKIN_GLOBAL_PYTHON_DESTINATION} &&
                  cp build/google/__init__.py ${CATKIN_DEVEL_PREFIX}/${CATKIN_GLOBAL_PYTHON_DESTINATION}/google
            )

            add_custom_target(trigger_${target})
            add_dependencies(trigger_${target} ${target})")

    file(WRITE ${trigger_build_dir}/CMakeLists.txt "${CMAKE_LIST_CONTENT}")

    file(MAKE_DIRECTORY ${trigger_build_dir}/build)

    execute_process(COMMAND ${CMAKE_COMMAND} ..
        WORKING_DIRECTORY ${trigger_build_dir}/build
        )
    execute_process(COMMAND ${CMAKE_COMMAND} --build . -- -j4
        WORKING_DIRECTORY ${trigger_build_dir}/build
        )
    set(${target}_DIR ${CATKIN_DEVEL_PREFIX} PARENT_SCOPE)

endfunction()