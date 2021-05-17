LICENSE = "Apache-2.0 | MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=34f8c1142fd6208a8be89399cb521df9 \
                    file://3rd-party/jsmn/LICENSE;md5=5adc94605a1f7a797a9a834adbe335e3 \
                    "
SUMMARY = "Catastrophic Handler"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRCREV = "${INANGOPLUG_SRCREV}"
SRC_URI = "${INANGOPLUG_SRC_URI} \
           file://chandler.service \
          "

S = "${WORKDIR}/git"

inherit systemd

SYSTEMD_SERVICE_${PN} = "chandler.service"

do_compile() {
    oe_runmake all -C ${S}
}

do_install() {
    install -d ${D}${bindir}
    install -m 0755 ${S}/_bin/chandler ${D}${bindir}

    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/chandler.service ${D}${systemd_unitdir}/system
}
