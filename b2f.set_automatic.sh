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

b2f_proxy_change_auto_lock_unset;