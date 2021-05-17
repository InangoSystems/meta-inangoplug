LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=34f8c1142fd6208a8be89399cb521df9"
SUMMARY = "Remote system call server application rsc-server"

## remove overriding of makefiles variables
EXTRA_OEMAKE_remove = "-e"

SRCREV = "${INANGOPLUG_SRCREV}"
SRC_URI = "${INANGOPLUG_SRC_URI}"

S = "${WORKDIR}/git"

do_compile() {
	oe_runmake all -C ${S}/src/server/
}

do_install() {
	install -d ${D}${bindir}
	install -m 0755 ${S}/src/server/rsc-server ${D}${bindir}
	install -m 0755 ${S}/src/server/scripts/rsc-server.sh ${D}${bindir}
}
