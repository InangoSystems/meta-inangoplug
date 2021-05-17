LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=34f8c1142fd6208a8be89399cb521df9"
SUMMARY = "RSC-proxy"

SRCREV = "${INANGOPLUG_SRCREV}"
SRC_URI = "${INANGOPLUG_SRC_URI}"

S = "${WORKDIR}/git"

do_compile() {
	oe_runmake all -C ${S}
}

do_install() {
	install -d ${D}${bindir}
	install -m 0755 ${S}/tcp-proxy ${D}${bindir}
}
