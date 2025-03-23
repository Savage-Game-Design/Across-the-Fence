class vgm_site_hints_default {
    radius = 400;
    radiusSafezone = 100;

    // objects per 1 km^2
    density = 45;

    classes[] = {
        "vn_o_item_bedroll_01",
        "vn_o_item_map_case_01",
        "vn_o_item_binocs_case_01",
        "vn_o_item_canteen_01",
        "vn_o_item_canteen_02",
        "vn_o_item_machete_01",
        "vn_o_item_fighting_knife_01",
        "Land_vn_canisterfuel_f",
        "Land_vn_pavn_pouch"
    };
};

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

        class hints: vgm_site_hints_default {};
    };

    class vgm_ammo_cache {
        displayNameKey = "STR_VGM_SITES_AMMO_CACHE";
        generatorFunction = "vgm_s_fnc_sites_type_ammoCache";
        locationClass = "o_support";

        class hints: vgm_site_hints_default {};
    };

    class vgm_bulldozer {
        displayNameKey = "STR_VGM_SITES_BULLDOZER";
        generatorFunction = "vgm_s_fnc_sites_type_bulldozer";
        locationClass = "o_support";

        class hints: vgm_site_hints_default {};
    };

    class vgm_campfire {
        /* Intended for debug only */
        disabled = 1;
        displayNameKey = "STR_VGM_SITES_CAMPFIRE";
        generatorFunction = "vgm_s_fnc_sites_type_campfire";
        locationClass = "o_recon";

        class hints: vgm_site_hints_default {};
    };

    class vgm_encampment {
        displayNameKey = "STR_VGM_SITES_ENCAMPMENT";
        generatorFunction = "vgm_s_fnc_sites_type_encampment";
        locationClass = "o_installation";

        class hints: vgm_site_hints_default {};
    };

    class vgm_shelter {
        /* Intended for debug only */
        disabled = 1;
        displayNameKey = "STR_VGM_SITES_SHELTER";
        generatorFunction = "vgm_s_fnc_sites_type_shelter";
        locationClass = "o_installation";
    };

    class vgm_supply_dump {
        displayNameKey = "STR_VGM_SITES_SUPPLY_DUMP";
        generatorFunction = "vgm_s_fnc_sites_type_supplyDump";
        locationClass = "o_maint";

        class hints: vgm_site_hints_default {};
    };

    class vgm_transmitter {
        displayNameKey = "STR_VGM_SITES_TRANSMITTER";
        generatorFunction = "vgm_s_fnc_sites_type_transmitter";
        locationClass = "o_service";

        class hints: vgm_site_hints_default {};
    };

    class vgm_truck_park {
        displayNameKey = "STR_VGM_SITES_TRUCK_PARK";
        generatorFunction = "vgm_s_fnc_sites_type_truckPark";
        locationClass = "o_maint";

        class hints: vgm_site_hints_default {};
    };

    class vgm_waystation {
        displayNameKey = "STR_VGM_SITES_WAYSTATION";
        generatorFunction = "vgm_s_fnc_sites_type_waystation";
        locationClass = "o_unknown";

        class hints: vgm_site_hints_default {};
    };
};
