

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
                class steadyAim: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_RIFLEMAN_STEADY_AIM";

                    codeApply = "call vgm_c_fnc_skills_apply_steadyAim";
                    codeUnapply = "player setCustomAimCoef 1";
                    skillType = 0;
                    applyOnRespawn = 1;
                };
                class tough: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_RIFLEMAN_TOUGH";

                    cost = 1e10; // prevent learning until medical system is done
                };
            };

            class tier_2 {
                class quick: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_RIFLEMAN_QUICK";
                    applyOnRespawn = 1;
                    cost = 1e10; // prevent learning until custom stamina system is done
                };
                class advanced_loadout: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_RIFLEMAN_ADVANCED_LOADOUT";
                    description = "$STR_VGM_SKILLS_SKILL_RIFLEMAN_ADVANCED_LOADOUT_DESC";
                    cost = 3;
                };
                class athletic: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_RIFLEMAN_ATHLETIC";
                    codeApply = "call vgm_c_fnc_skills_apply_athletic";
                    codeUnapply = "player setUnitTrait ['loadCoef', 1]";
                    applyOnRespawn = 1;
                    cost = 3;
                };
            };

            class tier_3 {
                class moreAmmo: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_RIFLEMAN_MORE_AMMO";
                    cost = 4;
                };
                class hoofIt: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_RIFLEMAN_HOOFIT";
                    description = "$STR_VGM_SKILLS_SKILL_RIFLEMAN_HOOFIT_DESC";
                    codeActivate = "call vgm_c_fnc_skills_apply_hoofIt";
                    skillType = 1;
                    cost = 4;
                    cooldown = 150;
                };
            };

            class tier_4 {
                class combatSalvaging: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_RIFLEMAN_COMBATSALVAGING";
                    description = "STR_VGM_SKILLS_SKILL_RIFLEMAN_COMBATSALVAGING_DESC";
                    cost = 6;
                };
            };
        };

        // specializations
        class subtrees {
            class autorifleman {
                displayName = "$STR_VGM_SKILLS_TREE_AUTORIFLEMAN";
            };
        };
    };

    class serviceEssentials {
        displayName = "$STR_VGM_SKILLS_TREE_SERVICEESSENTIALS";
    };
};
