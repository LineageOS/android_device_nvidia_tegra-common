#define _REALLY_INCLUDE_SYS__SYSTEM_PROPERTIES_H_
#include <sys/_system_properties.h>
#include <android-base/properties.h>
#include <android-base/logging.h>

#include "init_tegra.h"
#include "vendor_init.h"

#include <byteswap.h>
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
    std::string hardware = property_get("ro.hardware");

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
    bool bi_found = false;
    uint32_t board_id = -1, sku = -1;
    std::ifstream cvmfile;

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
        if (boardinfo.find("board_info") != std::string::npos) {
            bi_found = true;
            break;
        }
    }
    if (bi_found) {
        boardinfo.erase(0, 11); // remove board_info= from the string
        std::stringstream bistream(boardinfo);
        if (!std::getline(bistream, temp, ':'))
            return;
        board_id = std::stoul(temp, nullptr, 16);

        if (!std::getline(bistream, temp, ':'))
            return;
        sku = std::stoul(temp, nullptr, 16);
    } else if (cvmfile.open("/proc/device-tree/chosen/plugin-manager/cvm"), cvmfile.is_open()) {
        if (!std::getline(cvmfile, temp, '-'))
            return;
        board_id = std::stoul(temp, nullptr, 10);

        if (!std::getline(cvmfile, temp, '-'))
            return;
        sku = std::stoul(temp, nullptr, 10);
    } else {
        std::ifstream idfile("/proc/device-tree/chosen/proc-board/id", std::ios::binary);
        std::ifstream skufile("/proc/device-tree/chosen/proc-board/sku", std::ios::binary);
        if (!idfile.is_open() || !skufile.is_open()) {
            LOG(WARNING) << "tegra_init: Neither /proc/cmdline nor fdt contain board_info";
            return;
        }
        idfile.read((char*)&board_id, sizeof(board_id));
        skufile.read((char*)&sku, sizeof(sku));
        board_id = bswap_32(board_id);
        sku = bswap_32(sku);
    }

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
    if (property_get("ro.hardware").empty()) {
        std::ifstream file("/proc/device-tree/firmware/android/hardware");
        std::string line;
        if (file.is_open() && std::getline(file, line)) {
            property_set("ro.hardware", line);
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
    property_set("ro.build.fingerprint", ("NVIDIA/" + chosen_device->name + "/" +
                                          chosen_device->device + ":" +
                                          fp_version.android_version + "/" +
                                          fp_version.android_release + "/" +
                                          fp_version.nvidia_version +
                                          ":user/release-keys").c_str());
    property_set("ro.build.description", (chosen_device->name + "-user " +
                                          fp_version.android_version + " " +
                                          fp_version.android_release + " " +
                                          fp_version.nvidia_version +
                                          " release-keys").c_str());
}

void tegra_init::make_symlinks(std::map<std::string,std::string> paths)
{
    for(auto const& [key, value]: paths)
        symlink(key.c_str(), value.c_str());
}

void tegra_init::recovery_links(std::map<std::string,std::string> parts)
{
    std::string int_path;

    if (chosen_device == NULL) return;

    switch (chosen_device->boot_dev) {
        case boot_dev_type::EMMC:
            symlink("/etc/twrp.fstab.emmc", "/etc/twrp.fstab");
	    int_path = "sdhci-tegra.3";
	    break;

	case boot_dev_type::SATA:
            symlink("/etc/twrp.fstab.sata", "/etc/twrp.fstab");
	    int_path = "tegra-sata.0";
	    break;

        case boot_dev_type::SD:
            symlink("/etc/twrp.fstab.sd", "/etc/twrp.fstab");
	    int_path = "sdhci-tegra.0";
	    break;
    }

    // Symlink paths for unified ROM installs.
    for(auto const& [key, value]: parts)
        symlink(("/dev/block/platform/" + int_path + "/by-name/" + key).c_str(), ("/dev/block/" + value).c_str());
}

void tegra_init::recovery_links(std::vector<std::string> parts)
{
    std::map<std::string,std::string> new_parts;

    for(auto const& part: parts)
        new_parts.emplace(part, part);

    recovery_links(new_parts);
}

void tegra_init::set_properties()
{
    if (chosen_device == NULL) return;

    // Google manadates internal res 1920x1080 at 320 dpi for atv
    if (property_get("ro.build.characteristics") == "tv")
        property_set("ro.sf.lcd_density", "320");
    else if (chosen_device->dpi)
        property_set("ro.sf.lcd_density", std::to_string(chosen_device->dpi));

    property_set("ro.product.name",   chosen_device->name);
    property_set("ro.build.product",  chosen_device->device);
    property_set("ro.product.device", chosen_device->device);
    property_set("ro.product.model",  chosen_device->model);
}

std::string tegra_init::get_model()
{
	return chosen_device->name;
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

bool tegra_init::recovery_context()
{
#ifdef IS_RECOVERY
	return true;
#else
	return false;
#endif
}

bool tegra_init::vendor_context()
{
	return false;
}

std::string tegra_init::property_get(std::string key)
{
    return android::base::GetProperty(key, "");
}

void tegra_init::property_set(std::string key, std::string value)
{
    property_override(key.c_str(), value.c_str());
}

tegra_init::tegra_init(std::vector<devices> devicelist) : tegra_devices(devicelist)
{
    chosen_device = NULL;

    if (detect_model()) {
        LOG(ERROR) << "tegra_init: found model " << chosen_device->name;
        property_set("ro.lineage.tegraid", std::to_string(chosen_device->board_id) + ":" +
            std::to_string(chosen_device->sku));
    } else {
        LOG(ERROR) << "tegra_init: could not detect model, aborting";
    }
}
