#ifndef __INIT_SHIELD__H__
#define __INIT_SHIELD__H__

#include <string>
#include <map>
#include <vector>

class tegra_init {

    public:
        struct devices {
            std::string device;
            std::string name;
            std::string hardware;
            std::string model;
            uint16_t board_id;
            uint16_t sku;
            uint8_t first_api;
            uint16_t dpi;
        } typedef devices;

        struct build_version {
            std::string android_version;
            std::string android_release;
            std::string nvidia_version;
        } typedef build_version;

        tegra_init(std::vector<devices> devicelist);

        void set_properties();

        void set_fingerprints(build_version fp_version);
        void make_symlinks(std::map<std::string,std::string> paths);

        void check_safe_mode_adb();

	std::string get_model();
	bool is_model(std::string name);
	bool is_model(uint16_t board_id, uint16_t sku);

	bool recovery_context();
	bool vendor_context();

	std::string property_get(std::string key);
	void property_set(std::string key, std::string value);

    private:
        std::vector<devices> tegra_devices;
        devices *chosen_device;

        bool detect_model();
        bool detect_model_override();
        void detect_model_devicetree();
        void detect_model_boardinfo();
};

#endif /* __INIT_SHIELD__H__ */
