

class vgm_skillTemplate {
    displayName = "SKILL NAME";
    description = "SKILL DESCRIPTION";
    icon = "\vn\ui_f_vietnam\ui\wheelmenu\img\ui_icon_a_ca.paa";

    isActive = 0; // 1 - primary skill, 2 - ultimate skill
    applyOnRespawn = 0;

    cost = 1;
    cooldown = 10;

    conditionUnlock = "true";
    conditionShow = "true";
    codeApply = "systemChat 'skill applied'";
    codeActivate = "systemChat 'skill activated'";
    codeDeactivate = "systemChat 'skill deactivated'";
};

class vgm_skillTrees {
    class combatTree {
        displayName = "Combat";
        // rifleman skills
        class skills {
            class tier_1 {
                class moreStamina: vgm_skillTemplate {
                    displayName = "More Stamina";
                    description = "Increases amount of available stamina.";
                    codeApply = "_this setUnitTrait ['loadCoef', 2]";
                };

                class steadyAim: vgm_skillTemplate {
                    displayName = "Steady Aim";
                    description = "Decreases weapon sway.";
                    codeApply = "_this setCustomAimCoef 0.5";
                };
            };

            class tier_2 {
                class skill_3: vgm_skillTemplate {};
                class skill_4: vgm_skillTemplate {};
            };

            class tier_3 {
                class skill_5: vgm_skillTemplate {};
                class skill_6: vgm_skillTemplate {};
            };

            class tier_4 {
                class fieldHeal: vgm_skillTemplate {
                    displayName = "Field heal";
                    description = "Free healthcare.";
                    isActive = 1;
                };
                class zeusBolt: vgm_skillTemplate {
                    displayName = "Zeus bolt";
                    description = "POWER OF THE GODS!";
                    isActive = 2;

                    cost = 2;
                    cooldown = 30;

                    codeApply = "hint 'boom'";
                };
            };
        };

        // specializations
        class subtrees {
            class medicTree {
                displayName = "Medic";
                class skills {
                    class tier_1 {
                        class medicTrait: vgm_skillTemplate {
                            displayName = "Medic Trait";
                            description = "Allows to use MediKits.";
                            codeApply = "_this setUnitTrait ['Medic', true]";
                        };
                    };

                    class tier_2 {
                        class skill_3: vgm_skillTemplate {};
                        class skill_4: vgm_skillTemplate {};
                    };
                };

                // expertise
                class subtrees {
                    class surgeonTree {
                        displayName = "Surgeon";
                        class skills {
                            class tier_1 {
                                class skill_1: vgm_skillTemplate {};
                                class skill_2: vgm_skillTemplate {};
                            };
                        };
                    };
                };
            };

            class engineerTree {
                displayName = "Engineer";
                class skills {};
            };
        };
    };

    class utilityTree {
        displayName = "Utility";

        class skills {
            class tier_1 {
                class hiddenSkill: vgm_skillTemplate {
                    displayName = "Hidden utility skill";
                    description = "Hidden utility skill.";

                    conditionShow = "false";
                };
                class skill_2: vgm_skillTemplate {};
            };
        };
    };
    class socialTree {
        displayName = "Social";
    };
};
