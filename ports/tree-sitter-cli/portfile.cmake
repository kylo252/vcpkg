set(VCPKG_POLICY_EMPTY_INCLUDE_FOLDER enabled)

# installing through npm until cargo is supported in vcpkg, see https://github.com/microsoft/vcpkg/issues/20619
set(NODEJS_DIR "${CURRENT_HOST_INSTALLED_DIR}/tools/node")
vcpkg_add_to_path(PREPEND "${NODEJS_DIR}/bin")
find_program(NPM NAMES npm PATHS "${NODEJS_DIR}/bin" NO_DEFAULT_PATHS REQUIRED)

set(TS_TOOLS_DIR "${CURRENT_PACKAGES_DIR}/tools/tree-sitter")
file(MAKE_DIRECTORY "${TS_TOOLS_DIR}")
vcpkg_execute_required_process(
  COMMAND "${NPM}" install --global --prefix "${TS_TOOLS_DIR}" tree-sitter-cli
  WORKING_DIRECTORY "${TS_TOOLS_DIR}"
  LOGNAME npm-install-${TARGET_TRIPLET}
)

vcpkg_add_to_path(PREPEND "${TS_TOOLS_DIR}/bin")

file(INSTALL "${TS_TOOLS_DIR}/lib/node_modules/${PORT}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
