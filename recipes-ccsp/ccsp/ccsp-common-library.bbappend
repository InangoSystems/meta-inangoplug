FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append = " \
    ${@ ' file://add_inangoplug_rdkbcc_logger_common_library.patch' if d.getVar('BUILD_TYPE', True) == 'RDKB' else ' file://add_inangoplug_rdkbos_logger_common_library.patch'} \
    "
