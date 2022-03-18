LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://LICENSE;md5=16604b00b964efab5ab040060bf08443"
SUMMARY = "Packet Processor Acceleration Module"

inherit module

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRCREV = "${INANGOPLUG_SRCREV}"
SRC_URI = "${INANGOPLUG_SRC_URI}"
SRC_URI_append = " file://openvswitch.conf "

S = "${WORKDIR}/git"

EXTRA_OEMAKE += "EXTRA_CFLAGS+='-Werror -Wall'"
EXTRA_OEMAKE += "DESTDIR='${D}'"

do_install_append() {
    install -d ${D}${sysconfdir}/modprobe.d/
    install -m 644 ${WORKDIR}/openvswitch.conf ${D}${sysconfdir}/modprobe.d/
}

FILES_${PN} += "${sysconfdir}/modprobe.d/openvswitch.conf"
