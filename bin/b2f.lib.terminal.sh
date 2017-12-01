#!/bin/sh
#   /bin/b2f.lib.terminal.sh

# -*- coding: utf-8 -*-
#
# Copyright [2017] Tatarnikov Viktor [viktor@tatarnikov.org]
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

esc=`echo -en "\033"`;

esc_color_white="${esc}[1;37m";
esc_color_green="${esc}[1;32m";
esc_color_yellow="${esc}[1;33m";
esc_color_red="${esc}[1;31m";

esc_position=`echo -en "\015"`
esc_position_1="${esc_position}${esc}[1C${esc}[0D";
esc_position_10="${esc_position}${esc}[10C${esc}[0D";
esc_position_12="${esc_position}${esc}[12C${esc}[0D";
esc_position_16="${esc_position}${esc}[16C${esc}[0D";
esc_position_18="${esc_position}${esc}[18C${esc}[0D";


esc_normal=`echo -en "\033[m\017"`;


b2f_term_log_pool() {
	local currency="$1"
	local hasrate_network="$2";
	local hasrate_pool="$3";
	local hasrate_me="$4";

	local difficulty="$5";
	local effort="$6";
	local miners="$7";
	
	echo -n "${esc_position}${esc}[1C${esc}[0D${currency}${esc_normal}";
	echo -n "${esc_position}${esc}[6C${esc}[0D${esc_color_red}${hasrate_network}${esc_normal} ${esc_position}${esc}[13C${esc}[0DMH/s${esc_normal}";
	echo -n "${esc_position}${esc}[18C${esc}[0D${esc_color_yellow}${hasrate_pool}${esc_normal}  ${esc_position}${esc}[25C${esc}[0DKH/s${esc_normal}";
	echo -n "${esc_position}${esc}[30C${esc}[0D${esc_color_green}${hasrate_me}${esc_normal} 	${esc_position}${esc}[36C${esc}[0DKH/s${esc_normal}";
	echo -n "${esc_position}${esc}[41C${esc}[0DDifficulty: ${esc_color_yellow}${difficulty}${esc_normal}";
	echo -n "${esc_position}${esc}[65C${esc}[0DEffort: ${esc_color_yellow}${effort}${esc_normal}";
	echo -n "${esc_position}${esc}[80C${esc}[0DMiners: ${esc_color_green}${miners}${esc_normal}";
	echo;
}



#
#    Logger
#
b2f_term_log() {
    if [ "${b2f_log_type}" = "quiet" ]; then
        return 0;
    fi;

    local message="$2";
    local message_type="$1";
    local message_date="`date +%H:%M:%S`";

    echo -n "${esc_position_1}${esc_color_white}[${esc_normal}${esc_color_white}${message_date}${esc_normal}${esc_position_10}${esc_color_white}]${esc_normal}";

    case "${message_type}" in
        "normal")
            echo -n "${esc_position_12}${esc_color_white}${message}${esc_normal}";
        ;;
        "good")
            echo -n "${esc_position_12}${esc_color_green}${message}${esc_normal}";
        ;;
        "warning")
            echo -n "${esc_position_12}${esc_color_yellow}${message}${esc_normal}";
        ;;
        "error")
            echo -n "${esc_position_12}${esc_color_red}${message}${esc_normal}";
        ;;
    esac;

    echo ""
}

b2f_term_log_live() {
    if [ "${b2f_log_type}" = "quiet" ]; then
        return 0;
    fi;

    local message_size_max="$[100-17]";
    local message="${2}";
    local message_type="$1";

    while [ "${#message}" -le ${message_size_max} ]; do
        message="${message} ";
    done;

    case "${message_type}" in
        "normal")
            echo -n "${esc_position_16}${esc_color_white}${message}${esc_position_16}${esc_normal}";
        ;;
        "good")
            echo -n "${esc_position_16}${esc_color_green}${message}${esc_position_16}${esc_normal}";
        ;;
        "warning")
            echo -n "${esc_position_16}${esc_color_yellow}${message}${esc_position_16}${esc_normal}";
        ;;
        "error")
            echo -n "${esc_position_16}${esc_color_red}${message}${esc_position_16}${esc_normal}";
        ;;
    esac;

    export b2f_log_live_wait_step="0";
};

b2f_term_log_live_wait() {
    if [ "${b2f_log_type}" = "quiet" ]; then
        return 0;
    fi;

    case ${b2f_log_live_wait_step} in
        "0")
            export b2f_log_live_wait_step="1";
            echo -n "${esc_position_12}${esc_color_green}[-]${esc_normal}";
        ;;
        "1")
            export b2f_log_live_wait_step="2";
            echo -n "${esc_position_12}${esc_color_green}[\]${esc_normal}";
        ;;
        "2")
            export b2f_log_live_wait_step="3";
            echo -n "${esc_position_12}${esc_color_green}[|]${esc_normal}";
        ;;
        "3")
            export b2f_log_live_wait_step="0";
            echo -n "${esc_position_12}${esc_color_green}[/]${esc_normal}";
        ;;
    esac;
};

b2f_term_log_live_end() {
    if [ "${b2f_log_type}" = "quiet" ]; then
        return 0;
    fi;

    unset b2f_log_live_wait_step;
    echo "";
};

