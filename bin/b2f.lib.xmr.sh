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

b2f_xmr_api="https://monero.lindon-pool.win/api";
b2f_xmr_wallet="45YW94hFNeeiCdLYnEkzxxceeeooej4ypX8zjeWdgsKsSyoi3gZRWRVfRJAbUpTNpdPwURUDARjaK569fTPKHnbcKyRSnEu";

b2f_xmr_difficulty=0;

b2f_xmr_report() {
	local hashrate_network=$(curl "${b2f_xmr_api}/network/stats" 2> /dev/null | python -c "import sys, json; js=json.load(sys.stdin); print round(float(js['difficulty'])/120/1000/1000,2)");	
	local hashrate_pool=$(curl "${b2f_xmr_api}/pool/stats/pplns" 2> /dev/null | python -c "import sys, json; js=json.load(sys.stdin); print round(float(js['pool_statistics']['hashRate'])/1000,2)");
	
	local hashrate_me=$(curl "${b2f_xmr_api}/miner/${b2f_xmr_wallet}/stats/allWorkers" 2> /dev/null | python -c "import sys, json; js=json.load(sys.stdin); print round(float(js['global']['hash'])/1000,2)"  2> /dev/null);
	local round_hashes=$(curl "${b2f_xmr_api}/pool/stats/pplns" 2> /dev/null | python -c "import sys, json; js=json.load(sys.stdin); print js['pool_statistics']['roundHashes']");
	local difficulty=$(curl "${b2f_xmr_api}/network/stats" 2> /dev/null | python -c "import sys, json; js=json.load(sys.stdin); print js['difficulty']");	
	local effort=$(curl "${b2f_xmr_api}/network/stats" 2> /dev/null | python -c "import sys, json; js=json.load(sys.stdin); print round(float(${round_hashes})/float(js['difficulty'])*100,2)");
	local miners=$(curl "${b2f_xmr_api}/pool/stats/pplns" 2> /dev/null | python -c "import sys, json; js=json.load(sys.stdin); print js['pool_statistics']['miners']");
	
	
	if [ -z "$hashrate_me" ]; then
		hashrate_me="0.0";
	fi;

	b2f_term_log_pool "XMR" "${hashrate_network}" "${hashrate_pool}" "${hashrate_me}" "${difficulty}" "${effort}" "${miners}";

	b2f_xmr_difficulty=${difficulty};
};

b2f_xmr_block_check() {
	local block_current=$(curl "${b2f_xmr_api}/pool/stats/pplns" 2> /dev/null | python -c "import sys, json; js=json.load(sys.stdin); print js['pool_statistics']['lastBlockFound']");

	b2f_report_block "xmr" "${block_current}";
};