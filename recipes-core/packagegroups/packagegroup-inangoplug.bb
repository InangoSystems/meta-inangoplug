DESCRIPTION = "Inango Plug Packagegroup"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${FILE_DIRNAME}/${PN}/LICENSE;md5=34f8c1142fd6208a8be89399cb521df9"

inherit packagegroup

PACKAGES = "\
    packagegroup-inangoplug \
"

RDEPENDS_${PN} = "\
    inangoplug-rsc \
"

RDEPENDS_${PN}_append_puma7arm = " \
    ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'inangoplug-rsc-init-arm-systemd', '', d)} \
"

RDEPENDS_${PN}_append_puma7 = " \
    openvswitch \
    ovs-brcompat \
    inangoplug-rsc-proxy \
    inangoplug-chandler \
    inangoplug-pp-acceleration-mod \
    ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'inangoplug-rsc-init-atom-systemd', '', d)} \
    inangoplug-mngm \
    ${@bb.utils.contains('DISTRO_FEATURES', 'inangoplug_linux_bpf', 'iproute2-tc', '', d)} \
"
