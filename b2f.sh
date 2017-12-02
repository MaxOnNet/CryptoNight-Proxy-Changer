#!/bin/sh
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

path="/home/xmr-proxy";
mode="$1";

if [ -z "${mode}" ]; then
	mode="single"
elif [ "${mode}" != "loop" ]; then
	mode="single";
fi;

cd "${path}";

. "${path}/bin/b2f.lib.terminal.sh" || exit 1;
. "${path}/bin/b2f.lib.report.sh"   || exit 1;
. "${path}/bin/b2f.lib.proxy.sh" 	|| exit 1;
. "${path}/bin/b2f.lib.sumo.sh"  	|| exit 1;
. "${path}/bin/b2f.lib.xmr.sh"   	|| exit 1;
. "${path}/bin/b2f.lib.etn.sh"   	|| exit 1;
. "${path}/bin/b2f.lib.zec.sh"   	|| exit 1;

# Загрузка конфигурационного файла
. "${path}/b2f.config.sh"			|| exit 1;

b2f_term_log "good" "Cryptonight Proxy Changer by MaxOnNet.";

main_loop() {
	# Check now block
	b2f_zec_block_check;
	b2f_etn_block_check;
	b2f_sumo_block_check;
	b2f_xmr_block_check;
	
	b2f_current_coin=$(basename $(readlink "${path}/config-cpu.json") | awk -F\. '{ print $2}');
	
	b2f_term_log "normal" "Сейчас $(date).";
	b2f_term_log "normal" "Текушее направление для ${esc_color_green}${b2f_current_coin}${esc_normal}.";
	
	b2f_proxy_report;
	
	b2f_zec_report;
	b2f_etn_report;
	b2f_sumo_report;
	b2f_xmr_report;
	
	# Logic
	if [ ! -f "${b2f_proxy_change_auto_lock}" ]; then
		
		case "${b2f_change_target}" in
	        "sumo")
	            b2f_change_target_difficulty=${b2f_sumo_difficulty};
	        ;;
	        "etn")
	            b2f_change_target_difficulty=${b2f_etn_difficulty};
	        ;;
	        "xmr")
	            b2f_change_target_difficulty=${b2f_xmr_difficulty};
	        ;;
		esac;
		
		b2f_term_log "normal" "Logic: target ${esc_color_green}${b2f_change_target}${esc_normal}, default ${esc_color_green}${b2f_change_default}${esc_normal}, diff_current ${esc_color_green}${b2f_change_target_difficulty}${esc_normal} diff_min ${esc_color_red}${b2f_change_target_difficulty_min}${esc_normal}, diff_max ${esc_color_red}${b2f_change_target_difficulty_max}${esc_normal}";
		
		# ${b2f_change_target_difficulty} > ${b2f_change_target_difficulty_max}
		if [ ${b2f_change_target_difficulty} -gt ${b2f_change_target_difficulty_max} ]; then
		    if [ ! "${b2f_current_coin}" = "${b2f_change_target}" ]; then
				b2f_term_log "normal" "1: Остаемся на ${esc_color_green}${b2f_change_default}${esc_normal}.";
		    else
				b2f_proxy_activate "${b2f_change_default}";
		    fi;
		    
		    return;
		fi;
		
		# ${b2f_change_target_difficulty} < ${b2f_change_target_difficulty_max}
		if [ ${b2f_change_target_difficulty} -lt ${b2f_change_target_difficulty_min} ]; then
		    if [ "${b2f_current_coin}" = "${b2f_change_target}" ]; then
				b2f_term_log "normal" "2: Остаемся на ${esc_color_green}${b2f_change_target}${esc_normal}.";
		    else
		    
				b2f_proxy_activate "${b2f_change_target}";
		    fi;
		    
		    return;
		fi;
		
		if [ ! "${b2f_current_coin}" = "${b2f_change_target}" ]; then
		    b2f_proxy_activate "${b2f_change_target}";
		else
		    b2f_term_log "normal" "3: Остаемся на ${esc_color_green}${b2f_change_default}${esc_normal}.";
		fi;
	else
		b2f_term_log "normal" "Автоматическое переключение ${esc_color_red}отключено${esc_normal}."
	fi;
};

while true; do
	echo " ";
	main_loop;
	echo " ";
	
	if [ "${mode}" != "loop" ]; then
		exit 0;
	fi;	
	sleep 30;
done;
