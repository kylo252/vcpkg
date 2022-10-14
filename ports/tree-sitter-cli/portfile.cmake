set(VCPKG_POLICY_EMPTY_INCLUDE_FOLDER enabled)

# installing through npm until cargo is supported in vcpkg, see https://github.com/microsoft/vcpkg/issues/20619
set(NODEJS_PREFIX "${CURRENT_HOST_INSTALLED_DIR}/tools/node")
if(VCPKG_TARGET_IS_WINDOWS)
  set(NODEJS_DIR "${NODEJS_PREFIX}")
else()
  set(NODEJS_DIR "${NODEJS_PREFIX}/bin")
endif()
vcpkg_add_to_path(PREPEND "${NODEJS_DIR}")

find_program(NPM NAMES npm.cmd npm PATHS "${NODEJS_DIR}" NO_DEFAULT_PATHS REQUIRED)
message(STATUS "using npm: '${NPM}'")

set(TS_TOOLS_DIR "${CURRENT_PACKAGES_DIR}/tools/tree-sitter")
file(MAKE_DIRECTORY "${TS_TOOLS_DIR}")
vcpkg_execute_required_process(
  COMMAND "${NPM}" install --global --prefix "${TS_TOOLS_DIR}" tree-sitter-cli
  WORKING_DIRECTORY "${TS_TOOLS_DIR}"
  LOGNAME npm-install-${TARGET_TRIPLET}
)

if(VCPKG_TARGET_IS_WINDOWS)
  set(LICENSE_FILE "${TS_TOOLS_DIR}/node_modules/${PORT}/LICENSE")
else()
  set(LICENSE_FILE "${TS_TOOLS_DIR}/lib/node_modules/${PORT}/LICENSE")
endif()
file(INSTALL "${LICENSE_FILE}" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)

vcpkg_add_to_path(PREPEND "${TS_TOOLS_DIR}/bin")
