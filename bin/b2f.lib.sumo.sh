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

b2f_sumo_api="https://sumo.lindon-pool.win/api";
b2f_sumo_wallet="Sumoo2SeKjvBH8GsjixxSx9HghG6iqht4YqMYTy6qKwaDwPivoCQ5gYdYPBamdrvdGPYUEDpALTTVak9xSi6aS7k4E8sSinQsGi";

b2f_sumo_difficulty=0;

b2f_sumo_report() {
	local hashrate_network=$(curl --compressed "${b2f_sumo_api}/stats" 2> /dev/null | python -c "import sys, json; js=json.load(sys.stdin); print round(float(js['network']['difficulty'])/240/1000/1000,2)");	
	local hashrate_pool=$(curl "${b2f_sumo_api}/stats" 2> /dev/null | python -c "import sys, json; js=json.load(sys.stdin); print round(float(js['pool']['hashrate'])/1000,2)");
	local hashrate_me=$(curl "${b2f_sumo_api}/stats_address?address=${b2f_sumo_wallet}" 2> /dev/null | python -c "import sys, json; js=json.load(sys.stdin); print str(js['stats']['hashrate']).split(' ')[0]" 2> /dev/null);
	local effort=$(curl "${b2f_sumo_api}/stats" 2> /dev/null | python -c "import sys, json; js=json.load(sys.stdin); print round(float(js['pool']['roundHashes'])/float(js['network']['difficulty'])*100,2)");
	local difficulty=$(curl "${b2f_sumo_api}/stats" 2> /dev/null | python -c "import sys, json; js=json.load(sys.stdin); print js['network']['difficulty']");
	local miners=$(curl --compressed "${b2f_sumo_api}/stats" 2> /dev/null | python -c "import sys, json; js=json.load(sys.stdin); print js['pool']['miners']");
	
	if [ -z "$hashrate_me" ]; then
		hashrate_me="0.0";
	fi;
	
	b2f_term_log_pool "SUMO" "${hashrate_network}" "${hashrate_pool}" "${hashrate_me}" "${difficulty}" "${effort}" "${miners}";

	b2f_sumo_difficulty=${difficulty};
};

b2f_sumo_block_check() {
	local block_current=$(curl "${b2f_sumo_api}/stats" 2> /dev/null | python -c "import sys, json; js=json.load(sys.stdin); print js['pool']['blocks'][1]");
	
	b2f_report_block "sumo" "${block_current}";
};