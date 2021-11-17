FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append = "file://set_arm_inangoplug_enable_rpc_server.patch;patchdir=${WORKDIR}/umftmp/ti/gw "
