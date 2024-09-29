class vgm_site_types {
    /**
        Template for defining a site type.
        vgm_ prefix is for official sites only. Addons can add additional sites using their own prefixes.
    **/
    class vgm_template {
        disabled = 1;
        generatorFunction = "vgm_s_fnc_sites_type_template";
    };

    class vgm_aa {
        generatorFunction = "vgm_s_fnc_sites_type_aa";
    };

    class vgm_ammo_cache {
        generatorFunction = "vgm_s_fnc_sites_type_ammoCache";
    };

    class vgm_bulldozer {
        generatorFunction = "vgm_s_fnc_sites_type_bulldozer";
    };

    class vgm_campfire {
        /* Intended for debug only */
        disabled = 1;
        generatorFunction = "vgm_s_fnc_sites_type_campfire";
    };

    class vgm_encampment {
        generatorFunction = "vgm_s_fnc_sites_type_encampment";
    };

    class vgm_shelter {
        /* Intended for debug only */
        disabled = 1;
        generatorFunction = "vgm_s_fnc_sites_type_shelter";
    };

    class vgm_supply_dump {
        generatorFunction = "vgm_s_fnc_sites_type_supplyDump";
    };

    class vgm_transmitter {
        generatorFunction = "vgm_s_fnc_sites_type_transmitter";
    };

    class vgm_truck_park {
        generatorFunction = "vgm_s_fnc_sites_type_truckPark";
    };

    class vgm_waypoint {
        generatorFunction = "vgm_s_fnc_sites_type_waypoint";
    };
};
