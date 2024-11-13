

class vgm_skillTemplate {
    displayName = "SKILL NAME";
    description = "SKILL DESCRIPTION";
    icon = "\vn\ui_f_vietnam\ui\wheelmenu\img\ui_icon_a_ca.paa";

    skillType = 0; // 0 - passive, 1 - primary, 2 - ultimate
    applyOnRespawn = 0;

    cost = 1;
    cooldown = 10;
    duration = 0;

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
        icon = "assets\skills\rifleman_ca.paa";

        // rifleman skills
        class skills {
            class tier_1 {
                class steadyHand: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_RIFLEMAN_INCREASED_ACCURACY";

                    codeApply = "[player, 'recoil', 'skill_passives_steadyHand', -0.25, true] call vgm_c_fnc_coefficient_set";
                    codeUnapply = "[player, 'recoil', 'skill_passives_steadyHand'] call vgm_c_fnc_coefficient_remove";
                };

                class tough: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_RIFLEMAN_TOUGH";

                    codeApply = "[player, 'bleedOut', 'skill_passives_tough', 0.2, true] call vgm_c_fnc_coefficient_set";
                    codeUnapply = "[player, 'bleedOut', 'skill_passives_tough'] call vgm_c_fnc_coefficient_remove";
                };
            };

            class tier_2 {
                class loadout_historical: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_RIFLEMAN_LOADOUT_HISTORICAL";
                    description = "$STR_VGM_SKILLS_SKILL_RIFLEMAN_LOADOUT_HISTORICAL_DESC";
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
                    duration = 30;
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
                    duration = 20;
                };
            };
        };

        // specializations
        class subtrees {};
    };

    class recon {
        displayName = "$STR_VGM_SKILLS_TREE_RECON";
        description = "";
        icon = "assets\skills\recon_ca.paa";

        // recon skills
        class skills {
            class tier_1 {
                class betterAim: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_RECON_BETTER_AIM";
                    description = "";

                    codeApply = "true call vgm_c_fnc_skill_passives_recon_betterAim";
                    codeUnapply = "false call vgm_c_fnc_skill_passives_recon_betterAim";
                    skillType = 0;
                    applyOnRespawn = 1;
                };

                class detective: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_RECON_DETECTIVE";
                    description = "$STR_VGM_SKILLS_SKILL_RECON_DETECTIVE_DESC";

                    codeApply = "[player, 'glintFrequency', 'skill_recon_detective', -0.3, true] call vgm_c_fnc_coefficient_set";
                    codeUnapply = "[player, 'glintFrequency', 'skill_recon_detective'] call vgm_c_fnc_coefficient_remove";
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
                    duration = 20;
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
                    duration = 60;
                };
            };
        };

        // specializations
        class subtrees {};
    };

    class fireSupport {
        displayName = "$STR_VGM_SKILLS_TREE_FIRE_SUPPORT";
        description = "";
        icon = "assets\skills\fire_support_ca.paa";

        // fire support skills
        class skills {
            class tier_1 {
                class heavySuppression: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_FIRE_SUPPORT_HEAVY_SUPPRESSION";

                    codeApply = "[player, 'suppress', 'skill_fireSupport_heavySuppression', 0.5, true] call vgm_c_fnc_coefficient_set";
                    codeUnapply = "[player, 'suppress', 'skill_fireSupport_heavySuppression'] call vgm_c_fnc_coefficient_remove";
                };

                class packMule: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_FIRE_SUPPORT_PACK_MULE";

                    codeApply = "\
                        [player, 'load', 'skill_fireSupport_packMule', -0.3, true] call vgm_c_fnc_coefficient_set;\
                        [player, 'staminaDrain', 'skill_fireSupport_packMule', -0.2, true] call vgm_c_fnc_coefficient_set;\
                    ";
                    codeUnapply = "\
                        [player, 'load', 'skill_fireSupport_packMule'] call vgm_c_fnc_coefficient_remove;\
                        [player, 'staminaDrain', 'skill_fireSupport_packMule'] call vgm_c_fnc_coefficient_remove;\
                    ";
                };
            };

            class tier_2 {
                class loadout_machineGunner: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_FIRE_SUPPORT_LOADOUT_MACHINE_GUNNER";
                    description = "$STR_VGM_SKILLS_SKILL_FIRE_SUPPORT_LOADOUT_MACHINE_GUNNER_DESC";
                };

                class loadout_explosives: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_FIRE_SUPPORT_LOADOUT_EXPLOSIVES";
                    description = "$STR_VGM_SKILLS_SKILL_FIRE_SUPPORT_LOADOUT_EXPLOSIVES_DESC";
                };

                class loadout_grenadier: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_FIRE_SUPPORT_LOADOUT_GRENADIER";
                    description = "$STR_VGM_SKILLS_SKILL_FIRE_SUPPORT_LOADOUT_GRENADIER_DESC";
                };
            };

            class tier_3 {
                class learnTheRhythm: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_FIRE_SUPPORT_LEARN_THE_RHYTHM";
                    description = "$STR_VGM_SKILLS_SKILL_FIRE_SUPPORT_LEARN_THE_RHYTHM_DESC";

                    codeApply = "true call vgm_c_fnc_skill_passives_fireSupport_learnTheRhythm";
                    codeUnapply = "false call vgm_c_fnc_skill_passives_fireSupport_learnTheRhythm";

                    cost = 2;
                };

                class grenadesCase: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_FIRE_SUPPORT_GRENADES_CASE";
                    description = "$STR_VGM_SKILLS_SKILL_FIRE_SUPPORT_GRENADES_CASE_DESC";

                    codeActivate = "call vgm_c_fnc_skill_actives_fireSupport_grenadesCase";

                    skillType = 1;
                    cost = 2;
                    cooldown = 180;
                    duration = 10;
                };
            };

            class tier_4 {
                class overwhelmingFire: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_FIRE_SUPPORT_OVERWHELMING_FIRE";
                    description = "$STR_VGM_SKILLS_SKILL_FIRE_SUPPORT_OVERWHELMING_FIRE_DESC";

                    codeActivate = "call vgm_c_fnc_skill_actives_fireSupport_overwhelmingFire";

                    skillType = 2;
                    cost = 2;
                    cooldown = 240;
                    duration = 120;
                };
            };
        };

        // fire support specializations
        class subtrees {};
    };

    class support {
        displayName = "$STR_VGM_SKILLS_TREE_SUPPORT";
        description = "";
        icon = "assets\skills\support_ca.paa";

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

                    codeApply = "player setUnitTrait ['Medic', true]";
                    codeUnapply = "player setUnitTrait ['Medic', false]";
                };

                class resourceful: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_SUPPORT_RESOURCEFUL";
                    description = "$STR_VGM_SKILLS_SKILL_SUPPORT_RESOURCEFUL_DESC";

                    codeApply = "player setVariable ['vgm_c_skill_passives_support_resourceful', true, true]";
                    codeUnapply = "player setVariable ['vgm_c_skill_passives_support_resourceful', false, false]";
                };

                class loadout_rto: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_SUPPORT_LOADOUT_RTO";
                    description = "$STR_VGM_SKILLS_SKILL_SUPPORT_LOADOUT_RTO_DESC";

                    codeApply = "player setUnitTrait ['vn_artillery', true, true]";
                    codeUnapply = "player setUnitTrait ['vn_artillery', false, true]";
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
                    cooldown = 60;
                };

                class heavySupport: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_SUPPORT_HEAVY_SUPPORT";
                    description = "$STR_VGM_SKILLS_SKILL_SUPPORT_HEAVY_SUPPORT_DESC";

                    codeApply = "player setVariable ['vgm_c_skill_passives_support_heavySupport', true]";
                    codeUnapply = "player setVariable ['vgm_c_skill_passives_support_heavySupport', false]";

                    cost = 2;
                };
            };

            class tier_4 {
                class getToTheLz: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_SUPPORT_GET_TO_THE_LZ";
                    description = "$STR_VGM_SKILLS_SKILL_SUPPORT_GET_TO_THE_LZ_DESC";

                    codeActivate = "call vgm_c_fnc_skill_actives_support_getToTheLz";
                    skillType = 2;
                    cost = 2;
                    cooldown = 480;
                    duration = 30;
                };
            };
        };

        // support specializations
        class subtrees {};
    };
};
