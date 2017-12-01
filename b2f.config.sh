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

# Ваши кошельки
b2f_email_wallet="viktor@tatarnikov.org";
b2f_xmr_wallet="45YW94hFNeeiCdLYnEkzxxceeeooej4ypX8zjeWdgsKsSyoi3gZRWRVfRJAbUpTNpdPwURUDARjaK569fTPKHnbcKyRSnEu";
b2f_sumo_wallet="Sumoo2SeKjvBH8GsjixxSx9HghG6iqht4YqMYTy6qKwaDwPivoCQ5gYdYPBamdrvdGPYUEDpALTTVak9xSi6aS7k4E8sSinQsGi";
b2f_etn_wallet="etnjxN1SYpx9fenXGifLvEjJLAMYkiMgKMJ4qn2ta2SbWvjqAertzDGXHESJFWpYLNF4XbJZ85HvmhAETc4VXitL26NyScANak";

# Адреса с проксисерверами
b2f_proxy_api_cpu="http://10.19.2.83:5557";
b2f_proxy_api_gpu="http://10.19.2.83:5567";

# Настройки автоматики
b2f_change_default="etn";						# Дефолтная монета
b2f_change_target="sumo";						# Интересуемая монета

b2f_change_target_delay=60;		 				# Время выжидания, если сложность вернется к высоким значениям
b2f_change_target_difficulty_min=1000000000;	# Минимальная сложность на которой возвращаться на пул
b2f_change_target_difficulty_max=1400000000;	# Максимальная сложность после которой сваливать с пула

b2f_change_target_difficulty=0;

# Настройки отчета
b2f_report_phones="+79609878224"
