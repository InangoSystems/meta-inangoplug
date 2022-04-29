FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append = " \
    file://add_inangoplug_rdk_logger.patch \
    "
