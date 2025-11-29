

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
                    // TODO - Implement this skill
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    cost = 2;
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
                        [player, 'staminaDrain', 'skill_loadedForBear', -0.2, true] call vgm_c_fnc_coefficient_set;\
                    ";
                    codeUnapply = "\
                        [player, 'load', 'skill_loadedForBear'] call vgm_c_fnc_coefficient_remove;\
                        [player, 'staminaDrain', 'skill_loadedForBear'] call vgm_c_fnc_coefficient_remove;\
                    ";
                    skillType = 0;
                    cost = 3;
                    applyOnRespawn = 1;
                };

                class chemical_grenades: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_COMBAT_CHEMICAL_GRENADES";
                    description = "$STR_VGM_SKILLS_SKILL_COMBAT_CHEMICAL_GRENADES_DESC";
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

                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    codeApply = "";
                    codeUnapply = "";
                    skillType = 0;
                    cost = 4;
                    applyOnRespawn = 1;
                };

                class knockout: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_KNOCKOUT";
                    description = "$STR_VGM_SKILLS_SKILL_KNOCKOUT_DESC";
                    column = 4;

                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    codeApply = "";
                    codeUnapply = "";
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
                class training_pointman: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_TRAINING_POINTMAN";
                    description = "$STR_VGM_SKILLS_SKILL_TRAINING_POINTMAN_DESC";
                    conditionsUnlockGlobal[] = { { "!((_this#0) getUnitTrait 'vgm_skills_advancedTraining')", "STR_VGM_SKILLS_UI_ADVANCED_TRAINING_LIMIT" } };
                    column = 0;

                    codeApply = "player setUnitTrait ['vgm_skills_advancedTraining', true, true];";
                    codeUnapply = "player setUnitTrait ['vgm_skills_advancedTraining', false, true];";
                    cost = 2;
                    applyOnRespawn = 1;
                };

                class eldest_son: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_ELDEST_SON";
                    description = "$STR_VGM_SKILLS_SKILL_ELDEST_SON_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 1;

                    // TODO - Implementation
                    cost = 8;
                };
            };

            class tier_1 {
                class ground_sign: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_GROUND_SIGN";
                    description = "$STR_VGM_SKILLS_SKILL_GROUND_SIGN_DESC";
                    column = 2;

                    codeApply = "[player, 'glintFrequency', 'skill_ground_sign', -0.3, true] call vgm_c_fnc_coefficient_set";
                    codeUnapply = "[player, 'glintFrequency', 'skill_ground_sign'] call vgm_c_fnc_coefficient_remove";
                    cost = 2;
                };

                class blending_in: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_BLENDING_IN";
                    description = "$STR_VGM_SKILLS_SKILL_BLENDING_IN_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 3;

                    // TODO - Implementation
                    cost = 2;
                };

                class jungle_instinct: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_JUNGLE_INSTINCT";
                    description = "$STR_VGM_SKILLS_SKILL_JUNGLE_INSTINCT_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 4;

                    // TODO - Implementation
                    cost = 2;
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
                class stones_throw: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_STONES_THROW";
                    description = "$STR_VGM_SKILLS_SKILL_STONES_THROW_DESC";
                    column = 0;

                    codeActivate = "call vgm_c_fnc_skill_actives_stonesThrow";
                    skillType = 2;
                    cost = 4;
                    cooldown = 60;
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
                    displayName = "$STR_VGM_SKILLS_SKILL_TAKING_NOTES";
                    description = "$STR_VGM_SKILLS_SKILL_TAKING_NOTES_DESC";
                    column = 2;

                    codeApply = "player setUnitTrait ['vgm_sites_hints_markHintsOnMap', true, true]";
                    codeUnapply = "player setUnitTrait ['vgm_sites_hints_markHintsOnMap', false, true]";
                    cost = 4;
                };

                class cutthroat: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_CUTTHROAT";
                    description = "$STR_VGM_SKILLS_SKILL_CUTTHROAT_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 3;

                    // TODO - Implementation
                    cost = 4;
                };

                class sense_of_scale: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_SENSE_OF_SCALE";
                    description = "$STR_VGM_SKILLS_SKILL_SENSE_OF_SCALE_DESC";
                    column = 4;

                    codeApply = "true call vgm_c_fnc_skill_passives_senseOfScale";
                    codeUnapply = "false call vgm_c_fnc_skill_passives_senseOfScale";
                    cost = 4;
                };

                class handrail: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_HANDRAIL";
                    description = "$STR_VGM_SKILLS_SKILL_HANDRAIL_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 5;

                    // TODO - Implementation
                    cost = 4;
                };
            };

            class tier_3 {
                class one_of_them: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_ONE_OF_THEM";
                    description = "$STR_VGM_SKILLS_SKILL_ONE_OF_THEM_DESC";
                    column = 0;

                    codeActivate = "[true] call vgm_c_fnc_skill_actives_oneOfThem";
                    codeDeactivate = "[false] call vgm_c_fnc_skill_actives_oneOfThem";
                    skillType = 2;
                    cost = 6;
                    cooldown = 600;
                    duration = 20;
                };

                class deep_focus: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_DEEP_FOCUS";
                    description = "$STR_VGM_SKILLS_SKILL_DEEP_FOCUS_DESC";
                    column = 1;

                    codeActivate = "(_this + ['investigateRangeMultiplier', +1]) call vgm_c_fnc_skill_actives_setCoefficientForDuration";
                    skillType = 2;
                    cost = 6;
                    cooldown = 30;
                    duration = 180;
                };

                class eavesdropping: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_EAVESDROPPING";
                    description = "$STR_VGM_SKILLS_SKILL_EAVESDROPPING_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 2;

                    // TODO - Implementation
                    cost = 6;
                };

                class friend_or_foe: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_FRIEND_OR_FOE";
                    description = "$STR_VGM_SKILLS_SKILL_FRIEND_OR_FOE_DESC";
                    column = 3;

                    codeApply = "true call vgm_c_fnc_skill_passives_friendOrFoe";
                    codeUnapply = "false call vgm_c_fnc_skill_passives_friendOrFoe";
                    cost = 6;
                };

                class clear_lens: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_CLEAR_LENS";
                    description = "$STR_VGM_SKILLS_SKILL_CLEAR_LENS_DESC";
                    column = 4;

                    codeApply = "[player, 'scoutingPhotoRangeBonus', 'skill_passives_clearLens', +100, true] call vgm_c_fnc_coefficient_set";
                    codeUnapply = "[player, 'scoutingPhotoRangeBonus', 'skill_passives_clearLens'] call vgm_c_fnc_coefficient_remove";
                    cost = 6;
                };
            };

            class tier_4 {
                class tactical_sense: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_TACTICAL_SENSE";
                    description = "$STR_VGM_SKILLS_SKILL_TACTICAL_SENSE_DESC";
                    column = 0;

                    codeActivate = "[true] call vgm_c_fnc_skill_actives_tacticalSense";
                    codeDeactivate = "[false] call vgm_c_fnc_skill_actives_tacticalSense";
                    skillType = 2;
                    cost = 8;
                    cooldown = 360;
                    duration = 30;
                };

                class on_the_prowl: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_ON_THE_PROWL";
                    description = "$STR_VGM_SKILLS_SKILL_ON_THE_PROWL_DESC";
                    column = 1;

                    codeActivate = "player setUnitTrait ['vgm_skill_investigate_canMoveFreely', true, true]";
                    codeDeactivate = "player setUnitTrait ['vgm_skill_investigate_canMoveFreely', false, true]";
                    skillType = 2;
                    cost = 8;
                    cooldown = 460;
                    duration = 120;
                };

                class pile_of_leaves: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_PILE_OF_LEAVES";
                    description = "$STR_VGM_SKILLS_SKILL_PILE_OF_LEAVES_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 2;

                    // TODO - Implementation
                    cost = 8;
                };

                class throwing_knife: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_THROWING_KNIFE";
                    description = "$STR_VGM_SKILLS_SKILL_THROWING_KNIFE_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 3;

                    // TODO - Implementation
                    cost = 8;
                };
            };
        };
    };

    class teamLeader {
        displayName = "$STR_VGM_SKILLS_TREE_TEAM_LEADER";
        description = "";
        icon = "assets\skills\support_ca.paa";

        class skills {
            class tier_0 {
                class training_team_leader: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_TRAINING_TEAM_LEADER";
                    description = "$STR_VGM_SKILLS_SKILL_TRAINING_TEAM_LEADER_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 0;

                    // TODO - Implementation
                    cost = 2;
                };

                class ma_bell: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_MA_BELL";
                    description = "$STR_VGM_SKILLS_SKILL_MA_BELL_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 1;

                    // TODO - Implementation
                    cost = 8;
                };
            };

            class tier_1 {
                class target_folder_1: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_TARGET_FOLDER_1";
                    description = "$STR_VGM_SKILLS_SKILL_TARGET_FOLDER_1_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 2;

                    // TODO - Implementation
                    cost = 2;
                };

                class fire_direction: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_FIRE_DIRECTION";
                    description = "$STR_VGM_SKILLS_SKILL_FIRE_DIRECTION_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 3;

                    // TODO - Implementation
                    cost = 2;
                };

                class ammo_check: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_AMMO_CHECK";
                    description = "$STR_VGM_SKILLS_SKILL_AMMO_CHECK_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 4;

                    // TODO - Implementation
                    cost = 2;
                };

                class kickoff_time: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_KICKOFF_TIME";
                    description = "$STR_VGM_SKILLS_SKILL_KICKOFF_TIME_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 5;

                    // TODO - Implementation
                    cost = 2;
                };
            };

            class tier_2 {
                class roll_call: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_ROLL_CALL";
                    description = "$STR_VGM_SKILLS_SKILL_ROLL_CALL_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 0;

                    // TODO - Implementation
                    skillType = 2;
                    cost = 4;
                    cooldown = 240;
                    duration = 60;
                };

                class mad_minute: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_MAD_MINUTE";
                    description = "$STR_VGM_SKILLS_SKILL_MAD_MINUTE_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 1;

                    // TODO - Implementation
                    skillType = 2;
                    cost = 4;
                    cooldown = 240;
                    duration = 20;
                };

                class target_folder_2: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_TARGET_FOLDER_2";
                    description = "$STR_VGM_SKILLS_SKILL_TARGET_FOLDER_2_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 2;

                    // TODO - Implementation
                    cost = 4;
                };

                class sanctuary: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_SANCTUARY";
                    description = "$STR_VGM_SKILLS_SKILL_SANCTUARY_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 3;

                    // TODO - Implementation
                    cost = 4;
                };

                class ditch_rucks: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_DITCH_RUCKS";
                    description = "$STR_VGM_SKILLS_SKILL_DITCH_RUCKS_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 4;

                    // TODO - Implementation
                    cost = 4;
                };

                class ron_call: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_RON_CALL";
                    description = "$STR_VGM_SKILLS_SKILL_RON_CALL_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 5;

                    // TODO - Implementation
                    cost = 4;
                };
            };

            class tier_3 {
                class break_contact: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_BREAK_CONTACT";
                    description = "$STR_VGM_SKILLS_SKILL_BREAK_CONTACT_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 0;

                    // TODO - Implementation
                    skillType = 2;
                    cost = 6;
                    cooldown = 560;
                };

                class get_to_the_lz: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_GET_TO_THE_LZ";
                    description = "$STR_VGM_SKILLS_SKILL_GET_TO_THE_LZ_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 1;

                    // TODO - Implementation
                    skillType = 2;
                    cost = 6;
                    cooldown = 600;
                    duration = 90;
                };

                class team_awareness: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_TEAM_AWARENESS";
                    description = "$STR_VGM_SKILLS_SKILL_TEAM_AWARENESS_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 2;

                    // TODO - Implementation
                    cost = 6;
                };

                class alternate_lz: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_ALTERNATE_LZ";
                    description = "$STR_VGM_SKILLS_SKILL_ALTERNATE_LZ_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 3;

                    // TODO - Implementation
                    cost = 6;
                };

                class get_it_together: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_GET_IT_TOGETHER";
                    description = "$STR_VGM_SKILLS_SKILL_GET_IT_TOGETHER_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 4;

                    // TODO - Implementation
                    cost = 6;
                };
            };

            class tier_4 {
                class one_team: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_ONE_TEAM";
                    description = "$STR_VGM_SKILLS_SKILL_ONE_TEAM_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 0;

                    // TODO - Implementation
                    skillType = 2;
                    cost = 8;
                    cooldown = 900;
                };

                class prairie_fire: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_PRAIRIE_FIRE";
                    description = "$STR_VGM_SKILLS_SKILL_PRAIRIE_FIRE_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 1;

                    // TODO - Implementation
                    skillType = 2;
                    cost = 8;
                    cooldown = 600;
                    duration = 480;
                };

                class target_folder_3: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_TARGET_FOLDER_3";
                    description = "$STR_VGM_SKILLS_SKILL_TARGET_FOLDER_3_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 2;

                    // TODO - Implementation
                    cost = 8;
                };

                class rally_point: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_RALLY_POINT";
                    description = "$STR_VGM_SKILLS_SKILL_RALLY_POINT_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 3;

                    // TODO - Implementation
                    cost = 8;
                };
            };
        };
    };

    class rto {
        displayName = "$STR_VGM_SKILLS_TREE_RTO";
        description = "";
        icon = "assets\skills\fire_support_ca.paa";

        class skills {
            class tier_0 {
                class training_rto: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_TRAINING_RTO";
                    description = "$STR_VGM_SKILLS_SKILL_TRAINING_RTO_DESC";
                    conditionsUnlockGlobal[] = { { "!(player getUnitTrait 'vgm_skills_advancedTraining')", "STR_VGM_SKILLS_UI_ADVANCED_TRAINING_LIMIT" } };
                    column = 0;

                    codeApply = "player setUnitTrait ['vgm_skills_advancedTraining', true, true]; player setUnitTrait ['vn_artillery', true, true]; player setUnitTrait ['vgm_artillery_heavySupport', true, true]";
                    codeUnapply = "player setUnitTrait ['vgm_skills_advancedTraining', false, true]; player setUnitTrait ['vn_artillery', false, true]; player setUnitTrait ['vgm_artillery_heavySupport', false, true]";
                    cost = 10;
                    applyOnRespawn = 1;
                };

                class emergency_radio: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_EMERGENCY_RADIO";
                    description = "$STR_VGM_SKILLS_SKILL_EMERGENCY_RADIO_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 1;

                    // TODO - Implementation
                    cost = 8;
                };
            };

            class tier_1 {
                class cas_fast_mover_level_1: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_CAS_FAST_MOVER_LEVEL_1";
                    description = "$STR_VGM_SKILLS_SKILL_CAS_FAST_MOVER_LEVEL_1_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 2;

                    // TODO - Implementation
                    cost = 2;
                };


                class cas_gunship_level_1: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_CAS_GUNSHIP_LEVEL_1";
                    description = "$STR_VGM_SKILLS_SKILL_CAS_GUNSHIP_LEVEL_1_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 3;

                    // TODO - Implementation
                    cost = 2;
                };


                class fireship: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_FIRESHIP";
                    description = "$STR_VGM_SKILLS_SKILL_FIRESHIP_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 4;

                    // TODO - Implementation
                    cost = 2;
                };


                class strobe_marker: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_STROBE_MARKER";
                    description = "$STR_VGM_SKILLS_SKILL_STROBE_MARKER_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 5;

                    // TODO - Implementation
                    cost = 2;
                };
            };

            class tier_2 {
                class sitrep: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_SITREP";
                    description = "$STR_VGM_SKILLS_SKILL_SITREP_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 0;

                    // TODO - Implementation
                    skillType = 2;
                    cost = 4;
                    cooldown = 180;
                };


                class stinger: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_STINGER";
                    description = "$STR_VGM_SKILLS_SKILL_STINGER_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 1;

                    // TODO - Implementation
                    skillType = 2;
                    cost = 4;
                    cooldown = 7200;
                };


                class cas_fast_mover_level_2: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_CAS_FAST_MOVER_LEVEL_2";
                    description = "$STR_VGM_SKILLS_SKILL_CAS_FAST_MOVER_LEVEL_2_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 2;

                    // TODO - Implementation
                    cost = 4;
                };


                class cas_gunship_level_2: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_CAS_GUNSHIP_LEVEL_2";
                    description = "$STR_VGM_SKILLS_SKILL_CAS_GUNSHIP_LEVEL_2_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 3;

                    // TODO - Implementation
                    cost = 4;
                };


                class shadow: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_SHADOW";
                    description = "$STR_VGM_SKILLS_SKILL_SHADOW_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 4;

                    // TODO - Implementation
                    cost = 4;
                };


                class long_antenna: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_LONG_ANTENNA";
                    description = "$STR_VGM_SKILLS_SKILL_LONG_ANTENNA_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 5;

                    // TODO - Implementation
                    cost = 4;
                };
            };

            class tier_3 {
                class guardian_angel: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_GUARDIAN_ANGEL";
                    description = "$STR_VGM_SKILLS_SKILL_GUARDIAN_ANGEL_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 0;

                    // TODO - Implementation
                    skillType = 2;
                    cost = 6;
                    cooldown = 300;
                };


                class arclight: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_ARCLIGHT";
                    description = "$STR_VGM_SKILLS_SKILL_ARCLIGHT_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 1;

                    // TODO - Implementation
                    skillType = 2;
                    cost = 6;
                    cooldown = 7200;
                };


                class cas_fast_mover_level_3: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_CAS_FAST_MOVER_LEVEL_3";
                    description = "$STR_VGM_SKILLS_SKILL_CAS_FAST_MOVER_LEVEL_3_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 2;

                    // TODO - Implementation
                    cost = 6;
                };


                class cas_gunship_level_3: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_CAS_GUNSHIP_LEVEL_3";
                    description = "$STR_VGM_SKILLS_SKILL_CAS_GUNSHIP_LEVEL_3_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 3;

                    // TODO - Implementation
                    cost = 6;
                };


                class cas_covey: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_CAS_COVEY";
                    description = "$STR_VGM_SKILLS_SKILL_CAS_COVEY_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 4;

                    // TODO - Implementation
                    cost = 6;
                };
            };

            class tier_4 {
                class repeat_last: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_REPEAT_LAST";
                    description = "$STR_VGM_SKILLS_SKILL_REPEAT_LAST_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 0;

                    // TODO - Implementation
                    skillType = 2;
                    cost = 8;
                    cooldown = 600;
                    duration = 180;
                };


                class big_blue: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_BIG_BLUE";
                    description = "$STR_VGM_SKILLS_SKILL_BIG_BLUE_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 1;

                    // TODO - Implementation
                    skillType = 2;
                    cost = 8;
                    cooldown = 7200;
                };


                class cas_fast_mover_level_4: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_CAS_FAST_MOVER_LEVEL_4";
                    description = "$STR_VGM_SKILLS_SKILL_CAS_FAST_MOVER_LEVEL_4_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 2;

                    // TODO - Implementation
                    cost = 8;
                };


                class cas_gunship_level_4: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_CAS_GUNSHIP_LEVEL_4";
                    description = "$STR_VGM_SKILLS_SKILL_CAS_GUNSHIP_LEVEL_4_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 3;

                    // TODO - Implementation
                    cost = 8;
                };
            };
        };
    };

    class medic {
        displayName = "$STR_VGM_SKILLS_TREE_MEDIC";
        description = "";
        icon = "assets\skills\support_ca.paa";

        class skills {
            class tier_0 {
                class training_medic: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_TRAINING_MEDIC";
                    description = "$STR_VGM_SKILLS_SKILL_TRAINING_MEDIC_DESC";
                    conditionsUnlockGlobal[] = { { "!(player getUnitTrait 'vgm_skills_advancedTraining')", "STR_VGM_SKILLS_UI_ADVANCED_TRAINING_LIMIT" } };
                    column = 0;

                    codeApply = "player setUnitTrait ['vgm_skills_advancedTraining', true, true]; player setUnitTrait ['Medic', true]";
                    codeUnapply = "player setUnitTrait ['vgm_skills_advancedTraining', false, true]; player setUnitTrait ['Medic', false]";
                    cost = 8;
                    applyOnRespawn = 1;
                };

                class find_the_bicycle: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_FIND_THE_BICYCLE";
                    description = "$STR_VGM_SKILLS_SKILL_FIND_THE_BICYCLE_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 1;

                    // TODO - Implementation
                    cost = 8;
                };
            };

            class tier_1 {
                class combat_doc_1: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_COMBAT_DOC_1";
                    description = "$STR_VGM_SKILLS_SKILL_COMBAT_DOC_1_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 2;

                    // TODO - Implementation
                    cost = 4;
                };

                class keep_calm: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_KEEP_CALM";
                    description = "$STR_VGM_SKILLS_SKILL_KEEP_CALM_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 3;

                    // TODO - Implementation
                    cost = 2;
                };

                class leg_pockets: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_LEG_POCKETS";
                    description = "$STR_VGM_SKILLS_SKILL_LEG_POCKETS_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 4;

                    // TODO - Implementation
                    cost = 2;
                };

                class not_dead_yet: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_NOT_DEAD_YET";
                    description = "$STR_VGM_SKILLS_SKILL_NOT_DEAD_YET_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 5;

                    // TODO - Implementation
                    cost = 2;
                };
            };

            class tier_2 {
                class tourniquet: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_TOURNIQUET";
                    description = "$STR_VGM_SKILLS_SKILL_TOURNIQUET_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 0;

                    // TODO - Implementation
                    skillType = 2;
                    cost = 4;
                    cooldown = 60;
                };

                class black_knight: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_BLACK_KNIGHT";
                    description = "$STR_VGM_SKILLS_SKILL_BLACK_KNIGHT_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 1;

                    // TODO - Implementation
                    skillType = 2;
                    cost = 4;
                    cooldown = 480;
                    duration = 120;
                };

                class combat_doc_2: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_COMBAT_DOC_2";
                    description = "$STR_VGM_SKILLS_SKILL_COMBAT_DOC_2_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 2;

                    // TODO - Implementation
                    cost = 4;
                };

                class he_aint_heavy: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_HE_AINT_HEAVY";
                    description = "$STR_VGM_SKILLS_SKILL_HE_AINT_HEAVY_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 3;

                    // TODO - Implementation
                    cost = 4;
                };

                class green_hornet: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_GREEN_HORNET";
                    description = "$STR_VGM_SKILLS_SKILL_GREEN_HORNET_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 4;

                    // TODO - Implementation
                    cost = 4;
                };
            };

            class tier_3 {
                class pack_the_wound: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_PACK_THE_WOUND";
                    description = "$STR_VGM_SKILLS_SKILL_PACK_THE_WOUND_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 0;

                    // TODO - Implementation
                    skillType = 2;
                    cost = 6;
                    cooldown = 300;
                    duration = 30;
                };

                class salt_tablets: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_SALT_TABLETS";
                    description = "$STR_VGM_SKILLS_SKILL_SALT_TABLETS_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 1;

                    // TODO - Implementation
                    skillType = 2;
                    cost = 6;
                    cooldown = 300;
                };

                class combat_doc_3: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_COMBAT_DOC_3";
                    description = "$STR_VGM_SKILLS_SKILL_COMBAT_DOC_3_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 2;

                    // TODO - Implementation
                    cost = 4;
                };

                class last_rites: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_LAST_RITES";
                    description = "$STR_VGM_SKILLS_SKILL_LAST_RITES_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 3;

                    // TODO - Implementation
                    cost = 6;
                };

                class ive_seen_worse: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_IVE_SEEN_WORSE";
                    description = "$STR_VGM_SKILLS_SKILL_IVE_SEEN_WORSE_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 4;

                    // TODO - Implementation
                    cost = 6;
                };
            };

            class tier_4 {
                class its_only_a_flesh_wound: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_ITS_ONLY_A_FLESH_WOUND";
                    description = "$STR_VGM_SKILLS_SKILL_ITS_ONLY_A_FLESH_WOUND_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 0;

                    // TODO - Implementation
                    skillType = 2;
                    cost = 8;
                    cooldown = 480;
                };

                class sweet_dreams: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_SWEET_DREAMS";
                    description = "$STR_VGM_SKILLS_SKILL_SWEET_DREAMS_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 1;

                    // TODO - Implementation
                    skillType = 2;
                    cost = 8;
                    cooldown = 180;
                };

                class combat_doc_4: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_COMBAT_DOC_4";
                    description = "$STR_VGM_SKILLS_SKILL_COMBAT_DOC_4_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 2;

                    // TODO - Implementation
                    cost = 4;
                };

                class green_hornet_pack: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_GREEN_HORNET_PACK";
                    description = "$STR_VGM_SKILLS_SKILL_GREEN_HORNET_PACK_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 3;

                    // TODO - Implementation
                    cost = 8;
                };

                class playing_possum: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_PLAYING_POSSUM";
                    description = "$STR_VGM_SKILLS_SKILL_PLAYING_POSSUM_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 4;

                    // TODO - Implementation
                    cost = 8;
                };
            };
        };
    };

    class tail {
        displayName = "$STR_VGM_SKILLS_TREE_TAIL";
        description = "";
        icon = "assets\skills\support_ca.paa";

        class skills {
            class tier_0 {
                class training_tail: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_TRAINING_TAIL";
                    description = "$STR_VGM_SKILLS_SKILL_TRAINING_TAIL_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 0;

                    // TODO - Implementation
                    cost = 2;
                };

                class slam: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_SLAM";
                    description = "$STR_VGM_SKILLS_SKILL_SLAM_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 1;

                    // TODO - Implementation
                    cost = 8;
                };
            };

            class tier_1 {
                class eyes_down: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_EYES_DOWN";
                    description = "$STR_VGM_SKILLS_SKILL_EYES_DOWN_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 2;

                    // TODO - Implementation
                    cost = 2;
                };

                class rocketman_1: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_ROCKETMAN_1";
                    description = "$STR_VGM_SKILLS_SKILL_ROCKETMAN_1_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 3;

                    // TODO - Implementation
                    cost = 2;
                };

                class lightfooted: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_LIGHTFOOTED";
                    description = "$STR_VGM_SKILLS_SKILL_LIGHTFOOTED_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 4;

                    // TODO - Implementation
                    cost = 2;
                };

                class toepopper: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_TOEPOPPER";
                    description = "$STR_VGM_SKILLS_SKILL_TOEPOPPER_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 5;

                    // TODO - Implementation
                    cost = 2;
                };
            };

            class tier_2 {
                class slam_time_2: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_SLAM_TIME_2";
                    description = "$STR_VGM_SKILLS_SKILL_SLAM_TIME_2_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 0;

                    // TODO - Implementation
                    skillType = 2;
                    cost = 4;
                    cooldown = 300;
                };

                class lethal_gifts: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_LETHAL_GIFTS";
                    description = "$STR_VGM_SKILLS_SKILL_LETHAL_GIFTS_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 1;

                    // TODO - Implementation
                    skillType = 2;
                    cost = 4;
                    cooldown = 300;
                    duration = 30;
                };

                class gone_native: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_GONE_NATIVE";
                    description = "$STR_VGM_SKILLS_SKILL_GONE_NATIVE_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 2;

                    // TODO - Implementation
                    cost = 4;
                };

                class rocketman_2: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_ROCKETMAN_2";
                    description = "$STR_VGM_SKILLS_SKILL_ROCKETMAN_2_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 3;

                    // TODO - Implementation
                    cost = 4;
                };

                class jungle_eyes: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_JUNGLE_EYES";
                    description = "$STR_VGM_SKILLS_SKILL_JUNGLE_EYES_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 4;

                    // TODO - Implementation
                    cost = 4;
                };

                class slam_time: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_SLAM_TIME";
                    description = "$STR_VGM_SKILLS_SKILL_SLAM_TIME_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 5;

                    // TODO - Implementation
                    cost = 4;
                };
            };

            class tier_3 {
                class rocketman_3: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_ROCKETMAN_3";
                    description = "$STR_VGM_SKILLS_SKILL_ROCKETMAN_3_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 0;

                    // TODO - Implementation
                    skillType = 2;
                    cost = 6;
                    cooldown = 300;
                    duration = 30;
                };

                class dynamite: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_DYNAMITE";
                    description = "$STR_VGM_SKILLS_SKILL_DYNAMITE_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 1;

                    // TODO - Implementation
                    skillType = 2;
                    cost = 6;
                    cooldown = 480;
                };

                class blackjack: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_BLACKJACK";
                    description = "$STR_VGM_SKILLS_SKILL_BLACKJACK_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 2;

                    // TODO - Implementation
                    cost = 6;
                };

                class fuzemaster: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_FUZEMASTER";
                    description = "$STR_VGM_SKILLS_SKILL_FUZEMASTER_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 3;

                    // TODO - Implementation
                    cost = 6;
                };

                class deep_placement: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_DEEP_PLACEMENT";
                    description = "$STR_VGM_SKILLS_SKILL_DEEP_PLACEMENT_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 4;

                    // TODO - Implementation
                    cost = 6;
                };
            };

            class tier_4 {
                class clean_sweep: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_CLEAN_SWEEP";
                    description = "$STR_VGM_SKILLS_SKILL_CLEAN_SWEEP_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 0;

                    // TODO - Implementation
                    skillType = 2;
                    cost = 8;
                    cooldown = 300;
                    duration = 30;
                };

                class lethal_gifts_2: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_LETHAL_GIFTS_2";
                    description = "$STR_VGM_SKILLS_SKILL_LETHAL_GIFTS_2_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 1;

                    // TODO - Implementation
                    skillType = 2;
                    cost = 8;
                    cooldown = 600;
                    duration = 30;
                };

                class heart_of_darkness: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_HEART_OF_DARKNESS";
                    description = "$STR_VGM_SKILLS_SKILL_HEART_OF_DARKNESS_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 2;

                    // TODO - Implementation
                    cost = 8;
                };

                class saboteur: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_SABOTEUR";
                    description = "$STR_VGM_SKILLS_SKILL_SABOTEUR_DESC";
                    conditionsUnlockGlobal[] = { { "false", "STR_VGM_SKILLS_UI_DISABLED_SKILL" } };
                    column = 3;

                    // TODO - Implementation
                    cost = 8;
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
    */
};
