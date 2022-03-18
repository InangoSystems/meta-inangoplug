FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append = " \
    ${@bb.utils.contains('DISTRO_FEATURES', 'inangoplug_linux_bpf', 'file://bpf.cfg', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'inangoplug_ovs_in_tree', 'file://openvswitch.cfg', '', d)} \
                 "
