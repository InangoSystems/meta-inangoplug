FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append = "${@ ' file://add_inangoplug_rdkbcc_logger_common_library.patch' if d.getVar('BUILD_TYPE', True) == 'RDKB' else ' file://add_inangoplug_rdkbos_logger_common_library.patch'}"
SRC_URI_append_morty = "${@ ' file://add_safelibc.patch' if d.getVar('BUILD_TYPE', True) == 'RDKB-OS' else ''}"
