

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
    conditionActivate = "true";

    codeApply = "";
    codeUnapply = "";

    codeActivate = "";
    codeUnableToActivate = "";
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

                    codeApply = "[player, 'recoil', 'skills', -0.25, true] call vgm_c_fnc_coefficient_set";
                    codeUnapply = "[player, 'recoil', 'skills'] call vgm_c_fnc_coefficient_remove";
                };

                class tough: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_RIFLEMAN_TOUGH";

                    codeApply = "[player, 'bleedOut', 'skills', 0.2, true] call vgm_c_fnc_coefficient_set";
                    codeUnapply = "[player, 'bleedOut', 'skills'] call vgm_c_fnc_coefficient_remove";
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

                    codeApply = "true call vgm_c_fnc_skill_passives_infantryman_overprepared";
                    codeUnapply = "false call vgm_c_fnc_skill_passives_infantryman_overprepared";
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

                    codeApply = "true call vgm_c_fnc_skill_passives_infantryman_bornLeader";
                    codeUnapply = "false call vgm_c_fnc_skill_passives_infantryman_bornLeader";
                    cost = 2;
                };

                class steadyAim: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_RIFLEMAN_STEADY_AIM";
                    description = "$STR_VGM_SKILLS_SKILL_RIFLEMAN_STEADY_AIM_DESC";

                    codeActivate = "call vgm_c_fnc_skill_actives_infantryman_steadyAim";
                    skillType = 1;
                    cost = 2;
                    cooldown = 120;
                };
            };

            class tier_4 {
                class luckySon: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_RIFLEMAN_LUCKY_SON";
                    description = "$STR_VGM_SKILLS_SKILL_RIFLEMAN_LUCKY_SON_DESC";
                    icon = "\vn\ui_f_vietnam\ui\wheelmenu\img\ui_icon_b_ca.paa";

                    codeActivate = "call vgm_c_fnc_skill_actives_infantryman_luckySon";
                    skillType = 2;
                    cost = 4;
                    cooldown = 120;
                };
            };
        };

        // specializations
        class subtrees {};
    };

    class recon {
        displayName = "$STR_VGM_SKILLS_TREE_RECON";
        description = "";

        // rifleman skills
        class skills {
            class tier_1 {
                class betterAim: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_RECON_BETTER_AIM";

                    codeApply = "true call vgm_c_fnc_skill_passives_recon_betterAim";
                    codeUnapply = "false call vgm_c_fnc_skill_passives_recon_betterAim";
                    skillType = 0;
                    applyOnRespawn = 1;
                };

                class athletic: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_RECON_ATHLETIC";

                    codeApply = "[player, 'staminaDrain', 'skill_recon_athletic', -0.2, true] call vgm_c_fnc_coefficient_set";
                    codeUnapply = "[player, 'staminaDrain', 'skill_recon_athletic'] call vgm_c_fnc_coefficient_remove";
                };
            };

            class tier_2 {
                class loadout_marksman: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_RECON_LOADOUT_MARKSMAN";
                    description = "$STR_VGM_SKILLS_SKILL_RECON_LOADOUT_MARKSMAN_DESC";
                };

                class keenEye: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_RECON_KEEN_EYE";
                    description = "$STR_VGM_SKILLS_SKILL_RECON_KEEN_EYE_DESC";

                    codeApply = "true call vgm_c_fnc_skill_passives_recon_keenEye";
                    codeUnapply = "false call vgm_c_fnc_skill_passives_recon_keenEye";
                };

                class loadout_pointman: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_RECON_LOADOUT_POINTMAN";
                    description = "$STR_VGM_SKILLS_SKILL_RECON_LOADOUT_POINTMAN_DESC";
                };
            };

            class tier_3 {
                class followTheTracers: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_RECON_FOLLOW_THE_TRACERS";
                    description = "$STR_VGM_SKILLS_SKILL_RECON_FOLLOW_THE_TRACERS_DESC";

                    codeApply = "true call vgm_c_fnc_skill_passives_recon_followTheTracers";
                    codeUnapply = "false call vgm_c_fnc_skill_passives_recon_followTheTracers";
                    cost = 2;
                };

                class sixthSense: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_RECON_SIXTH_SENSE";
                    description = "$STR_VGM_SKILLS_SKILL_RECON_SIXTH_SENSE_DESC";

                    codeActivate = "call vgm_c_fnc_skill_actives_recon_sixthSense";
                    skillType = 1;
                    cost = 2;
                    cooldown = 120;
                };
            };

            class tier_4 {
                class thickBrush: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_RECON_THICK_BRUSH";
                    description = "$STR_VGM_SKILLS_SKILL_RECON_THICK_BRUSH_DESC";

                    codeActivate = "call vgm_c_fnc_skill_actives_recon_thickBrush";
                    skillType = 2;
                    cost = 2;
                    cooldown = 180;
                };
            };
        };

        // specializations
        class subtrees {};
    };

    class support {
        displayName = "$STR_VGM_SKILLS_TREE_SUPPORT";
        description = "";

        // support skills
        class skills {
            class tier_1 {
                class nimbleHands: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_SUPPORT_NIMBLE_HANDS";
                    description = "$STR_VGM_SKILLS_SKILL_SUPPORT_NIMBLE_HANDS_DESC";

                    codeApply = "[player, 'interact', 'skill_support_nimbleHands', -0.25, true] call vgm_c_fnc_coefficient_set";
                    codeUnapply = "[player, 'interact', 'skill_support_nimbleHands'] call vgm_c_fnc_coefficient_remove";
                };

                class shepherd: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_SUPPORT_SHEPHERD";
                    description = "$STR_VGM_SKILLS_SKILL_SUPPORT_SHEPHERD_DESC";

                    codeApply = "true call vgm_c_fnc_skill_passives_support_shepherd";
                    codeUnapply = "false call vgm_c_fnc_skill_passives_support_shepherd";
                };
            };

            class tier_2 {
                class loadout_medical: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_SUPPORT_LOADOUT_MEDICAL";
                    description = "$STR_VGM_SKILLS_SKILL_SUPPORT_LOADOUT_MEDICAL_DESC";
                };

                class resourceful: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_SUPPORT_RESOURCEFUL";
                    description = "$STR_VGM_SKILLS_SKILL_SUPPORT_RESOURCEFUL_DESC";

                    codeApply = "player setVariable ['vgm_c_skill_passives_support_resourceful', true, true]";
                    codeUnapply = "player setVariable ['vgm_c_skill_passives_support_resourceful', false, false]";
                };

                class loadout_rto: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_SUPPORT_LOADOUT_MEDICAL";
                    description = "$STR_VGM_SKILLS_SKILL_SUPPORT_LOADOUT_MEDICAL_DESC";
                };
            };

            class tier_3 {
                class quickBandage: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_SUPPORT_QUICK_BANDAGE";
                    description = "$STR_VGM_SKILLS_SKILL_SUPPORT_QUICK_BANDAGE_DESC";

                    conditionActivate = "\
                        private _target = cursorTarget;\
                        _target getVariable ['vgm_g_medical_bleeding', false]\
                        && {_target distance player <= 10}\
                    ";
                    codeActivate = "call vgm_c_fnc_skill_actives_support_quickBandage";
                    codeUnableToActivate = "\
                        if (cursorTarget distance player > 10) exitWith {}; \
                        hint localize 'STR_VGM_SKILLS_SKILL_SUPPORT_QUICK_BANDAGE_UNABLE_TO_APPLY'\
                    ";

                    skillType = 1;
                    cost = 2;
                    cooldown = 120;
                };

                class heavySupport: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_SUPPORT_HEAVY_SUPPORT";
                    description = "$STR_VGM_SKILLS_SKILL_SUPPORT_HEAVY_SUPPORT_DESC";

                    codeApply = "player setVariable ['vgm_c_skill_passives_support_heavySupport', true]";
                    codeUnapply = "player setVariable ['vgm_c_skill_passives_support_heavySupport', false]";

                    // cost = 2;
                    cost = 0; // air support not implemented yet
                };
            };

            class tier_4 {
                class getToTheLz: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_SUPPORT_GET_TO_THE_LZ";
                    description = "$STR_VGM_SKILLS_SKILL_SUPPORT_GET_TO_THE_LZ_DESC";

                    codeActivate = "call vgm_c_fnc_skill_actives_support_getToTheLz";
                    skillType = 2;
                    cost = 2;
                    cooldown = 120;
                };
            };
        };

        // support specializations
        class subtrees {};
    };
};
