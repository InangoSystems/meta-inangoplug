FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append = " \
                  ${@ ' file://add_inangoplug_rdkbcc_logger_log_agent.patch' if d.getVar('BUILD_TYPE', True) == 'RDKB' else ' file://add_inangoplug_rdkbos_logger_log_agent.patch'} \
                 "
