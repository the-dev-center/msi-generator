# CPack MSIGenerator Plugin Wrapper
# This module allows CPack to use the msi-generator tool.
# NOTE: This script is currently incomplete and will generate invalid JSON. 
#       See msi-generator documentation for required fields (productCode, upgradeCode).

if(NOT CPACK_MSI_GENERATOR_EXECUTABLE)
    find_program(CPACK_MSI_GENERATOR_EXECUTABLE msi-generator)
endif()

if(CPACK_MSI_GENERATOR_EXECUTABLE)
    set(CPACK_MSI_GENERATOR_FOUND TRUE)
else()
    set(CPACK_MSI_GENERATOR_FOUND FALSE)
    message(WARNING "msi-generator executable not found. MSI generation will be disabled.")
endif()

macro(cpack_msi_generator_generate_spec)
    set(MSI_SPEC_FILE "${CPACK_TOPLEVEL_DIRECTORY}/msi.json")
    
    # Generate JSON spec from CPack variables
    file(WRITE "${MSI_SPEC_FILE}" "{
  \"name\": \"${CPACK_PACKAGE_NAME}\",
  \"manufacturer\": \"${CPACK_PACKAGE_VENDOR}\",
  \"productVersion\": \"${CPACK_PACKAGE_VERSION}.0\",
  \"rootFolder\": {
    \"id\": \"INSTALLDIR\",
    \"name\": \"${CPACK_PACKAGE_NAME}\"
  }
}")
    
    # Run the generator
    execute_process(
        COMMAND ${CPACK_MSI_GENERATOR_EXECUTABLE} --spec "${MSI_SPEC_FILE}" --output "${CPACK_PACKAGE_FILE_NAME}.msi" --type msi
        WORKING_DIRECTORY "${CPACK_TOPLEVEL_DIRECTORY}"
        RESULT_VARIABLE MSI_GEN_RESULT
    )
    
    if(NOT MSI_GEN_RESULT EQUAL 0)
        message(FATAL_ERROR "MSI generation failed with error code ${MSI_GEN_RESULT}")
    endif()
endmacro()
