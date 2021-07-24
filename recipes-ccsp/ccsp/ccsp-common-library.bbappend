FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append_morty = "${@ ' file://add_safelibc.patch' if d.getVar('BUILD_TYPE', True) == 'RDKB-OS' else ''}"
