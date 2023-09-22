class vgm_equipment {
    class default {
        condition = "true";

        weapons[] = {
            "hgun_P07_F"
        };
        magazines[] = {
            "16Rnd_9x21_Mag"
        };
        backpacks[] = {};
        items[] = {
            "U_B_CombatUniform_mcam_tshirt"
        };
    };

    class rifleman {
        condition = "missionNamespace getVariable ['test', false]";

        weapons[] = {
            "arifle_MX_F"
        };
        magazines[] = {
            "30Rnd_65x39_caseless_mag"
        };
        backpacks[] = {
            "B_AssaultPack_rgr"
        };
        items[] = {};
    };
};
