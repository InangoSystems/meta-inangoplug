LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${WORKDIR}/LICENSE;md5=34f8c1142fd6208a8be89399cb521df9"
SUMMARY = "Remote system call server and proxy startup"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

inherit systemd

SYSTEMD_SERVICE_${PN} = "rsc-init@.service rsc-server@.service rsc-proxy@.service"

SRC_URI = " \
    file://rsc-init@.service \
    file://rsc-server@.service \
    file://rsc-proxy@.service \
    file://rsc-proxy_default.conf \
    file://on_ovs_bridge_event.sh \
    file://LICENSE \
"

do_install() {
    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/rsc-init@.service ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/rsc-server@.service ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/rsc-proxy@.service ${D}${systemd_unitdir}/system

    install -d ${D}${sysconfdir}/systemd
    install -m 0644 ${WORKDIR}/rsc-proxy_default.conf ${D}${sysconfdir}/systemd

    install -d ${D}${sysconfdir}/scripts
    install -m 0755 ${WORKDIR}/on_ovs_bridge_event.sh ${D}${sysconfdir}/scripts
}
