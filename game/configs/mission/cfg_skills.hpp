

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
                class steadyAimPassive: vgm_skillTemplate {
                    displayName = "$STR_VGM_SKILLS_SKILL_RIFLEMAN_INCREASED_ACCURACY";

                    codeApply = "call vgm_c_fnc_skill_increasedAccuracy";
                    codeUnapply = "player setUnitRecoilCoefficient 1";
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
                    codeApply = "call vgm_c_fnc_skill_athletic";
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
                    codeActivate = "call vgm_c_fnc_skill_hoofIt";
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
                            cost = 1e10; // prevent learning until custom stamina system is done
                        };

                        class advancedLoadout: vgm_skillTemplate {
                            displayName = "$STR_VGM_SKILLS_SKILL_AUTORIFLEMAN_ADVANCED_LOADOUT";
                            description = "$STR_VGM_SKILLS_SKILL_AUTORIFLEMAN_ADVANCED_LOADOUT_DESC";
                            cost = 3;
                        };

                        class increasedStamina: vgm_skillTemplate {
                            displayName = "$STR_VGM_SKILLS_SKILL_AUTORIFLEMAN_INCREASED_STAMINA";
                            cost = 3;
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
        displayName = "$STR_VGM_SKILLS_TREE_SERVICEESSENTIALS";

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
            }
        }
    };
};
