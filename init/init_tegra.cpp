#define _REALLY_INCLUDE_SYS__SYSTEM_PROPERTIES_H_
#include <sys/_system_properties.h>
#include <android-base/properties.h>
#include <android-base/logging.h>

#include "init_tegra.h"

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
    std::string sku = property_get("ro.boot.hardware.sku");

    if (!sku.empty()) {
        for (auto & device : tegra_devices) {
            if (!device.name.compare(sku)) {
                chosen_device = &device;
                break;
            }
        }
        if (chosen_device)
            return;
    }

    for (auto & device : tegra_devices) {
        if (!device.hardware.compare(hardware)) {
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
    std::ifstream skufile;

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
    } else if (skufile.open("/proc/device-tree/chosen/nvidia,sku"), skufile.is_open()) {
        if (!std::getline(skufile, temp, '-'))
            return;
        // discard 699-

        if (!std::getline(skufile, temp, '-'))
            return;
        board_id = std::stoul(temp, nullptr, 10);
        board_id -= 10000; // remove leading 1 from 4 digit id

        if (!std::getline(skufile, temp, '-'))
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

    std::string hardware = property_get("ro.hardware");
    for (auto & device : tegra_devices) {
        if (board_id == device.board_id && sku == device.sku &&
            !device.hardware.compare(hardware)) {
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
    property_set("ro.bootimage.build.fingerprint",
                 ("NVIDIA/" + chosen_device->name + "/" +
                  chosen_device->device + ":" +
                  fp_version.android_version + "/" +
                  fp_version.android_release + "/" +
                  fp_version.nvidia_version +
                  ":user/release-keys").c_str());
    property_set("ro.build.fingerprint",
                 ("NVIDIA/" + chosen_device->name + "/" +
                  chosen_device->device + ":" +
                  fp_version.android_version + "/" +
                  fp_version.android_release + "/" +
                  fp_version.nvidia_version +
                  ":user/release-keys").c_str());
    property_set("ro.system.build.fingerprint",
                 ("NVIDIA/" + chosen_device->name + "/" +
                  chosen_device->device + ":" +
                  fp_version.android_version + "/" +
                  fp_version.android_release + "/" +
                  fp_version.nvidia_version +
                  ":user/release-keys").c_str());
    property_set("ro.odm.build.fingerprint",
                 ("NVIDIA/" + chosen_device->name + "/" +
                  chosen_device->device + ":" +
                  fp_version.android_version + "/" +
                  fp_version.android_release + "/" +
                  fp_version.nvidia_version +
                  ":user/release-keys").c_str());
    property_set("ro.product.build.fingerprint",
                 ("NVIDIA/" + chosen_device->name + "/" +
                  chosen_device->device + ":" +
                  fp_version.android_version + "/" +
                  fp_version.android_release + "/" +
                  fp_version.nvidia_version +
                  ":user/release-keys").c_str());
    property_set("ro.system_ext.build.fingerprint",
                 ("NVIDIA/" + chosen_device->name + "/" +
                  chosen_device->device + ":" +
                  fp_version.android_version + "/" +
                  fp_version.android_release + "/" +
                  fp_version.nvidia_version +
                  ":user/release-keys").c_str());
    property_set("ro.build.description",
                 (chosen_device->name + "-user " +
                  fp_version.android_version + " " +
                  fp_version.android_release + " " +
                  fp_version.nvidia_version + " " +
                  chosen_device->device + " " +
                  "release-keys").c_str());
}

void tegra_init::make_symlinks(std::map<std::string,std::string> paths)
{
    for(auto const& [key, value]: paths)
        symlink(key.c_str(), value.c_str());
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

    property_set("ro.product.system.name",   chosen_device->name);
    property_set("ro.product.system.device", chosen_device->device);
    property_set("ro.product.system.model",  chosen_device->model);

    property_set("ro.product.odm.name",   chosen_device->name);
    property_set("ro.product.odm.device", chosen_device->device);
    property_set("ro.product.odm.model",  chosen_device->model);

    property_set("ro.product.product.name",   chosen_device->name);
    property_set("ro.product.product.device", chosen_device->device);
    property_set("ro.product.product.model",  chosen_device->model);

    property_set("ro.product.system_ext.name",   chosen_device->name);
    property_set("ro.product.system_ext.device", chosen_device->device);
    property_set("ro.product.system_ext.model",  chosen_device->model);
}

void tegra_init::check_safe_mode_adb()
{
    std::ifstream safemode("/proc/device-tree/chosen/nvidia,safe_mode_adb");
    if (safemode.is_open()) {
        std::string current_mode = property_get("persist.sys.usb.config");
	if (current_mode.empty() || !current_mode.compare("none")) {
            property_set("sys.usb.config", "adb");
        } else if (current_mode.find("adb") == std::string::npos) {
            property_set("sys.usb.config", current_mode + ",adb");
        }
        property_set("ro.adb.secure", "0");
    }
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

// Wrapper for omni style vendor init
extern void vendor_load_properties(void);
namespace android {
namespace init {
    void vendor_load_properties()
    {
        ::vendor_load_properties();
    }
}
}
