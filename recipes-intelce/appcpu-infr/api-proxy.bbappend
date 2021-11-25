FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append = " file://set_arm_inangoplug_enable_rpc_client.patch;patchdir=${WORKDIR}/${PN}-${PV}"
