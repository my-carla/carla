set(libosmscout_src ${CMAKE_CURRENT_LIST_DIR}/libosmscout)
set(lunasvg_src ${CMAKE_CURRENT_LIST_DIR}/lunasvg)


add_custom_target(
    build_libosmscout
    COMMAND ${CMAKE_COMMAND}
        -DCMAKE_INSTALL_PREFIX=${osm_3rd_install_dir}
        .
    WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}/libosmscout
)

add_custom_target(
    install_libosmscout ALL
    DEPENDS build_libosmscout
    COMMAND make install
    WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}/libosmscout
)


add_custom_target(
    build_lunasvg
    COMMAND ${CMAKE_COMMAND}
        -DCMAKE_INSTALL_PREFIX=${osm_3rd_install_dir}
        .
    WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}/lunasvg
)

add_custom_target(
    install_lunasvg ALL
    DEPENDS build_lunasvg
    COMMAND make install
    WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}/lunasvg
)
