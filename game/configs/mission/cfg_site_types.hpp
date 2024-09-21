class vgm_site_types {
    /**
        Template for defining a site type.
        vgm_ prefix is for official sites only. Addons can add additional sites using their own prefixes.
    **/
    class vgm_template {
        disabled = 1;
        displayNameKey = "<template>";
        generatorFunction = "vgm_s_fnc_sites_type_template";
        locationClass = "o_unknown";
    };

    class vgm_aa {
        displayNameKey = "STR_VGM_SITES_AA";
        generatorFunction = "vgm_s_fnc_sites_type_aa";
        locationClass = "o_antiair";
    };

    class vgm_ammo_cache {
        displayNameKey = "STR_VGM_SITES_AMMO_CACHE";
        generatorFunction = "vgm_s_fnc_sites_type_ammoCache";
        locationClass = "o_support";
    };

    class vgm_bulldozer {
        displayNameKey = "STR_VGM_SITES_BULLDOZER";
        generatorFunction = "vgm_s_fnc_sites_type_bulldozer";
        locationClass = "o_support";
    };

    class vgm_campfire {
        displayNameKey = "STR_VGM_SITES_CAMPFIRE";
        generatorFunction = "vgm_s_fnc_sites_type_campfire";
        locationClass = "o_recon";
    };

    class vgm_encampment {
        displayNameKey = "STR_VGM_SITES_ENCAMPMENT";
        generatorFunction = "vgm_s_fnc_sites_type_encampment";
        locationClass = "o_installation";
    };

    class vgm_shelter {
        displayNameKey = "STR_VGM_SITES_SHELTER";
        generatorFunction = "vgm_s_fnc_sites_type_shelter";
        locationClass = "o_installation";
    };

    class vgm_supply_dump {
        displayNameKey = "STR_VGM_SITES_SUPPLY_DUMP";
        generatorFunction = "vgm_s_fnc_sites_type_supplyDump";
        locationClass = "o_maint";
    };

    class vgm_transmitter {
        displayNameKey = "STR_VGM_SITES_TRANSMITTER";
        generatorFunction = "vgm_s_fnc_sites_type_transmitter";
        locationClass = "o_service";
    };

    class vgm_truck_park {
        displayNameKey = "STR_VGM_SITES_TRUCK_PARK";
        generatorFunction = "vgm_s_fnc_sites_type_truckPark";
        locationClass = "o_maint";
    };

    class vgm_waypoint {
        displayNameKey = "STR_VGM_SITES_WAYPOINT";
        generatorFunction = "vgm_s_fnc_sites_type_waypoint";
    };
};
