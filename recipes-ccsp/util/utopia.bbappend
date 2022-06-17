FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

# that patch need to check that inangoplug is started
SRC_URI += " \
    ${@ ' file://apply_inangoplug_defaults_rdkbos.patch' if d.getVar('MXL_BUILD_FLAVOR', True) == 'RDKBOS' else ' file://apply_inangoplug_defaults_rdkbcc.patch'} \
    "
