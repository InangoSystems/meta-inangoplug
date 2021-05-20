include openvswitch_${INANGOPLUG_OPENVSWITCH}.inc

RDEPENDS_${PN}_remove = "python3-twisted"
RDEPENDS_${PN} += " ${PN}-brcompat ${PN}-testcontroller "

FILESEXTRAPATHS_append := "${THISDIR}/inangoplug_files:"

SRC_URI_append = " file://0001-launch-rsc-server-arm.patch \
                   file://ovs-brcompatd.service \
                   file://ovsdb-idlc.in-fix-dict-change-during-iteration.patch \
                 "

PACKAGECONFIG += "pp-offload"
PACKAGECONFIG[pp-offload] = "--enable-pp-offload, --disable-pp-offload,,"

EXTRA_OECONF_class-target += "--with-linux=${STAGING_KERNEL_BUILDDIR} \
                              --with-linux-source=${STAGING_KERNEL_DIR} \
                              KARCH=x86 \
                              --with-dbdir=/var/run/openvswitch \
                              --enable-shared=yes \
                              --enable-static=no \
                             "

SYSTEMD_SERVICE_${PN}-switch += "ovs-brcompatd.service"

do_install_append_class-target() {
    oe_runmake modules_install INSTALL_MOD_PATH=${D}

    install -d ${D}/${systemd_unitdir}/system/
    install -m 644 ${WORKDIR}/ovs-brcompatd.service ${D}/${systemd_unitdir}/system/

    # Remove unneeded files
    rm -rf ${D}/usr/share/openvswitch/scripts/ovn-ctl
    rm -rf ${D}/usr/share/openvswitch/scripts/ovndb-servers.ocf
    rm -rf ${D}/usr/share/openvswitch/scripts/ovs-check-dead-ifs
    rm -rf ${D}/usr/share/openvswitch/scripts/ovs-monitor-ipsec
    rm -rf ${D}/usr/share/openvswitch/scripts/ovs-vtep
    rm -rf ${D}/usr/share/openvswitch/python
    rm -rf ${D}${bindir}/ovn-controller
    rm -rf ${D}${bindir}/vtep-ctl
    rm -rf ${D}${bindir}/ovs-pcap
    rm -rf ${D}${bindir}/ovn-docker-underlay-driver
    rm -rf ${D}${bindir}/ovs-testcontroller
    rm -rf ${D}${bindir}/ovn-sbctl
    rm -rf ${D}${bindir}/ovn-northd
    rm -rf ${D}${bindir}/ovs-docker
    rm -rf ${D}${bindir}/ovn-nbctl
    rm -rf ${D}${bindir}/ovn-docker-overlay-driver
    rm -rf ${D}${bindir}/ovs-tcpundump
    rm -rf ${D}${bindir}/ovs-pki
    rm -rf ${D}${bindir}/ovn-controller-vtep
    rm -rf ${D}${sysconfdir}/bash_completion.d
    rm -rf ${D}${sbindir}/ovs-vlan-bug-workaround
    rm -rf ${D}${libdir}/libvtep-2.11.so.*
    rm -rf ${D}${libdir}/libovn-2.11.so.*
}

# We don't need run-time configuration, since rootfs is read-only.
# Moreover, we remove 'ovs-pki'.
unset pkg_postinst_ontarget_${PN}-pki
unset pkg_postinst_ontarget_${PN}-testcontroller

inherit module-base
do_make_scripts ??= ":"
do_make_scripts[func] = "1"
addtask make_scripts after do_patch before do_compile
do_make_scripts[lockfiles] = "${TMPDIR}/kernel-scripts.lock"
do_make_scripts[depends] += "virtual/kernel:do_shared_workdir"
