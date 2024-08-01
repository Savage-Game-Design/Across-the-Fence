class vgm_site_types {
    /**
        Template for defining a site type.
        vgm_ prefix is for official sites only. Addons can add additional sites using their own prefixes.
    **/
    class vgm_template {
        disabled = 1;
        generatorFunction = "vgm_s_fnc_sites_type_template";
    };

    class vgm_shelter {
        generatorFunction = "vgm_s_fnc_sites_type_shelter";
    };

    class vgm_campfire {
        generatorFunction = "vgm_s_fnc_sites_type_campfire";
    };
};
