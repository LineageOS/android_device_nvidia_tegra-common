# Copyright (C) 2020 The LineageOS Project
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

PRODUCT_PACKAGES += \
    audio.primary.tegra \
    android.hardware.soundtrigger@2.1-impl \
    sound_trigger.primary.tegra \
    NvAudioSvc

ifneq ($(TARGET_TEGRA_DOLBY),)
PRODUCT_PACKAGES += \
    android.hardware.audio@6.0-service-msd \
    DolbyAudioService
endif

ifeq ($(TARGET_TEGRA_APTX),true)
ifeq ($(TARGET_ARCH),arm)
$(error AptX on Armv7 is not supported)
endif

PRODUCT_PACKAGES += \
    libaptX_encoder \
    libaptXHD_encoder
endif
