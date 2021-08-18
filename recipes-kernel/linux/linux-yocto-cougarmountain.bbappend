FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append_puma7 = " \
	file://deviceless_ioctl_get_hook.patch \
"
