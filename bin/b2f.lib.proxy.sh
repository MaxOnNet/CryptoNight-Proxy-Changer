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

b2f_proxy_change_auto_lock="${path}/var/lock/change_auto.disable"

b2f_proxy_api_cpu="http://10.19.2.83:5557";
b2f_proxy_api_gpu="http://10.19.2.83:5567";

b2f_proxy_change_auto_lock_set() {
	b2f_term_log "good" "Установка перманентной логики.";
	
	touch ${b2f_proxy_change_auto_lock};
};

b2f_proxy_change_auto_lock_unset() {
	b2f_term_log "good" "Установка автоматической логики.";
	
	rm -f ${b2f_proxy_change_auto_lock};
};


b2f_proxy_report() {
	local miners_cpu=$(curl "${b2f_proxy_api_cpu}" 2> /dev/null | python -c "import sys, json; js=json.load(sys.stdin); print js['miners']['now']");
	local miners_gpu=$(curl "${b2f_proxy_api_gpu}" 2> /dev/null | python -c "import sys, json; js=json.load(sys.stdin); print js['miners']['now']");
	local miners_gpu_l=$(curl "${b2f_proxy_api_cpu}/workers.json" 2> /dev/null | python -c "import sys, json; js=json.load(sys.stdin); workers = [ worker[0] for worker in js['workers'] if worker[0] != '' ]; print ' '.join(workers)");
	local miners_cpu_l=$(curl "${b2f_proxy_api_gpu}/workers.json" 2> /dev/null | python -c "import sys, json; js=json.load(sys.stdin); workers = [ worker[0] for worker in js['workers'] if worker[0] != '' ]; print ' '.join(workers)");
	
	echo "Miners GPU [ ${esc_color_green}${miners_gpu}${esc_normal} ]: ${esc_color_green}${miners_gpu_l}${esc_normal}";
	echo "Miners CPU [ ${esc_color_green}${miners_cpu}${esc_normal} ]: ${esc_color_green}${miners_cpu_l}${esc_normal}";

};

b2f_proxy_activate() {
	local b2f_coin=$1
	
	b2f_term_log "good" "Смена назначения на ${b2f_coin}.";
	
	if [[ -f "${path}/proxy.configs/config.${b2f_coin}.lindon.cpu.json"  &&  -f "${path}/proxy.configs/config.${b2f_coin}.lindon.gpu.json" ]]; then
		for b2f_type in cpu gpu; do
			rm "${path}/config-${b2f_type}.json";
			ln -s "${path}/proxy.configs/config.${b2f_coin}.lindon.${b2f_type}.json" "${path}/config-${b2f_type}.json";

			b2f_term_log "warning" "Перезапуск xmr-proxy-${b2f_type}.";
			systemctl restart "xmr-proxy-${b2f_type}";
		done;
	else
		b2f_term_log "error" "Смена назначения на ${b2f_coin} невозможна, конфиги не найдены.";
	fi;
};
