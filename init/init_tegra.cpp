#define _REALLY_INCLUDE_SYS__SYSTEM_PROPERTIES_H_
#include <sys/_system_properties.h>
#include <android-base/properties.h>
#include <android-base/logging.h>

#include "init_tegra.h"
#include "init.h"
#include "vendor_init.h"
#include "property_service.h"
#include "util.h"

#include <unistd.h>

#include <fstream>
#include <sstream>

void property_override(char const prop[], char const value[])
{
    prop_info *pi;

    pi = (prop_info*) __system_property_find(prop);
    if (pi)
        __system_property_update(pi, value, strlen(value));
    else
        __system_property_add(prop, strlen(prop), value, strlen(value));
}

bool tegra_init::detect_model_override()
{
    std::string lmodel;

    std::ifstream file("/data/property/persist.lineage.tegra.model");
    if (getline(file, lmodel)) {
        for (auto & device : tegra_devices) {
            if (!device.name.compare(lmodel))
                chosen_device = &device;
        }
    }

    return chosen_device != NULL;
}

void tegra_init::detect_model_devicetree()
{
    std::string hardware = android::base::GetProperty("ro.hardware", "");

    for (auto & device : tegra_devices) {
        if (!device.name.compare(hardware)) {
            chosen_device = &device;
            break;
        }
    }
}

void tegra_init::detect_model_boardinfo()
{
    std::string line, boardinfo, temp;
    uint16_t board_id = -1, sku = -1;

    // Get model from /proc/cmdline
    std::ifstream file("/proc/cmdline");
    if (!file.is_open()) {
        LOG(ERROR) << "tegra_init: Could not open /proc/cmdline";
        return;
    }

    if (!std::getline(file, line)) {
        LOG(ERROR) << "tegra_init: /proc/cmdline is empty";
        return;
    }

    std::stringstream linestream(line);
    while (std::getline(linestream, boardinfo, ' ')) {
        if (boardinfo.find("board_info") != std::string::npos)
            break;
    }
    if (boardinfo.empty()) {
        LOG(WARNING) << "tegra_init: /proc/cmdline does not contain board_info";
        return;
    }

    boardinfo.erase(0, 11); // remove board_info= from the string
    std::stringstream bistream(boardinfo);
    if (!std::getline(bistream, temp, ':'))
        return;
    board_id = std::stoul(temp, nullptr, 16);

    if (!std::getline(bistream, temp, ':'))
        return;
    sku = std::stoul(temp, nullptr, 16);

    for (auto & device : tegra_devices) {
        if (board_id == device.board_id && sku == device.sku) {
            chosen_device = &device;
            break;
        }
    }
}

bool tegra_init::detect_model()
{
    // If no devices were passed, just bail
    if (!tegra_devices.size()) {
        LOG(ERROR) << "tegra_init: device list is empty, aborting";
        return false;
    }

    // If hardware name isn't set, attempt to read it from the device tree
    if (!android::base::GetProperty("ro.hardware", "unknown").compare("unknown")) {
        std::ifstream file("/proc/device-tree/firmware/android/hardware");
        std::string line;
        if (file.is_open() && std::getline(file, line)) {
            property_override("ro.hardware", line.c_str());
        }
    }

    // If only one device is defined, just use that one
    if (tegra_devices.size() == 1) {
        chosen_device = &tegra_devices[0];
        return true;
    }

    if (!detect_model_override()) {
        detect_model_boardinfo();

        if (!chosen_device)
            detect_model_devicetree();
    }

    return chosen_device != NULL;
}

void tegra_init::set_fingerprints(build_version fp_version)
{
    property_override("ro.build.fingerprint", ("NVIDIA/" + chosen_device->name + "/" +
                                               chosen_device->device + ":" +
                                               fp_version.android_version + "/" +
                                               fp_version.android_release + "/" +
                                               fp_version.nvidia_version +
                                               ":user/release-keys").c_str());
    property_override("ro.build.description", (chosen_device->name + "-user " +
                                               fp_version.android_version + " " +
                                               fp_version.android_release + " " +
                                               fp_version.nvidia_version +
                                               " release-keys").c_str());
    property_override("ro.vendor.build.fingerprint", ("NVIDIA/" + chosen_device->name + "/" +
                                                      chosen_device->device + ":" +
                                                      fp_version.android_version + "/" +
                                                      fp_version.android_release + "/" +
                                                      fp_version.nvidia_version +
                                                      ":user/release-keys").c_str());
    property_override("ro.vendor.build.description", (chosen_device->name + "-user " +
                                                      fp_version.android_version + " " +
                                                      fp_version.android_release + " " +
                                                      fp_version.nvidia_version +
                                                      " release-keys").c_str());
}

void tegra_init::recovery_links(std::vector<std::string> parts)
{
    std::string int_path;

    switch (chosen_device->boot_dev) {
        case boot_dev_type::EMMC:
            symlink("/etc/twrp.fstab.emmc", "/etc/twrp.fstab");
	    int_path = "sdhci-tegra.3";
	    break;

	case boot_dev_type::SATA:
            symlink("/etc/twrp.fstab.sata", "/etc/twrp.fstab");
	    int_path = "tegra-sata.0";
	    break;
    }

    // Symlink paths for unified ROM installs.
    for(auto const& part: parts)
        symlink(("/dev/block/platform/" + int_path + "/by-name/" + part).c_str(), ("/dev/block/" + part).c_str());
}

void tegra_init::set_properties()
{
    if (!detect_model()) {
        LOG(ERROR) << "tegra_init: could not detect model, aborting";
        return;
    }

    LOG(ERROR) << "tegra_init: found model " << chosen_device->name;

    android::init::property_set("ro.product.first_api_level", std::to_string(chosen_device->first_api).c_str());

    if (chosen_device->dpi)
        android::init::property_set("ro.sf.lcd_density", std::to_string(chosen_device->dpi).c_str());

    property_override("ro.product.name",   chosen_device->name.c_str());
    property_override("ro.build.product",  chosen_device->device.c_str());
    property_override("ro.product.device", chosen_device->device.c_str());
    property_override("ro.product.model",  chosen_device->model.c_str());

    property_override("ro.vendor.product.name",   chosen_device->name.c_str());
    property_override("ro.vendor.build.product",  chosen_device->device.c_str());
    property_override("ro.vendor.product.device", chosen_device->device.c_str());
    property_override("ro.vendor.product.model",  chosen_device->model.c_str());
}

bool tegra_init::is_model(std::string name)
{
	return !name.compare(chosen_device->name);
}

bool tegra_init::is_model(uint16_t board_id, uint16_t sku)
{
	return (board_id == chosen_device->board_id &&
	        sku == chosen_device->sku);
}

void tegra_init::property_set(std::string key, std::string value)
{
    property_override(key.c_str(), value.c_str());
}
