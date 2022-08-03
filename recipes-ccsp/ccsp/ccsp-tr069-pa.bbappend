FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append = " \
    ${@ ' file://0010-integrate-inangoplug-management_rdkbos.patch' if d.getVar('BUILD_TYPE', True) == 'RDKB-OS' else ' file://0010-integrate-inangoplug-management_rdkbcc.patch'} \
    ${@ ' file://0011-manage-with-ovs-infrustructure-subtree-rdkbos.patch' if d.getVar('BUILD_TYPE', True) == 'RDKB-OS' else ' file://0011-manage-with-ovs-infrustructure-subtree-rdkbcc.patch'} \
"
