FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append_puma7 = " \
	file://deviceless_ioctl_get_hook.patch \
	file://adding_am_id_to_session_info_ATOM.patch \
	file://ovs_brc_mcsnoop_hook.patch \
	file://ovs_upper_dev_priv_flags.patch \
"
