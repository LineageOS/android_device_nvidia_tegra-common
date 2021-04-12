/*
 * Copyright (C) 2021 The LineageOS Project
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

#include "edify/expr.h"
#include "otautil/error_code.h"

#include <fstream>

#define DTSFN_PATH "/proc/device-tree/nvidia,dtsfilename"

Value* GetDTBName(const char* name, State* state,
                  const std::vector<std::unique_ptr<Expr>>& argv) {
    size_t argc = argv.size();
    if (argc != 0) {
        return ErrorAbort(state, kArgsParsingFailure,
                          "%s() expects 0 args, got %zu", name, argc);
    }

    std::ifstream file(DTSFN_PATH);
    if (!file.is_open()) {
        return ErrorAbort(state, kFileOpenFailure, "%s() could not open %s",
                          name, DTSFN_PATH);
    }

    std::string line;
    if (!std::getline(file, line)) {
        return ErrorAbort(state, kFreadFailure, "%s() could not read empty %s",
                          name, DTSFN_PATH);
    }

    size_t last_slash = line.rfind("/");
    if (last_slash != std::string::npos) {
        std::string name = line.substr(last_slash + 1);
        return StringValue(name.replace(name.find(".dts"), 4, ".dtb"));
    }

    return ErrorAbort(state, kFreadFailure, "%s() could not parse %s",
                      name, DTSFN_PATH);
}

void Register_librecoveryupdater_tegra() {
    RegisterFunction("tegra_get_dtbname", GetDTBName);
}
