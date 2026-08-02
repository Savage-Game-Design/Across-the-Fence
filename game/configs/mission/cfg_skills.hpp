

class vgm_skillTemplate {
    displayName = "SKILL NAME";
    description = "SKILL DESCRIPTION";
    icon = "\vn\ui_f_vietnam\ui\wheelmenu\img\ui_icon_a_ca.paa";

    skillType = 0; // 0 - passive, 1 - primary, 2 - ultimate

    cost = 1;
    cooldown = 10;
    duration = 0;

    conditionsUnlockGlobal[] = {};
    conditionShow = "true";
    conditionActivate = "true";

    // If 1, re-runs codeApply on respawn
    applyOnRespawn = 0;
    // Called when the skill is learned
    codeApply = "";
    // Called when the skill is unlearned
    codeUnapply = "";

    // If 1, re-runs codeApplyGroup locally for the respawning player in the group
    applyOnRespawnGroup = 0;
    // Called locally on every player when in a mission with the skill's owner to apply the skill's effect.
    // Called once for each player that has the skill on the mission.
    codeApplyGroup = "";
    // Called locally on every player when no longer in a mission with the skill's owner to remove the skill's effect.
    // Called once for each player that had the skill on the mission.
    codeUnapplyGroup = "";

    // Called when an ability is triggered
    codeActivate = "";
    // Called on all members of the team when an ability is triggered
    codeActivateGroup = "";
    // Called when an ability has ended
    codeDeactivate = "";
    // Called when  an ability is unable to activate
    codeUnableToActivate = "";
};

class vgm_weaponSpecialisationTemplate: vgm_skillTemplate {
    conditionsUnlockGlobal[] = {
        {
            "!((_this#0) getVariable ['vgm_c_skill_hasWeaponSpecialisation', false])",
            "STR_VGM_SKILLS_UI_WEAPON_SPECIALISATION_LIMIT"
        }
    };
    codeApply = "player setVariable ['vgm_c_skill_hasWeaponSpecialisation', true, true]";
    codeUnapply  = "player setVariable ['vgm_c_skill_hasWeaponSpecialisation', false, true]";
};

