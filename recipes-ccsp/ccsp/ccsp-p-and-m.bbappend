FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append = " \
                  file://0054-remove-inangoplug-files.patch   \
                 "

CFLAGS_append = " -DCONFIG_INANGO_INANGOPLUG_SSL_DIR=${CONFIG_OVS_INFRASTRUCTURE_SSL_RUNTIME_DIR}"
