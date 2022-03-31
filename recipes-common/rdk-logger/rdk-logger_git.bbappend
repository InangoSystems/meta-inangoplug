FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append = " \
    ${@ ' file://add_inangoplug_rdkbos_logger_rdk_logger.patch' if d.getVar('MXL_BUILD_FLAVOR', True) == 'RDKBOS' else ' file://add_inangoplug_rdkbcc_logger_rdk_logger.patch'} \
    "
