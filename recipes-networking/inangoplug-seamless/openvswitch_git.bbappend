include inangoplug_patches/seamless_ovs_patchset.inc

DEPENDS_remove_class-native = "virtual/kernel-native bridge-utils-native"
DEPENDS_remove = "bridge-utils python perl"
DEPENDS_remove = "virtual/kernel"
DEPENDS_append_class-target = " inangoplug-pp-acceleration-mod"

RDEPENDS_${PN}_remove = "python3-twisted"
RDEPENDS_${PN} += " ${PN}-brcompat ${PN}-testcontroller "

FILESEXTRAPATHS_prepend := "${THISDIR}/inangoplug_files:${THISDIR}/inangoplug_patches:"

SRCREV = "71d553b995d0bd527d3ab1e9fbaf5a2ae34de2f3"
SRC_URI_append = " file://ovs-brcompatd.service \
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

#
# All changes below are added for compatibility with meta-rdk-mesh
# meta-rdk-mesh removes files, that are used by seamless ovs, here those files
# are restored
#
do_install_append() {
    install -d ${D}/${systemd_unitdir}/system/
    install -m 644 ${S}/rhel/usr_lib_systemd_system_ovs-vswitchd.service \
        ${D}/${systemd_unitdir}/system/ovs-vswitchd.service
    install -m 644 ${S}/rhel/usr_lib_systemd_system_openvswitch.service \
        ${D}/${systemd_unitdir}/system/openvswitch.service
    install -m 644 ${S}/rhel/usr_lib_systemd_system_ovsdb-server.service \
        ${D}/${systemd_unitdir}/system/ovsdb-server.service
}

# added for compatibility with rdk-mesh
SRC_URI_remove = "file://ovsdb-idlc.in-fix-dict-change-during-iteration.patch"

FILES_${PN} += "${datadir}/ovsdbmonitor"
FILES_${PN} += "/run"
FILES_${PN} += "/var/run/openvswitch"
FILES_${PN} += "/lib/modules"

FILES_${PN} += "/usr/share/openvswitch/scripts/ovs-ctl"
FILES_${PN} += "/usr/share/openvswitch/scripts/ovs-kmod-ctl"
FILES_${PN} += "/usr/share/openvswitch/scripts/ovs-save"
FILES_${PN} += "/usr/share/openvswitch/scripts/ovs-systemd-reload"
FILES_${PN} += "/usr/share/openvswitch/scripts/ovs-lib"

# added for compatibility with rdk-mesh
FILES_${PN}-switch += "\
        ${sysconfdir}/init.d/openvswitch-switch \
        ${sysconfdir}/default/openvswitch-switch \
        ${sysconfdir}/sysconfig/openvswitch \
        ${sysconfdir}/openvswitch/default.conf \
        "

# added for compatibility with rdk-mesh
# some files are removed with _remove suffix, and can't be restored with
# _append suffix, thus __anynymous function is used
python __anonymous() {
    pn_switch_var = "FILES_" + d.getVar("PN", True) + "-switch"
    systemd_service_var = "SYSTEMD_SERVICE_" + d.getVar("PN", True) + "-switch"
    d.setVar(pn_switch_var, d.getVar("PN_NEEDED", True))
    d.setVar(systemd_service_var, "ovsdb-server.service ovs-vswitchd.service openvswitch.service ovs-brcompatd.service")
}

PN_NEEDED =  "\
/usr/share/openvswitch/ovn-nb.ovsschema \
/usr/share/openvswitch/vtep.ovsschema \
/usr/share/openvswitch/ovn-sb.ovsschema \
/usr/share/openvswitch/vswitch.ovsschema \
${systemd_unitdir}/system/openvswitch.service \
${systemd_unitdir}/system/ovs-vswitchd.service \
${systemd_unitdir}/system/ovsdb-server.service \
${bindir}/ovs-appctl \
${bindir}/ovs-dpctl \
${bindir}/ovs-ofctl \
${sbindir}/ovs-vswitchd \
${sysconfdir}/init.d/openvswitch-switch \
${sysconfdir}/default/openvswitch-switch \
${sysconfdir}/sysconfig/openvswitch \
${sysconfdir}/openvswitch/default.conf"

