FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

# that patch need to check that inangoplug is started
SRC_URI += "file://utopia_init_xb6_inangoplug_ready.patch \
            file://add_inangoplug_rdkb_logger_utopia_defaults.patch \
           "
