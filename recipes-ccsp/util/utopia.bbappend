FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

# that patch need to check that inangoplug is started
SRC_URI += " \
    ${@ ' file://utopia_init_inangoplug_ready.patch' if d.getVar('BUILD_TYPE', True) == 'RDKB-OS' else ' file://utopia_init_xb6_inangoplug_ready.patch'} \
    ${@ ' file://apply_inangoplug_defaults_rdkbos.patch' if d.getVar('BUILD_TYPE', True) == 'RDKB-OS' else ' file://apply_inangoplug_defaults_rdkbcc.patch'} \
    "
