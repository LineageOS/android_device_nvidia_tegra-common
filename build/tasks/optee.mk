# Copyright (C) 2025 The LineageOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

ifneq ($(TARGET_TEGRA_VERSION),)

OPTEE_BIN ?= $(call intermediates-dir-for,EXECUTABLES,optee)/arm-plat-tegra/core/tee.bin
OPTEE_RAW_BIN ?= $(call intermediates-dir-for,EXECUTABLES,optee)/arm-plat-tegra/core/tee-raw.bin
$(OPTEE_BIN): $(PRODUCT_OUT)/tianocore.bin

$(PRODUCT_OUT)/optee.bin: $(OPTEE_BIN)
	$(hide) cp $(OPTEE_RAW_BIN) $@

.PHONY: optee
optee: $(PRODUCT_OUT)/optee.bin

endif
