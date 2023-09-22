

class vgm_skillTemplate {
    displayName = "SKILL NAME";
    description = "SKILL DESCRIPTION";
    icon = "\vn\ui_f_vietnam\ui\wheelmenu\img\ui_icon_a_ca.paa";

    skillType = 0; // 0 - passive, 1 - primary, 2 - ultimate
    applyOnRespawn = 0;

    cost = 1;
    cooldown = 10;

    conditionUnlock = "true";
    conditionShow = "true";

    codeApply = "";
    codeUnapply = "";

    codeActivate = "";
};

class vgm_skillTrees {
    class rifleman {
        displayName = "$STR_VGM_SKILLS_TREE_RIFLEMAN";
        description = "";

        // rifleman skills
        class skills {
            class tier_1 {
                class steadyHand: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_RIFLEMAN_INCREASED_ACCURACY";

                    codeApply = "[player, 'recoil', 'skills', -0.25] call vgm_c_fnc_coefficient_set";
                    codeUnapply = "[player, 'recoil', 'skills', 0] call vgm_c_fnc_coefficient_set";
                    skillType = 0;
                    applyOnRespawn = 1;
                };

                class tough: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_RIFLEMAN_TOUGH";

                    codeApply = "[player, 'bleedOut', 'skills', 0.2] call vgm_c_fnc_coefficient_set";
                    codeUnapply = "[player, 'bleedOut', 'skills', 0] call vgm_c_fnc_coefficient_set";
                    skillType = 0;
                    applyOnRespawn = 1;
                };
            };

            class tier_2 {
                class loadout_historical: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_RIFLEMAN_LOADOUT_HISTORICAL";
                    description = "$STR_VGM_SKILLS_SKILL_RIFLEMAN_LOADOUT_HISTORICAL_DESC";

                    applyOnRespawn = 1;
                };

                class overprepared: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_RIFLEMAN_OVERPREPARED";
                    description = "$STR_VGM_SKILLS_SKILL_RIFLEMAN_OVERPREPARED_DESC";

                    codeApply = "true call vgm_c_fnc_skill_passives_overprepared";
                    codeUnapply = "false call vgm_c_fnc_skill_passives_overprepared";
                };

                class loadout: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_RIFLEMAN_LOADOUT";
                    description = "$STR_VGM_SKILLS_SKILL_RIFLEMAN_LOADOUT_DESC";
                };
            };

            class tier_3 {
                class bornLeader: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_RIFLEMAN_BORN_LEADER";
                    description = "$STR_VGM_SKILLS_SKILL_RIFLEMAN_BORN_LEADER_DESC";

                    codeApply = "true call vgm_c_fnc_skill_passives_bornLeader";
                    codeUnapply = "false call vgm_c_fnc_skill_passives_bornLeader";
                    cost = 2;
                };

                class steadyAim: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_RIFLEMAN_STEADY_AIM";
                    description = "$STR_VGM_SKILLS_SKILL_RIFLEMAN_STEADY_AIM_DESC";

                    codeActivate = "call vgm_c_fnc_skill_actives_steadyAim";
                    skillType = 1;
                    cost = 2;
                    cooldown = 120;
                };
            };

            class tier_4 {
                class luckySon: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_RIFLEMAN_LUCKY_SON";
                    description = "$STR_VGM_SKILLS_SKILL_RIFLEMAN_LUCKY_SON_DESC";

                    codeActivate = "call vgm_c_fnc_skill_actives_luckySon";
                    skillType = 2;
                    cost = 4;
                    cooldown = 120;
                };
            };
        };

        // specializations
        class subtrees {};
    };
};
