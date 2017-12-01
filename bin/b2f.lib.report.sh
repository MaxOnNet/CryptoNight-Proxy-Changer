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


b2f_report_block() {
	local report_currency="$1";
	local report_block="$2"
	local report_messadge="YEP! We found block in ${report_currency} № ${block_current}!";

	local report_spool="${path}/var/${report_currency}.lindon/blocks";
	local report_phone="";
	
	if [ -n "${report_currency}" ]; then
		if [ -n "${report_block}" ]; then
			mkdir -p "${report_spool}";
			
			if [ ! -f "${report_spool}/${report_block}" ]; then
				touch "${report_spool}/${report_block}";
				b2f_term_log "good" "${report_messadge}";
				
				if [ -n "${b2f_report_phones}" ]; then
					for report_phone in ${b2f_report_phones}; do
						sleep 5;
						screen -dmS sms_sender ssh '10.19.2.17' -C /usr/sbin/asterisk -rx \"dongle sms dongle0 ${report_phone} ${report_messadge}\";
					done;
				fi;
			fi;
		fi;
	fi;
};
