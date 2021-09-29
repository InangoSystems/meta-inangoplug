#
# If not stated otherwise in this file or this component's Licenses.txt file the
# following copyright and licenses apply:
#
# Copyright 2017 RDK Management
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

#
# Includes Inango Systems Ltd's changes/modifications dated: 2021.
# Changed/modified portions - Copyright (c) 2021, Inango Systems Ltd.
#
SUMMARY = "inangoplug-mngm"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=34f8c1142fd6208a8be89399cb521df9"

DEPENDS = "ccsp-common-library dbus openssl hal-cm hal-dhcpv4c hal-ethsw hal-moca hal-mso_mgmt hal-mta hal-platform hal-vlan util-linux utopia cjson"
DEPENDS_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'safec', ' safec', " ", d)}"

RDEPENDS_${PN}_append = " util-linux-lscpu"

SRC_URI = "${INANGOPLUG_SRC_URI}"
SRCREV="${INANGOPLUG_SRCREV}"
S = "${WORKDIR}/git"

inherit autotools pkgconfig systemd

CFLAGS_append_dunfell = " -Wno-restrict -Wno-format-overflow -Wno-deprecated-declarations -Wno-cast-function-type "

LDFLAGS +=" -lsyscfg"
LDFLAGS_remove_dunfell = "${@bb.utils.contains('DISTRO_FEATURES', 'safec', '-lsafec-3.5', '', d)}"
LDFLAGS_append = "${@bb.utils.contains('DISTRO_FEATURES', 'safec dunfell', ' -lsafec-3.5.1 ', '', d)}"
CFLAGS_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'safec',  ' `pkg-config --cflags libsafec`', '-fPIC', d)}"
CFLAGS_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'safec', '', ' -DSAFEC_DUMMY_API', d)}"
LDFLAGS_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'safec', ' `pkg-config --libs libsafec`', '', d)}"

CFLAGS_append = " \
    -I=${includedir}/dbus-1.0 \
    -I=${libdir}/dbus-1.0/include \
    -I=${includedir}/ccsp \
    -I=${includedir}/syscfg \
    -I${STAGING_INCDIR}/syscfg \
    "
LDFLAGS_append = " \
    -ldbus-1 \
    -lccsp_common \
    "
do_install_append () {
    # Config files and scripts
    install -d ${D}${exec_prefix}/ccsp/inangoplugcomponent
    install -m 644 ${S}/config/TR-181-InangoplugComponent.xml ${D}${exec_prefix}/ccsp/inangoplugcomponent/TR-181-InangoplugComponent.xml
    install -d ${D}${sysconfdir}/inangoplug
    install -m 644 ${S}/config/inangoplug.cfg ${D}${sysconfdir}/inangoplug/inangoplug.cfg

    # Set paths for Private Key, Certificate and CA Certificate
    sed -i -e 's#CONFIG_INANGO_INANGOPLUG_SSL_DIR=#CONFIG_INANGO_INANGOPLUG_SSL_DIR=${CONFIG_INANGO_INANGOPLUG_SSL_DIR}#' ${D}${sysconfdir}/inangoplug/inangoplug.cfg

    install -d ${D}${systemd_unitdir}/system
    install -D -m 0644 ${S}/scripts/CcspInangoplugComponent.service ${D}${systemd_unitdir}/system/CcspInangoplugComponent.service
    install -m 0644 ${S}/scripts/check_inangoplug_enabled.service ${D}${systemd_unitdir}/system/check_inangoplug_enabled.service
    install -m 0644 ${S}/scripts/connect_inangoplug.service ${D}${systemd_unitdir}/system/connect_inangoplug.service
    install -d ${D}${sysconfdir}/scripts
    install -m 0755 ${S}/scripts/run_inangoplug.sh ${D}${sysconfdir}/scripts/run_inangoplug.sh
    install -m 0755 ${S}/scripts/connect_inangoplug.sh ${D}${sysconfdir}/scripts/connect_inangoplug.sh
}

SYSTEMD_SERVICE_${PN} += "CcspInangoplugComponent.service \
                          check_inangoplug_enabled.service \
                          connect_inangoplug.service \
                         "

FILES_${PN} += " \
    ${exec_prefix}/ccsp/inangoplugcomponent \
"
