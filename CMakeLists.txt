cmake_minimum_required(VERSION 2.8.3)
project(protobuf_catkin)

find_package(catkin_simple REQUIRED)
catkin_simple()

include(cmake/Modules/build_external_project_autotools.cmake)
build_external_project_autotools(protobuf
  https://github.com/google/protobuf.git
  b04e5cba356212e4e8c66c61bbe0c3a20537c5b9)

install(DIRECTORY ${CATKIN_DEVEL_PREFIX}/include/google/protobuf
        DESTINATION ${CATKIN_GLOBAL_INCLUDE_DESTINATION}/google
        FILES_MATCHING PATTERN "*.h")
install(DIRECTORY ${CATKIN_DEVEL_PREFIX}/lib/
        DESTINATION ${CATKIN_PACKAGE_LIB_DESTINATION}
        FILES_MATCHING PATTERN "libproto*")
install(FILES ${CATKIN_DEVEL_PREFIX}/bin/protoc
        PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE
        DESTINATION ${CATKIN_GLOBAL_BIN_DESTINATION})
cs_export(INCLUDE_DIRS ${CATKIN_DEVEL_PREFIX}/include
          LIBRARIES protobuf protobuf-lite protoc
          CFG_EXTRAS protobuf-generate-cpp.cmake)
