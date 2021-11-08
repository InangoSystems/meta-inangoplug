#!/bin/sh
################################################################################
#
#  Copyright 2021 Inango Systems Ltd.
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#
################################################################################

OVS_HARDWARE_ID=

set_hardware_id () {
    PLATFORM=""
    ARCHITECTURE=`uname -m`
    CHIP=`grep -m1 "model name" /proc/cpuinfo | cut -d ':' -f 2 | sed -e 's/^[[:space:]]*//' | cut -d ' ' -f 4`
    RAM=`free | grep "Mem:" | cut -d ':' -f 2 | sed -e 's/^[[:space:]]*//' | cut -d ' ' -f 1`
    WIFI="w+"
    SDK=`grep "SDK_VERSION" /version.txt | sed -e 's/SDK_VERSION=//'`
    MODE="DOCSIS/Ethernet"

    local BOX_TYPE=`grep "BOX_TYPE" /etc/device.properties | sed -e 's/BOX_TYPE=//'`
    local MODEL_NUM=`grep "MODEL_NUM" /etc/device.properties | sed -e 's/MODEL_NUM=//'`

    case "${BOX_TYPE}" in

     "PUMA7_CGP")
        PLATFORM="Puma7_CGP"
        ;;

     "XB6")
        if [ "${MODEL_NUM}" = "INTEL_PUMA" ]; then
            PLATFORM="Puma7_CGR"
        elif [ "${MODEL_NUM}" = "TG4482A" ]; then
            PLATFORM="Puma7_XB7"
        elif [ "${MODEL_NUM}" = "TG3482G" ]; then
            PLATFORM="Puma7_XB6"
        else
            PLATFORM="Puma7_${MODEL_NUM}"
        fi
        ;;

      *)
        PLATFORM="${BOX_TYPE}_${MODEL_NUM}"
        ;;
    esac

    if [ "${RAM}" -le 262144 ]; then
        RAM="256M"
    elif [ "${RAM}" -le 524288 ]; then
        RAM="512M"
    else
        RAM="1G"
    fi

    bin_one="$(echo -n -e '\01')"
    elf_endiannes_bit="$(dd if=/bin/bash count=1 bs=1 skip=5)"
    if [ "${bin_one}" = "${elf_endiannes_bit}" ] ; then
        ENDIANNESS="le"
    else
        ENDIANNESS="be"
    fi

    echo "${PLATFORM}_${ARCHITECTURE}_${ENDIANNESS}_${CHIP}_${RAM}_${WIFI}_${SDK}_${MODE}"
}

OVS_HARDWARE_ID=$(set_hardware_id)
