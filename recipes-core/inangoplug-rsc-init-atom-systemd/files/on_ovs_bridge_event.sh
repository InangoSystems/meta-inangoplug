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

bridge_added=$1
bridge_name=$2

get_rsc_server_port()
{
    # TODO: when vscfg utility will be done, here we will add vscfg command
    # to get rsc-server port parameter
    echo 50001
}

get_rsc_proxy_port()
{
    # TODO: when vscfg utility will be done, here we will add vscfg command
    # to get rsc-proxy port parameter
    echo 50002
}

main()
{
    local rsc_port="$(get_rsc_server_port)"
    local tcp_port="$(get_rsc_proxy_port)"

    if [ -z "$bridge_added" -o -z "$bridge_name" ]; then
        echo "Empty argument passed to a script $0. Exiting"
        return 1
    fi

    if [ "${bridge_added}" = "true" ]; then
        echo "port=${rsc_port}" > /tmp/rsc-server_${bridge_name}.conf
        echo "port=${tcp_port}" > /tmp/rsc-proxy_${bridge_name}.conf
        systemctl start rsc-init@${bridge_name}.service

        sysevent setunique GeneralPurposeFirewallRule " -A INPUT -i ${bridge_name} -p tcp --dport=${rsc_port} -j ACCEPT "
        sysevent set firewall-restart

        ovs-vsctl set Bridge ${bridge_name} other-config:list-port-protection=tcp:${rsc_port},tcp:${tcp_port};
        ovs-vsctl set Bridge ${bridge_name} other-config:enable-port-protection=true;
        ovs-vsctl set Bridge ${bridge_name} fail-mode=secure

        ovs-ofctl -O OpenFlow13 add-flow ${bridge_name} "table=0, priority=0, actions=NORMAL"
    else
        rm /tmp/rsc-server_${bridge_name}.conf /tmp/rsc-proxy_${bridge_name}.conf
        systemctl stop rsc-init@${bridge_name}.service

        sysevent setunique GeneralPurposeFirewallRule " -D INPUT -i ${bridge_name} -p tcp --dport=${rsc_port} -j ACCEPT "
        sysevent set firewall-restart
    fi
}

main
