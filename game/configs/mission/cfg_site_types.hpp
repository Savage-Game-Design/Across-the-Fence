class vgm_site_types {
    /**
        Template for defining a site type.
        vgm_ prefix is for official sites only. Addons can add additional sites using their own prefixes.
    **/
    class vgm_template {
        disabled = 1;
        generatorFunction = "vgm_s_fnc_sites_type_template";
        locationClass = "o_unknown";
    };

    class vgm_aa {
        generatorFunction = "vgm_s_fnc_sites_type_aa";
        locationClass = "o_antiair";
    };

    class vgm_ammo_cache {
        generatorFunction = "vgm_s_fnc_sites_type_ammoCache";
        locationClass = "o_support";
    };

    class vgm_bulldozer {
        generatorFunction = "vgm_s_fnc_sites_type_bulldozer";
        locationClass = "o_support";
    };

    class vgm_campfire {
        generatorFunction = "vgm_s_fnc_sites_type_campfire";
        locationClass = "o_recon";
    };

    class vgm_encampment {
        generatorFunction = "vgm_s_fnc_sites_type_encampment";
        locationClass = "o_installation";
    };

    class vgm_shelter {
        generatorFunction = "vgm_s_fnc_sites_type_shelter";
        locationClass = "o_installation";
    };

    class vgm_supply_dump {
        generatorFunction = "vgm_s_fnc_sites_type_supplyDump";
        locationClass = "o_maint";
    };

    class vgm_transmitter {
        generatorFunction = "vgm_s_fnc_sites_type_transmitter";
        locationClass = "o_service";
    };

    class vgm_truck_park {
        generatorFunction = "vgm_s_fnc_sites_type_truckPark";
        locationClass = "o_maint";
    };

    class vgm_waypoint {
        generatorFunction = "vgm_s_fnc_sites_type_waypoint";
    };
};
