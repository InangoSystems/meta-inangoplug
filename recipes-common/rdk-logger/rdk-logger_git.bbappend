FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append = " \
    ${@ ' file://add_inangoplug_rdkbos_logger_rdk_logger.patch' if d.getVar('BUILD_TYPE', True) == 'RDKB-OS' else ' file://add_inangoplug_rdkbcc_logger_rdk_logger.patch'} \
    "
