# This BBMASK was added to avoid warnings with missing recipes for bbappends on different platforms
BBMASK_ATOM = "recipes-gateway/gw-control/gw-control.bbappend"

BBMASK_ARM = "recipes-intelce/appcpu-infr/api-proxy.bbappend"
BBMASK_ARM .= "|recipes-ccsp/ccsp/ccsp-p-and-m.bbappend"
BBMASK_ARM .= "|recipes-ccsp/ccsp/ccsp-tr069-pa.bbappend"
BBMASK_ARM .= "|recipes-ccsp/util/utopia.bbappend"
BBMASK_ARM .= "|recipes-common/rdk-logger/rdk-logger_git.bbappend"
BBMASK_ARM .= "|recipes-kernel/linux/linux-yocto-cougarmountain%.bbappend"

BBMASK .= "|${@ '${BBMASK_ARM}' if d.getVar('CONFIG_ARM', True) == 'y' else '${BBMASK_ATOM}' }"
