LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${WORKDIR}/LICENSE;md5=34f8c1142fd6208a8be89399cb521df9"
SUMMARY = "Remote system call server startup"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI = " \
    file://rsc-server.service \
    file://rsc-server.path \
    file://rsc-server_default.conf \
    file://create_vsclient_enable.sh \
    file://LICENSE \
"

inherit systemd

SYSTEMD_SERVICE_${PN} = "rsc-server.service rsc-server.path"

do_install () {
    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/rsc-server.service ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/rsc-server.path ${D}${systemd_unitdir}/system

    install -d ${D}${sysconfdir}/systemd
    install -m 0644 ${WORKDIR}/rsc-server_default.conf ${D}${sysconfdir}/systemd

    install -d ${D}${sysconfdir}/scripts
    install -d ${D}${sysconfdir}/scripts/ncpu_exec
    install -m 0755 ${WORKDIR}/create_vsclient_enable.sh ${D}${sysconfdir}/scripts/ncpu_exec
}
