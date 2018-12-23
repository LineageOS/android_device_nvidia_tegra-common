#include "init_tegra.h"

#include <sstream>
#include <string>
#include <unistd.h>

#include "cutils/properties.h"

#define LOG_TAG "tegra_init_vendor"
#include <log/log.h>

bool tegra_init::detect_model_override()
{
    return false;
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
    std::string temp;
    uint32_t board_id = -1, sku = -1;
    std::string boardinfo = property_get("ro.lineage.tegraid");

    if (boardinfo.empty())
        return;

    std::stringstream bistream(boardinfo);
    if (!std::getline(bistream, temp, ':'))
        return;
    board_id = std::stoul(temp);

    if (!std::getline(bistream, temp, ':'))
        return;
    sku = std::stoul(temp);

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
        return false;
    }

    // If only one device is defined, just use that one
    if (tegra_devices.size() == 1) {
        chosen_device = &tegra_devices[0];
        return true;
    }

    detect_model_boardinfo();

    if (!chosen_device)
        detect_model_devicetree();

    return chosen_device != NULL;
}

void tegra_init::set_fingerprints(build_version fp_version)
{
    property_set("ro.vendor.build.fingerprint", ("NVIDIA/" + chosen_device->name + "/" +
                                                 chosen_device->device + ":" +
                                                 fp_version.android_version + "/" +
                                                 fp_version.android_release + "/" +
                                                 fp_version.nvidia_version +
                                                 ":user/release-keys").c_str());
}

void tegra_init::make_symlinks(std::map<std::string,std::string> paths)
{
    for(auto const& [key, value]: paths)
        symlink(key.c_str(), value.c_str());
}

void tegra_init::recovery_links(std::map<std::string, std::string> parts) {}
void tegra_init::recovery_links(std::vector<std::string> parts) {}

void tegra_init::set_properties()
{
    if (chosen_device == NULL) return;

    property_set("ro.product.first_api_level", std::to_string(chosen_device->first_api));
    property_set("ro.vendor.product.config.shipped_with_full_treble",
        chosen_device->first_api >= 28 ? "true" : "false");

    property_set("ro.product.vendor.name",   chosen_device->name);
    property_set("ro.product.vendor.device", chosen_device->device);
    property_set("ro.product.vendor.model",  chosen_device->model);
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
	return false;
}

bool tegra_init::vendor_context()
{
	return true;
}

std::string tegra_init::property_get(std::string key)
{
    char value[PROPERTY_VALUE_MAX];

    ::property_get(key.c_str(), (char*)&value, "");

    return std::string(value);
}

void tegra_init::property_set(std::string key, std::string value)
{
    ::property_set(key.c_str(), value.c_str());
}

tegra_init::tegra_init(std::vector<devices> devicelist) : tegra_devices(devicelist)
{
    chosen_device = NULL;

    if (detect_model())
        ALOGE("Found model %s", chosen_device->name.c_str());
    else
        ALOGE("tegra_init: could not detect model, aborting");
}
