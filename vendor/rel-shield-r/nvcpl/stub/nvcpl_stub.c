/*
 * Copyright (C) 2024 Thomas Makin
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

#include <stdint.h>
#include <cutils/properties.h>

int NvCplGetAppProfileSettingBool(char *pkgName, int32_t settingId, bool *out) {
    return 2;
}

int NvCplGetAppProfileSettingInt(char *pkgName, int32_t settingId, int32_t *out) {
    return 2;
}

int NvCplGetAppProfileSettingString(char *pkgName, int32_t settingId, char *out, int32_t len) {
    return 2;
}

int NvCplGetAppProfileSettingStringLength(char *pkgName, int32_t settingId, int32_t *out) {
    return 2;
}

uint64_t NvCplGetOpenGlAppProfileSettingInt(char *pkgName, char *setting, int32_t *out) {
    return 2;
}

uint64_t NvCplGetOpenGlAppProfileSettingString
          (char *pkgName, char *settingId, char *out, int32_t len) {
    return 2;
}

uint64_t NvCplGetOpenGlAppProfileSettingStringLength(char *pkgName, char *setting, int32_t *out) {
    *out = 0;
    return 2;
}

int32_t NvToolsApiCommonSetProperty(char *prop, char *value) {
    return property_set(prop, value);
}

int32_t NvToolsApiCommonSetSysProperty(char *prop, char *value) {
    return property_set(prop, value);
}
