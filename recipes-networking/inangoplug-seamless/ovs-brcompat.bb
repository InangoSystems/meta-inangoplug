SUMMARY = "OpenvSwitch brcompat"
DESCRIPTION = "\
	Open vSwitch is a production quality, multilayer virtual switch \
	licensed under the open source Apache 2.0 license. It is designed \
	to enable massive network automation through programmatic extension, \
	while still supporting standard management interfaces and protocols \
	(e.g. NetFlow, sFlow, SPAN, RSPAN, CLI, LACP, 802.1ag) \
	"

HOMEPAGE = "http://openvswitch.org/"
SECTION = "networking"
LICENSE = "Apache-2"

DEPENDS += "openvswitch"
DEPENDS += "virtual/kernel openvswitch"

SRCREV = "${INANGOPLUG_SRCREV}"
SRC_URI = "${INANGOPLUG_SRC_URI}"

RDEPENDS_${PN} = "openvswitch-switch"

EXTRA_OECONF += "\
	PYTHON=python3 \
	PYTHON3=python3 \
	"
CONFIGUREOPT_DEPTRACK = ""

PACKAGES =+ "${PN}-brcompat"

inherit autotools systemd python3native

do_configure_prepend() {
	# Work around the for Makefile CC=$(if ....) by swapping out any
	# "-Wa," assembly directives with "-Xassembler
	CC=`echo '${CC}' | sed 's/-Wa,/-Xassembler /g'`
}

PACKAGE_ARCH = "${MACHINE_ARCH}"

S = "${WORKDIR}/git"
PV = "2.13+${SRCPV}"

FILESEXTRAPATHS_append := "${THISDIR}/${PN}-git:"

FILESEXTRAPATHS_append := "${THISDIR}/${PN}-files:"
SRC_URI_append = " \
			file://ovs-brcompatd.service \
           "
SYSTEMD_SERVICE_${PN} += "ovs-brcompatd.service"

LIC_FILES_CHKSUM = "file://LICENSE;md5=1ce5d23a6429dff345518758f13aaeab"

PACKAGECONFIG[ssl] = ",--disable-ssl,openssl,"

EXTRA_OECONF_class-target += "--with-linux=${STAGING_KERNEL_BUILDDIR} \
                              --with-linux-source=${STAGING_KERNEL_DIR} \
                              KARCH=x86 \
                              --with-dbdir=/var/run/openvswitch \
                              --enable-shared=yes \
                              --enable-static=no \
                             "

EXTRA_OEMAKE += "CFLAGS+='-I$(PKG_CONFIG_SYSROOT_DIR)/$(includedir)/openvswitch/lib/'"

FILES_${PN} += "/lib/modules \
	/usr/share/openvswitch/scripts/ovs-brcompat-ctl \
	${sbindir}/ovs-brcompat"

do_install_append_class-target() {
    oe_runmake modules_install INSTALL_MOD_PATH=${D}
 
    install -d ${D}/${systemd_unitdir}/system/
    install -m 644 ${WORKDIR}/ovs-brcompatd.service ${D}/${systemd_unitdir}/system/
}

do_install_append() {
	oe_runmake modules_install INSTALL_MOD_PATH=${D}
}
