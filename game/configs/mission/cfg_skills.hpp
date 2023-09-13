

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
                class loadout_containers: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_RIFLEMAN_LOADOUT_CONTAINERS";

                    applyOnRespawn = 1;
                    cost = 3;
                };

                class overprepared: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_RIFLEMAN_OVERPREPARED";
                    description = "$STR_VGM_SKILLS_SKILL_RIFLEMAN_OVERPREPARED_DESC";

                    codeApply = "true call vgm_c_fnc_skill_passives_overprepared";
                    codeUnapply = "false call vgm_c_fnc_skill_passives_overprepared";
                    cost = 3;
                };

                class loadout: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_RIFLEMAN_LOADOUT";
                    description = "$STR_VGM_SKILLS_SKILL_RIFLEMAN_LOADOUT_DESC";

                    cost = 3;
                };
            };

            class tier_3 {
                class bornLeader: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_RIFLEMAN_BORN_LEADER";
                    description = "$STR_VGM_SKILLS_SKILL_RIFLEMAN_BORN_LEADER_DESC";

                    codeApply = "true call vgm_c_fnc_skill_passives_bornLeader";
                    codeUnapply = "false call vgm_c_fnc_skill_passives_bornLeader";
                    cost = 4;
                };

                class steadyAim: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_RIFLEMAN_STEADY_AIM";
                    description = "$STR_VGM_SKILLS_SKILL_RIFLEMAN_STEADY_AIM_DESC";

                    codeActivate = "call vgm_c_fnc_skill_actives_steadyAim";
                    skillType = 1;
                    cost = 4;
                    cooldown = 120;
                };
            };

            class tier_4 {
                class luckySon: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_RIFLEMAN_LUCKY_SON";
                    description = "STR_VGM_SKILLS_SKILL_RIFLEMAN_LUCKY_SON_DESC";
                    cost = 4;
                    skillType = 2;
                };
            };
        };

        // specializations
        class subtrees {
            class autorifleman {
                displayName = "$STR_VGM_SKILLS_TREE_AUTORIFLEMAN";

                class skills {
                    class tier_1 {
                        class steadyAimPassive: vgm_skillTemplate {
                            displayName = "$STR_VGM_SKILLS_SKILL_AUTORIFLEMAN_STEADY_AIM_PASSIVE";

                            codeApply = "call vgm_c_fnc_skill_steadyAimPassive";
                            codeUnapply = "player setCustomAimCoef 1";
                            skillType = 0;
                            applyOnRespawn = 1;
                        };

                        class increasedAccuracy : vgm_skillTemplate {
                            displayName = "$STR_VGM_SKILLS_SKILL_AUTORIFLEMAN_HARDENED";

                            codeApply = "call vgm_c_fnc_skill_hardened";
                            applyOnRespawn = 1;
                            cost = 1e10; // prevent learning until custom stamina system is done
                        };
                    };

                    class tier_2 {
                        class increasedAmmo : vgm_skillTemplate {
                            displayName = "$STR_VGM_SKILLS_SKILL_AUTORIFLEMAN_MORE_AMMO";
                            description = "$STR_VGM_SKILLS_SKILL_AUTORIFLEMAN_MORE_AMMO_DESC";
                            applyOnRespawn = 1;

                            cost = 1e10; // prevent learning until ammo system is done
                        };

                        class advancedLoadout: vgm_skillTemplate {
                            displayName = "$STR_VGM_SKILLS_SKILL_AUTORIFLEMAN_ADVANCED_LOADOUT";
                            description = "$STR_VGM_SKILLS_SKILL_AUTORIFLEMAN_ADVANCED_LOADOUT_DESC";

                            cost = 1e10; // needs discussion
                        };

                        class increasedStamina: vgm_skillTemplate {
                            displayName = "$STR_VGM_SKILLS_SKILL_AUTORIFLEMAN_INCREASED_STAMINA";

                            cost = 3;
                            codeApply = "player "
                        };
                    };

                    class tier_3 {
                        class strengthTraining: vgm_skillTemplate {
                            displayName = "$STR_VGM_SKILLS_SKILL_AUTORIFLEMAN_STRENGTH_TRAINING";
                            description = "$STR_VGM_SKILLS_SKILL_AUTORIFLEMAN_STRENGTH_TRAINING_DESC";

                            cost = 4;
                        };

                        class learnTheRhythm: vgm_skillTemplate {
                            displayName = "$STR_VGM_SKILLS_SKILL_AUTORIFLEMAN_LEARN_THE_RHYTHM";
                            description = "$STR_VGM_SKILLS_SKILL_AUTORIFLEMAN_LEARN_THE_RHYTHM_DESC";

                            cost = 4;
                        };
                    };

                    class tier_4 {
                        class headsDown: vgm_skillTemplate {
                            displayName = "$STR_VGM_SKILLS_SKILL_AUTORIFLEMAN_HEADS_DOWN";
                            description = "$STR_VGM_SKILLS_SKILL_AUTORIFLEMAN_HEADS_DOWN_DESC";

                            cost = 6;
                        };
                    };
                };
            };

            class sharpshooter {
                displayName = "$STR_VGM_SKILLS_TREE_SHARPSHOOTER";

                class skills {
                    class tier_1 {
                        class hitShrug: vgm_skillTemplate {
                            displayName = "$STR_VGM_SKILLS_SKILL_SHARPSHOOTER_HIT_SHRUG";
                            description = "$STR_VGM_SKILLS_SKILL_SHARPSHOOTER_HIT_SHRUG_DESC";
                            cost = 1e10; // prevent learning until medical system is done
                        };
                    };

                    class tier_2 {
                        class increasedAmmo: vgm_skillTemplate {
                            displayName = "$STR_VGM_SKILLS_SKILL_SHARPSHOOTER_INCREASED_AMMO";
                            description = "$STR_VGM_SKILLS_SKILL_SHARPSHOOTER_INCREASED_AMMO_DESC";
                            cost = 1e10; // prevent learning until custom stamina system is done
                        };

                        class advancedLoadout: vgm_skillTemplate {
                            displayName = "$STR_VGM_SKILLS_SKILL_SHARPSHOOTER_ADVANCED_LOADOUT";
                            description = "$STR_VGM_SKILLS_SKILL_SHARPSHOOTER_ADVANCED_LOADOUT_DESC";
                            cost = 3;
                        };

                        class decreasedRecoil: vgm_skillTemplate {
                            displayName = "$STR_VGM_SKILLS_SKILL_SHARPSHOOTER_DECREASED_RECOIL";
                            cost = 3;
                        };
                    };

                    class tier_3 {
                        class relaxedPosture: vgm_skillTemplate {
                            displayName = "$STR_VGM_SKILLS_SKILL_SHARPSHOOTER_RELAXED_POSTURE";
                            description = "$STR_VGM_SKILLS_SKILL_SHARPSHOOTER_STRENGTH_TRAINING_DESC";
                            cost = 4;
                        };

                        class intentionalShotPlacement: vgm_skillTemplate {
                            displayName = "$STR_VGM_SKILLS_SKILL_SHARPSHOOTER_INTENTIONAL_SHOT_PLACEMENT";
                            description = "$STR_VGM_SKILLS_SKILL_SHARPSHOOTER_INTENTIONAL_SHOT_PLACEMENT_DESC";
                            cost = 4;
                        };
                    };

                    class tier_4 {
                        class steadyAim: vgm_skillTemplate {
                            displayName = "$STR_VGM_SKILLS_SKILL_SHARPSHOOTER_STEADY_AIM_ACTIVE";
                            description = "$STR_VGM_SKILLS_SKILL_SHARPSHOOTER_STEADY_AIM_ACTIVE_DESC";
                            cost = 6;
                        };
                    };
                };
            };
        };
    };

    class serviceEssentials {
        displayName = "$STR_VGM_SKILLS_TREE_SERVICE_ESSENTIALS";

        class skills {
            class tier_1 {
                class stabilizer: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_SERVICE_STABILIZER";
                    cost = 1e10;
                };

                class fastHealing : vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_SERVICE_FAST_HEALING";
                    cost = 1e10;
                };
            };

            class tier_2 {
                class fastReviving: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_SERVICE_FAST_REVIVING";
                    cost = 1e10;
                };

                class basicEquipment: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_SERVICE_BASIC_EQUIPMENT";
                    description = "$STR_VGM_SKILLS_SKILL_SERVICE_BASIC_EQUIPMENT_DESC";
                    cost = 3;
                };

                class fastRepairing: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_SERVICE_FAST_REPAIRING";
                    cost = 1e10;
                };
            };

            class tier_3
            {
                class extraUtility: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_SERVICE_EXTRA_UTILITY";
                    description = "$STR_VGM_SKILLS_SKILL_SERVICE_EXTRA_UTILITY_DESC";
                    cost = 4;
                };

                class abilityLength: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_SERVICE_ABILITY_LENGTH";
                    description = "$STR_VGM_SKILLS_SKILL_SERVICE_ABILITY_LENGTH_DESC";
                    cost = 4;
                };
            };

            class tier_4 {
                class overpacking: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_SERVICE_OVERPACKING";
                    description = "$STR_VGM_SKILLS_SKILL_SERVICE_OVERPACKING_DESC";
                    cost = 6;
                };
            };
        };

        class subtrees {
            class basicAid {
                displayName = "$STR_VGM_SKILLS_TREE_BASIC_AID";

                class skills {
                    class tier_1 {
                        class fastRevivingPassive: vgm_skillTemplate {
                            displayName = "$STR_VGM_SKILLS_SKILL_BASIC_AID_FAST_REVIVING_PASSIVE"
                        };

                        class retainHealingItem: vgm_skillTemplate {
                            displayName = "$STR_VGM_SKILLS_SKILL_BASIC_AID_RETAIN_HEALING_ITEM";
                            description = "$STR_VGM_SKILLS_SKILL_BASIC_AID_RETAIN_HEALING_ITEM_DESC";
                            cost = 1e10;
                        };
                    };

                    class tier_2 {
                        class extraFAKHealing: vgm_skillTemplate {
                            displayName = "$STR_VGM_SKILLS_SKILL_BASIC_AID_EXTRA_FAK_HEALING";
                            description = "$STR_VGM_SKILLS_SKILL_BASIC_AID_EXTRA_FAK_HEALING_DESC";
                            cost = 3;
                        };

                        class intermediateMedTools : vgm_skillTemplate {
                            displayName = "$STR_VGM_SKILLS_SKILL_BASIC_AID_INTERMEDIATE_MED_TOOLS";
                            description = "$STR_VGM_SKILLS_SKILL_BASIC_AID_INTERMEDIATE_MED_TOOLS_DESC";
                            cost = 3;
                        };

                        class moreFAKs: vgm_skillTemplate {
                            displayName = "$STR_VGM_SKILLS_SKILL_BASIC_AID_MORE_FAKS";
                            cost = 3;
                        };
                    };

                    class tier_3 {
                        class morphineShots: vgm_skillTemplate {
                            displayName = "$STR_VGM_SKILLS_SKILL_BASIC_AID_MORPHINE_SHOTS";
                            description = "$STR_VGM_SKILLS_SKILL_BASIC_AID_MORPHINE_SHOTS_DESC";
                            cost = 4;
                        };

                        class hastenedAid: vgm_skillTemplate {
                            displayName = "$STR_VGM_SKILLS_SKILL_BASIC_AID_HASTENED_AID";
                            description = "$STR_VGM_SKILLS_SKILL_BASIC_AID_HASTENED_AID_DESC";
                            cost = 4;
                        };
                    };

                    class tier_4 {
                        class firstAidMastery: vgm_skillTemplate {
                            displayName = "$STR_VGM_SKILLS_SKILL_BASIC_AID_FIRST_AID_MASTERY";
                            description = "$STR_VGM_SKILLS_SKILL_BASIC_AID_FIRST_AID_MASTERY_DESC";
                            cost = 6;
                        };
                    };
                };
            };

            class leadershipTraining
            {
                displayName = "$STR_VGM_SKILLS_TREE_LEADERSHIP_TRAINING";

                class skills {
                    class tier_1 {
                        class slowBleedout {
                            displayName = "$STR_VGM_SKILLS_SKILL_LEADERSHIP_SLOW_BLEEDOUT";
                            cost = 1e10;
                        };

                        class abilityLengthPassive {
                            displayName = "$STR_VGM_SKILLS_SKILL_LEADERSHIP_ABILITY_LENGTH_PASSIVE";
                            cost = 1e10;
                        };
                    };

                    class tier_2 {
                        class squadMedicalTraining {
                            displayName = "$STR_VGM_SKILLS_SKILL_LEADERSHIP_SQUAD_MEDICAL_TRAINING";
                            description = "$STR_VGM_SKILLS_SKILL_LEADERSHIP_SQUAD_MEDICAL_TRAINING_DESC";
                            cost = 1e10;
                        };

                        class squadStamina {
                            displayName = "$STR_VGM_SKILLS_SKILL_LEADERSHIP_SQUAD_STAMINA";
                            cost = 1e10;
                        };

                        class squadIntelGain {
                            displayName = "$STR_VGM_SKILLS_SKILL_LEADERSHIP_SQUAD_INTEL_GAIN";
                            cost = 1e10;
                        };
                    };

                    class tier_3 {
                        class pepTalk {
                            displayName = "$STR_VGM_SKILLS_SKILL_LEADERSHIP_PEP_TALK";
                            description = "$STR_VGM_SKILLS_SKILL_LEADERSHIP_PEP_TALK_DESC";
                            cost = 1e10;
                        };

                        class doubleTime {
                            displayName = "$STR_VGM_SKILLS_SKILL_LEADERSHIP_DOUBLE_TIME";
                            description = "$STR_VGM_SKILLS_SKILL_LEADERSHIP_DOUBLE_TIME_DESC";
                            cost = 1e10;
                        };
                    };

                    class tier_4 {
                        class motivation {
                            displayName = "$STR_VGM_SKILLS_SKILL_LEADERSHIP_MOTIVATION";
                            description = "$STR_VGM_SKILLS_SKILL_LEADERSHIP_MOTIVATION_DESC";
                            cost = 1e10;
                        };
                    };
                };
            }
        };
    };
};
