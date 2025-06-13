

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

class vgm_weaponSpecialisationTemplate: vgm_skillTemplate {
    conditionUnlock = "!(missionNamespace getVariable ['vgm_c_skill_hasSpecialisation', false])";
    codeApply = "vgm_c_skill_hasSpecialisation = true";
    codeUnapply  = "vgm_c_skill_hasSpecialisation = false";
};

class vgm_skillTrees {
    class combat {
        displayName = "$STR_VGM_SKILLS_TREE_COMBAT";
        description = "";
        icon = "assets\skills\rifleman_ca.paa";

        class skills {
            class tier_0 {
               class specialisation_rifleman: vgm_weaponSpecialisationTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_SPECIALISATION_RIFLEMAN";
                    column = 1;
                };

                class specialisation_scout: vgm_weaponSpecialisationTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_SPECIALISATION_SCOUT";
                    column = 2;
                };

                class specialisation_marksman: vgm_weaponSpecialisationTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_SPECIALISATION_MARKSMAN";
                    column = 3;
                };

                class specialisation_grenadier: vgm_weaponSpecialisationTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_SPECIALISATION_GRENADIER";
                    column = 4;
                };

                class specialisation_machinegunner: vgm_weaponSpecialisationTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_SPECIALISATION_MACHINEGUNNER";
                    column = 5;
                };
            };

            class tier_1 {
                class field_modification_1: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_COMBAT_FIELD_MODIFICATION_1";
                    description = "$STR_VGM_SKILLS_SKILL_COMBAT_FIELD_MODIFICATION_1_DESC";
                    column = 2;
                };

                class strongHands: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_RIFLEMAN_INCREASED_ACCURACY";
                    column = 3;

                    codeApply = "[player, 'recoil', 'skill_passives_strongHands', -0.25, true] call vgm_c_fnc_coefficient_set";
                    codeUnapply = "[player, 'recoil', 'skill_passives_strongHands'] call vgm_c_fnc_coefficient_remove";
                };

                class ammoPouch: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_AMMOPOUCH";
                    description = "$STR_VGM_SKILLS_SKILL_AMMOPOUCH_DESC";
                    column = 4;

                    codeApply = "true call vgm_c_fnc_skill_passives_ammoPouch";
                    codeUnapply = "false call vgm_c_fnc_skill_passives_ammoPouch";
                };

                class noRestraint: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_NO_RESTRAINT";
                    description = "$STR_VGM_SKILLS_SKILL_NO_RESTRAINT_DESC";
                    column = 5;

                    codeApply = "true call vgm_c_fnc_skill_passives_noRestraint";
                    codeUnapply = "false call vgm_c_fnc_skill_passives_noRestraint";
                };
            };

            class tier_2 {
                class bulletHose: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_BULLET_HOSE";
                    description = "$STR_VGM_SKILLS_SKILL_BULLET_HOSE_DESC";
                    column = 0;

                    codeActivate = "call vgm_c_fnc_skill_actives_bulletHose";

                    skillType = 2;
                    cost = 2;
                    cooldown = 600;
                    duration = 120;
                };

                class shootAndScoot: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_SHOOT_AND_SCOOT";
                    description = "$STR_VGM_SKILLS_SKILL_SHOOT_AND_SCOOT_DESC";
                    column = 1;

                    codeActivate = "call vgm_c_fnc_skill_actives_shootAndScoot";
                    skillType = 1;
                    cost = 2;
                    cooldown = 150;
                    duration = 60;
                };


                class field_modification_2: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_COMBAT_FIELD_MODIFICATION_2";
                    description = "$STR_VGM_SKILLS_SKILL_COMBAT_FIELD_MODIFICATION_2_DESC";
                    column = 2;
                };

                class jungleWarrior: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_JUNGLE_WARRIOR";
                    description = "$STR_VGM_SKILLS_SKILL_JUNGLE_WARRIOR_DESC";
                    column = 3;
                    // TODO - Implement this skill
                    conditionUnlock = "false";
                };

                class stablePlatform: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_STABLE_PLATFORM";
                    description = "$STR_VGM_SKILLS_SKILL_STABLE_PLATFORM_DESC";
                    column = 4;

                    codeApply = "true call vgm_c_fnc_skill_passives_stablePlatform";
                    codeUnapply = "false call vgm_c_fnc_skill_passives_stablePlatform";
                    skillType = 0;
                    applyOnRespawn = 1;
                };


                class grassCutter: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_GRASS_CUTTER";
                    description = "$STR_VGM_SKILLS_SKILL_GRASS_CUTTER_DESC";
                    column = 5;

                    codeApply = "[player, 'suppress', 'skill_grassCutter', 1, true] call vgm_c_fnc_coefficient_set";
                    codeUnapply = "[player, 'suppress', 'skill_grassCutter'] call vgm_c_fnc_coefficient_remove";
                };
            };

            class tier_3 {
                class field_modification_3: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_COMBAT_FIELD_MODIFICATION_3";
                    description = "$STR_VGM_SKILLS_SKILL_COMBAT_FIELD_MODIFICATION_3_DESC";
                    column = 2;
                };
                class chemical_grenades: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_COMBAT_CHEMICAL_GRENADES";
                    description = "$STR_VGM_SKILLS_SKILL_COMBAT_CHEMICAL_GRENADES_DESC";
                    column = 4;
                };
            };

            class tier_4 {
                class field_modification_4: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_COMBAT_FIELD_MODIFICATION_4";
                    description = "$STR_VGM_SKILLS_SKILL_COMBAT_FIELD_MODIFICATION_4_DESC";
                    column = 2;
                };
            };


        };
    };

    class rifleman {
        displayName = "$STR_VGM_SKILLS_TREE_RIFLEMAN";
        description = "";
        icon = "assets\skills\rifleman_ca.paa";

        // rifleman skills
        class skills {
            class tier_0 {};

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
            class tier_0 {};

            class tier_1 {
                class keenEye: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_RECON_KEEN_EYE";
                    description = "$STR_VGM_SKILLS_SKILL_RECON_KEEN_EYE_DESC";

                    codeApply = "true call vgm_c_fnc_skill_passives_recon_keenEye";
                    codeUnapply = "false call vgm_c_fnc_skill_passives_recon_keenEye";
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
            class tier_0 {};

            class tier_1 {

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
            class tier_0 {};

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
