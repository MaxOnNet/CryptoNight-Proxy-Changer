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

b2f_zec_api="https://z.lindon-pool.win/api";
b2f_zec_wallet="t1N4vAMypKz75Z97snhVBYbxUYjTasXLU4c";

b2f_zec_difficulty=0;

b2f_zec_report() {
	local hashrate_network=$(curl "${b2f_zec_api}/stats" 2> /dev/null | python -c "import sys, json; js=json.load(sys.stdin); print round(float(js['pools']['zcash']['poolStats']['networkSols'])/1000/1000,2)");
	local hashrate_pool=$(curl "${b2f_zec_api}/stats" 2> /dev/null | python -c "import sys, json; js=json.load(sys.stdin); print round(float(js['algos']['equihash']['hashrate'])*2/1000/1000/1000,2)");
	
	local hashrate_me=$(curl "${b2f_zec_api}/stats" 2> /dev/null | python -c "import sys, json; js=json.load(sys.stdin); print js['pools']['zcash']['workers']['${b2f_zec_wallet}']['hashrateString']"  2> /dev/null);
	local difficulty="";
	local effort="";
	local miners=$(curl "${b2f_zec_api}/stats" 2> /dev/null | python -c "import sys, json; js=json.load(sys.stdin); print js['algos']['equihash']['workers']");
	
	if [ -z "$hashrate_me" ]; then
		hashrate_me="0.0";
	fi;

	b2f_term_log_pool "ZEC" "${hashrate_network}" "${hashrate_pool}" "${hashrate_me}" "${difficulty}" "${effort}" "${miners}";

};

b2f_zec_block_check() {
	return 0
	local block_current=$(curl "${b2f_zec_api}/pool/stats/pplns" 2> /dev/null | python -c "import sys, json; js=json.load(sys.stdin); print js['pool_statistics']['lastBlockFound']");

	b2f_report_block "zec" "${block_current}";
};