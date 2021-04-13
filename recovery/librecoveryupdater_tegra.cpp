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

#include <algorithm>
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

// The L4T bootloader does not pass any android props, so the only way to check
// the bootloader version is to grep it directly from the partition.
#define CBOOT_PATH "/dev/block/by-name/EBT"

Value* CheckCbootVersion(const char* name, State* state,
                         const std::vector<std::unique_ptr<Expr>>& argv) {
    size_t argc = argv.size();
    if (argc != 1) {
        return ErrorAbort(state, kArgsParsingFailure,
                          "%s() expects 1 args, got %zu", name, argc);
    }

    std::vector<std::string> args;
    if (!ReadArgs(state, argv, &args)) {
        return ErrorAbort(state, kArgsParsingFailure,
                          "%s: could not parse the arguments.", name);
    }

    const std::string& bl_ver = args[0];

    std::ifstream file(CBOOT_PATH, std::ios::binary);
    if (!file.is_open()) {
        return ErrorAbort(state, kFileOpenFailure, "%s() could not open %s",
                          name, CBOOT_PATH);
    }

    file.seekg(0, std::ios::end);
    auto size = file.tellg();
    file.seekg(0);
    std::vector<char> cboot_bin(size, '\0');
    file.read(cboot_bin.data(), size);

    if (std::search(cboot_bin.begin(), cboot_bin.end(), bl_ver.begin(),
	            bl_ver.end()) !=
        cboot_bin.end()) {
        return StringValue("t");
    }

    return StringValue("");
}

void Register_librecoveryupdater_tegra() {
    RegisterFunction("tegra_get_dtbname", GetDTBName);
    RegisterFunction("tegra_check_cboot_version", CheckCbootVersion);
}
