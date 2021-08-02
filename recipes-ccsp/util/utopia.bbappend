FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

# that patch need to check that inangoplug is started
SRC_URI += "file://utopia_init_xb6_inangoplug_ready.patch"
