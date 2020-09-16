/*
 * Copyright (C) 2020 The LineageOS Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include <healthd/healthd.h>
#include <health2/service.h>

void healthd_board_init(struct healthd_config*) {
}

int healthd_board_battery_update(struct android::BatteryProperties* props) {
    props->chargerAcOnline = true;
    props->chargerUsbOnline = false;
    props->chargerWirelessOnline = false;
    props->batteryStatus = android::BATTERY_STATUS_UNKNOWN;
    props->batteryHealth = android::BATTERY_HEALTH_UNKNOWN;
    props->batteryPresent = false;
    props->batteryLevel = 100;
    return 1;
}

int main() {
    return health_service_main();
}
