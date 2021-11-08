FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append = " \
    ${@ ' file://0010-integrate-inangoplug-management_rdkbos.patch' if d.getVar('BUILD_TYPE', True) == 'RDKB-OS' else ' file://0010-integrate-inangoplug-management_rdkbcc.patch'} \
    "