class vgm_skillAdvancedTrainingTemplate: vgm_skillTemplate {
    conditionsUnlockGlobal[] = {
        {
            "!((_this#0) getUnitTrait 'vgm_skills_advancedTraining')",
            "STR_VGM_SKILLS_UI_ADVANCED_TRAINING_LIMIT"
        }
    };
    codeApply = "player setUnitTrait ['vgm_skills_advancedTraining', true, true];";
    codeUnapply = "player setUnitTrait ['vgm_skills_advancedTraining', false, true];";
    applyOnRespawn = 1;
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
                    description = "$STR_VGM_SKILLS_SKILL_SPECIALISATION_RIFLEMAN_DESC";
                    column = 1;
                };

                class specialisation_scout: vgm_weaponSpecialisationTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_SPECIALISATION_SCOUT";
                    description = "$STR_VGM_SKILLS_SKILL_SPECIALISATION_SCOUT_DESC";
                    column = 2;
                };

                class specialisation_marksman: vgm_weaponSpecialisationTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_SPECIALISATION_MARKSMAN";
                    description = "$STR_VGM_SKILLS_SKILL_SPECIALISATION_MARKSMAN_DESC";
                    column = 3;
                };

                class specialisation_grenadier: vgm_weaponSpecialisationTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_SPECIALISATION_GRENADIER";
                    description = "$STR_VGM_SKILLS_SKILL_SPECIALISATION_GRENADIER_DESC";
                    column = 4;
                };

                class specialisation_machinegunner: vgm_weaponSpecialisationTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_SPECIALISATION_MACHINEGUNNER";
                    description = "$STR_VGM_SKILLS_SKILL_SPECIALISATION_MACHINEGUNNER_DESC";
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
                    displayName = "$STR_VGM_SKILLS_SKILL_RIFLEMAN_STRONG_HANDS";
                    description = "$STR_VGM_SKILLS_SKILL_RIFLEMAN_STRONG_HANDS_DESC";
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

                    codeActivate = "[player, 'aim', 'skill_shootAndScoot', -1, true] call vgm_c_fnc_coefficient_set";
                    codeDeactivate = "[player, 'aim', 'skill_shootAndScoot'] call vgm_c_fnc_coefficient_remove";
                    skillType = 1;
                    cost = 2;
                    cooldown = 150;
                    duration = 60;
                };


                class field_modification_2: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_COMBAT_FIELD_MODIFICATION_2";
                    description = "$STR_VGM_SKILLS_SKILL_COMBAT_FIELD_MODIFICATION_2_DESC";
                    column = 2;

                    cost = 2;
                };

                class jungleWarrior: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_JUNGLE_WARRIOR";
                    description = "$STR_VGM_SKILLS_SKILL_JUNGLE_WARRIOR_DESC";
                    column = 3;

                    codeApply = "true call vgm_c_fnc_skill_passives_jungleWarrior";
                    codeUnapply = "false call vgm_c_fnc_skill_passives_jungleWarrior";
                    cost = 2;
                    applyOnRespawn = 1;
                };

                class stablePlatform: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_STABLE_PLATFORM";
                    description = "$STR_VGM_SKILLS_SKILL_STABLE_PLATFORM_DESC";
                    column = 4;

                    codeApply = "true call vgm_c_fnc_skill_passives_stablePlatform";
                    codeUnapply = "false call vgm_c_fnc_skill_passives_stablePlatform";
                    skillType = 0;
                    cost = 2;
                    applyOnRespawn = 1;
                };


                class grassCutter: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_GRASS_CUTTER";
                    description = "$STR_VGM_SKILLS_SKILL_GRASS_CUTTER_DESC";
                    column = 5;

                    codeApply = "[player, 'suppress', 'skill_grassCutter', 1, true] call vgm_c_fnc_coefficient_set";
                    codeUnapply = "[player, 'suppress', 'skill_grassCutter'] call vgm_c_fnc_coefficient_remove";
                    cost = 2;
                };
            };

            class tier_3 {
                class treeCutter: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_TREE_CUTTER";
                    description = "$STR_VGM_SKILLS_SKILL_TREE_CUTTER_DESC";
                    column = 0;

                    codeActivate = "(_this + ['suppress', 3]) call vgm_c_fnc_skill_actives_setCoefficientForDuration";
                    skillType = 1;
                    cost = 3;
                    cooldown = 120;
                    duration = 240;
                };

                class battleFocus: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_BATTLE_FOCUS";
                    description = "$STR_VGM_SKILLS_SKILL_BATTLE_FOCUS_DESC";
                    column = 1;

                    codeActivate = "(_this + ['canFireWhileInvestigating']) call vgm_c_fnc_skill_actives_setStatusForDuration";
                    skillType = 1;
                    cost = 3;
                    cooldown = 420;
                    duration = 20;
                };

                class field_modification_3: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_COMBAT_FIELD_MODIFICATION_3";
                    description = "$STR_VGM_SKILLS_SKILL_COMBAT_FIELD_MODIFICATION_3_DESC";
                    column = 2;

                    cost = 3;
                };

                class loadedForBear: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_LOADED_FOR_BEAR";
                    description = "$STR_VGM_SKILLS_SKILL_LOADED_FOR_BEAR_DESC";
                    column = 3;

                    codeApply = "\
                        [player, 'load', 'skill_loadedForBear', -0.3, true] call vgm_c_fnc_coefficient_set;\
                        [player, 'staminaDrainSkills', 'skill_loadedForBear', -0.2, true] call vgm_c_fnc_coefficient_set;\
                    ";
                    codeUnapply = "\
                        [player, 'load', 'skill_loadedForBear'] call vgm_c_fnc_coefficient_remove;\
                        [player, 'staminaDrainSkills', 'skill_loadedForBear'] call vgm_c_fnc_coefficient_remove;\
                    ";
                    skillType = 0;
                    cost = 3;
                    applyOnRespawn = 1;
                };

                class scorched_earth: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_SCORCHED_EARTH";
                    description = "$STR_VGM_SKILLS_SKILL_SCORCHED_EARTH_DESC";
                    column = 4;

                    cost = 3;
                };

                class reconByFire: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_RECON_BY_FIRE";
                    description = "$STR_VGM_SKILLS_SKILL_RECON_BY_FIRE_DESC";
                    column = 5;

                    codeApply = "true call vgm_c_fnc_skill_passives_reconByFire";
                    codeUnapply = "false call vgm_c_fnc_skill_passives_reconByFire";
                    cost = 3;
                };
            };

            class tier_4 {
                class steelRain: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_STEEL_RAIN";
                    description = "$STR_VGM_SKILLS_SKILL_STEEL_RAIN_DESC";
                    column = 0;

                    codeActivate = "call vgm_c_fnc_skill_actives_steelRain";

                    skillType = 1;
                    cost = 4;
                    cooldown = 180;
                    duration = 30;
                };

                class justAScratch: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_JUST_A_SCRATCH";
                    description = "$STR_VGM_SKILLS_SKILL_JUST_A_SCRATCH_DESC";
                    icon = "\vn\ui_f_vietnam\ui\wheelmenu\img\ui_icon_b_ca.paa";
                    column = 1;

                    codeActivate = "(_this + ['hitShrug', 0.95]) call vgm_c_fnc_skill_actives_setCoefficientForDuration";

                    skillType = 1;
                    cost = 4;
                    cooldown = 600;
                    duration = 60;
                };

                class field_modification_4: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_COMBAT_FIELD_MODIFICATION_4";
                    description = "$STR_VGM_SKILLS_SKILL_COMBAT_FIELD_MODIFICATION_4_DESC";
                    column = 2;
                };

                class warFace: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_WAR_FACE";
                    description = "$STR_VGM_SKILLS_SKILL_WAR_FACE_DESC";
                    column = 3;

                    codeApply = "true call vgm_c_fnc_skill_passives_warFace";
                    codeUnapply = "false call vgm_c_fnc_skill_passives_warFace";
                    skillType = 0;
                    cost = 4;
                    applyOnRespawn = 1;
                };

                class dig_in: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_DIG_IN";
                    description = "$STR_VGM_SKILLS_SKILL_DIG_IN_DESC";
                    column = 4;

                    codeApply = "true call vgm_c_fnc_skill_passives_digIn";
                    codeUnapply = "false call vgm_c_fnc_skill_passives_digIn";
                    skillType = 0;
                    cost = 4;
                    applyOnRespawn = 1;
                };
            };
        };
    };

    class pointman {
        displayName = "$STR_VGM_SKILLS_TREE_POINTMAN";
        description = "";
        icon = "assets\skills\recon_ca.paa";

        class skills {
            class tier_0 {
                class training_pointman: vgm_skillAdvancedTrainingTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_TRAINING_POINTMAN";
                    description = "$STR_VGM_SKILLS_SKILL_TRAINING_POINTMAN_DESC";
                    column = 0;

                    codeApply = "player setUnitTrait ['vgm_skills_advancedTraining', true, true]; true call vgm_c_fnc_skill_passives_trapDetect;";
                    codeUnapply = "player setUnitTrait ['vgm_skills_advancedTraining', false, true]; false call vgm_c_fnc_skill_passives_trapDetect;";
                    cost = 2;
                };

                class eldest_son: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_ELDEST_SON";
                    description = "$STR_VGM_SKILLS_SKILL_ELDEST_SON_DESC";
                    column = 1;

                    codeApply = "true call vgm_c_fnc_skill_passives_eldestSon";
                    codeUnapply = "false call vgm_c_fnc_skill_passives_eldestSon";
                    cost = 8;
                    applyOnRespawn = 1;
                };
            };

            class tier_1 {
                class ground_sign: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_GROUND_SIGN";
                    description = "$STR_VGM_SKILLS_SKILL_GROUND_SIGN_DESC";
                    column = 2;

                    codeApply = "[player, 'glintFrequency', 'skill_ground_sign', -0.3, true] call vgm_c_fnc_coefficient_set; player setUnitTrait ['vgm_skill_alwaysSeeGlints', true, true]";
                    codeUnapply = "[player, 'glintFrequency', 'skill_ground_sign'] call vgm_c_fnc_coefficient_remove; player setUnitTrait ['vgm_skill_alwaysSeeGlints', false, true]";
                    applyOnRespawn = 1;
                    cost = 2;
                };

                class blending_in: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_BLENDING_IN";
                    description = "$STR_VGM_SKILLS_SKILL_BLENDING_IN_DESC";
                    column = 3;

                    codeApply = "true call vgm_c_fnc_skill_passives_blendingIn";
                    codeUnapply = "false call vgm_c_fnc_skill_passives_blendingIn";
                    cost = 2;
                    applyOnRespawn = 1;
                };

                class jungle_instinct: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_JUNGLE_INSTINCT";
                    description = "$STR_VGM_SKILLS_SKILL_JUNGLE_INSTINCT_DESC";
                    column = 4;

                    codeApply = "true call vgm_c_fnc_skill_passives_jungleInstinct";
                    codeUnapply = "false call vgm_c_fnc_skill_passives_jungleInstinct";
                    cost = 2;
                    applyOnRespawn = 1;
                };

                class in_the_zone: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_IN_THE_ZONE";
                    description = "$STR_VGM_SKILLS_SKILL_IN_THE_ZONE_DESC";
                    column = 5;

                    codeApply = "[player, 'investigateTimeCoef', 'skill_in_the_zone', -0.5, true] call vgm_c_fnc_coefficient_set";
                    codeUnapply = "[player, 'investigateTimeCoef', 'skill_in_the_zone'] call vgm_c_fnc_coefficient_remove";
                    cost = 2;
                };
            };

            class tier_2 {
                class pathfinder: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_PATHFINDER";
                    description = "$STR_VGM_SKILLS_SKILL_PATHFINDER_DESC";
                    column = 0;

                    codeActivate = "[true] call vgm_c_fnc_skill_actives_pathfinder";
                    codeDeactivate = "[false] call vgm_c_fnc_skill_actives_pathfinder";
                    skillType = 2;
                    cost = 4;
                    cooldown = 120;
                    duration = 30;
                };

                class keen_eye: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_KEEN_EYE";
                    description = "$STR_VGM_SKILLS_SKILL_KEEN_EYE_DESC";
                    column = 1;

                    codeActivate = "call vgm_c_fnc_skill_actives_keenEye";
                    skillType = 2;
                    cost = 4;
                    cooldown = 180;
                };

                class taking_notes: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKIL…10538 tokens truncated…   description = "";
        icon = "assets\skills\support_ca.paa";

        class skills {
            class tier_0 {
                class training_tail: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_TRAINING_TAIL";
                    description = "$STR_VGM_SKILLS_SKILL_TRAINING_TAIL_DESC";
                    conditionsUnlockGlobal[] = { { "!((_this#0) getUnitTrait 'vgm_skills_advancedTraining')", "STR_VGM_SKILLS_UI_ADVANCED_TRAINING_LIMIT" } };
                    column = 0;

                    codeApply = "player setUnitTrait ['vgm_skills_advancedTraining', true, true]; true call vgm_c_fnc_skill_passives_trapDisarm;";
                    codeUnapply = "player setUnitTrait ['vgm_skills_advancedTraining', false, true]; false call vgm_c_fnc_skill_passives_trapDisarm;";
                    cost = 2;
                    applyOnRespawn = 1;
                };

                class slam: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_SLAM";
                    description = "$STR_VGM_SKILLS_SKILL_SLAM_DESC";
                    column = 1;

                    codeApply = "true call vgm_c_fnc_skill_passives_slam";
                    codeUnapply = "false call vgm_c_fnc_skill_passives_slam";
                    cost = 8;
                    applyOnRespawn = 1;
                };
            };

            class tier_1 {
                class eyes_down: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_EYES_DOWN";
                    description = "$STR_VGM_SKILLS_SKILL_EYES_DOWN_DESC";
                    column = 2;

                    codeApply = "true call vgm_c_fnc_skill_passives_eyesDown";
                    codeUnapply = "false call vgm_c_fnc_skill_passives_eyesDown";
                    cost = 2;
                    applyOnRespawn = 1;
                };

                class rocketman_1: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_ROCKETMAN_1";
                    description = "$STR_VGM_SKILLS_SKILL_ROCKETMAN_1_DESC";
                    column = 3;

                    cost = 2;
                };

                class lightfooted: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_LIGHTFOOTED";
                    description = "$STR_VGM_SKILLS_SKILL_LIGHTFOOTED_DESC";
                    column = 4;

                    codeApply = "player setVariable ['vgm_g_skill_lightfooted', true, true]";
                    codeUnapply = "player setVariable ['vgm_g_skill_lightfooted', false, true]";
                    cost = 2;
                    applyOnRespawn = 1;
                };

                class toepopper: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_TOEPOPPER";
                    description = "$STR_VGM_SKILLS_SKILL_TOEPOPPER_DESC";
                    column = 5;

                    codeApply = "true call vgm_c_fnc_skill_passives_toepopper";
                    codeUnapply = "false call vgm_c_fnc_skill_passives_toepopper";
                    cost = 2;
                    applyOnRespawn = 1;
                };
            };

            class tier_2 {
                class slam_time_2: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_SLAM_TIME_2";
                    description = "$STR_VGM_SKILLS_SKILL_SLAM_TIME_2_DESC";
                    column = 0;

                    codeActivate = "call vgm_c_fnc_skill_actives_slamTime2";
                    conditionActivate = "'vn_m20a1b1_01' in weapons player";
                    skillType = 2;
                    cost = 4;
                    cooldown = 300;
                };

                class lethal_gifts: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_LETHAL_GIFTS";
                    description = "$STR_VGM_SKILLS_SKILL_LETHAL_GIFTS_DESC";
                    column = 1;

                    codeActivate = "call vgm_c_fnc_skill_actives_lethalGifts";
                    skillType = 2;
                    cost = 4;
                    cooldown = 300;
                    duration = 30;
                };

                class gone_native: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_GONE_NATIVE";
                    description = "$STR_VGM_SKILLS_SKILL_GONE_NATIVE_DESC";
                    column = 2;

                    cost = 4;
                };

                class rocketman_2: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_ROCKETMAN_2";
                    description = "$STR_VGM_SKILLS_SKILL_ROCKETMAN_2_DESC";
                    column = 3;

                    codeApply = "true call vgm_c_fnc_skill_passives_rocketman2";
                    codeUnapply = "false call vgm_c_fnc_skill_passives_rocketman2";
                    cost = 4;
                    applyOnRespawn = 1;
                };

                class jungle_eyes: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_JUNGLE_EYES";
                    description = "$STR_VGM_SKILLS_SKILL_JUNGLE_EYES_DESC";
                    column = 4;

                    codeApply = "true call vgm_c_fnc_skill_passives_jungleEyes";
                    codeUnapply = "false call vgm_c_fnc_skill_passives_jungleEyes";
                    cost = 4;
                    applyOnRespawn = 1;
                };

                class slam_time: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_SLAM_TIME";
                    description = "$STR_VGM_SKILLS_SKILL_SLAM_TIME_DESC";
                    column = 5;

                    cost = 4;
                };
            };

            class tier_3 {
                class rocketman_3: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_ROCKETMAN_3";
                    description = "$STR_VGM_SKILLS_SKILL_ROCKETMAN_3_DESC";
                    column = 0;

                    codeActivate = "call vgm_c_fnc_skill_actives_rocketman3";
                    skillType = 2;
                    cost = 6;
                    cooldown = 300;
                    duration = 30;
                };

                class dynamite: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_DYNAMITE";
                    description = "$STR_VGM_SKILLS_SKILL_DYNAMITE_DESC";
                    column = 1;

                    codeActivate = "call vgm_c_fnc_skill_actives_dynamite";
                    skillType = 2;
                    cost = 6;
                    cooldown = 480;
                };

                class blackjack: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_BLACKJACK";
                    description = "$STR_VGM_SKILLS_SKILL_BLACKJACK_DESC";
                    column = 2;

                    cost = 6;
                };

                class fuzemaster: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_FUZEMASTER";
                    description = "$STR_VGM_SKILLS_SKILL_FUZEMASTER_DESC";
                    column = 3;

                    codeApply = "true call vgm_c_fnc_skill_passives_fuzemaster";
                    codeUnapply = "false call vgm_c_fnc_skill_passives_fuzemaster";
                    cost = 6;
                    applyOnRespawn = 1;
                };

                class deep_placement: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_DEEP_PLACEMENT";
                    description = "$STR_VGM_SKILLS_SKILL_DEEP_PLACEMENT_DESC";
                    column = 4;

                    codeApply = "player setVariable ['vgm_g_skill_deepPlacement', true, true]";
                    codeUnapply = "player setVariable ['vgm_g_skill_deepPlacement', false, true]";
                    cost = 6;
                };
            };

            class tier_4 {
                class clean_sweep: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_CLEAN_SWEEP";
                    description = "$STR_VGM_SKILLS_SKILL_CLEAN_SWEEP_DESC";
                    column = 0;

                    codeActivate = "call vgm_c_fnc_skill_actives_cleanSweep";
                    skillType = 2;
                    cost = 8;
                    cooldown = 300;
                    duration = 30;
                };

                class lethal_gifts_2: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_LETHAL_GIFTS_2";
                    description = "$STR_VGM_SKILLS_SKILL_LETHAL_GIFTS_2_DESC";
                    column = 1;

                    codeActivate = "call vgm_c_fnc_skill_actives_lethalGifts2";
                    skillType = 2;
                    cost = 8;
                    cooldown = 600;
                    duration = 30;
                };

                class heart_of_darkness: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_HEART_OF_DARKNESS";
                    description = "$STR_VGM_SKILLS_SKILL_HEART_OF_DARKNESS_DESC";
                    column = 2;

                    codeApply = "true call vgm_c_fnc_skill_passives_heartOfDarkness";
                    codeUnapply = "false call vgm_c_fnc_skill_passives_heartOfDarkness";
                    cost = 8;
                    applyOnRespawn = 1;
                };

                class saboteur: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_SABOTEUR";
                    description = "$STR_VGM_SKILLS_SKILL_SABOTEUR_DESC";
                    column = 3;

                    codeApply = "true call vgm_c_fnc_skill_passives_saboteur";
                    codeUnapply = "false call vgm_c_fnc_skill_passives_saboteur";
                    cost = 8;
                    applyOnRespawn = 1;
                };
            };
        };
    };

    /*
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
                    displayName = "$STR_VGM_SKILLS_SKILL_TRAINING_RTO";
                    description = "$STR_VGM_SKILLS_SKILL_TRAINING_RTO_DESC";

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
            };
        };

        // support specializations
        class subtrees {};
    };
    */
};
