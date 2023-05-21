

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

    codeApply = "systemChat 'skill applied'";
    codeUnapply = "systemChat 'skill un-applied'";

    codeActivate = "systemChat 'skill activated'";
};

class vgm_skillTrees {
    class combatTree {
        displayName = "Combat";
        description = "Combat tree description.";
        // rifleman skills
        class skills {
            class tier_1 {
                class steadyAim: vgm_skillTemplate {
                    displayName = "Steady Aim";
                    description = "Decreases weapon sway.";
                    codeApply = "call vgm_c_fnc_skills_apply_steadyAim";
                    skillType = 0;
                    applyOnRespawn = 1;
                };
            };

            class tier_2 {
                class athletic: vgm_skillTemplate {
                    displayName = "Athletic";
                    description = "Decreases stamina comsumption from current weight.";
                    codeApply = "call vgm_c_fnc_skills_apply_athletic";
                    skillType = 0;
                    applyOnRespawn = 1;
                    cost = 3;
                };
            };

            class tier_3 {
                class hoofIt: vgm_skillTemplate {
                    displayName = "Hoof It";
                    description = "Removes stamina cost for 30 seconds.";
                    codeActivate = "call vgm_c_fnc_skills_apply_hoofIt";
                    skillType = 1;
                    cost = 4;
                    cooldown = 150;
                };
            };

            class tier_4 {
                class fieldHeal: vgm_skillTemplate {
                    displayName = "Field heal";
                    description = "Free healthcare.";
                    skillType = 1;
                };
                class zeusBolt: vgm_skillTemplate {
                    displayName = "Zeus bolt";
                    description = "POWER OF THE GODS!";
                    skillType = 2;

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
        description = "Utility tree description.";

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
        description = "Social tree description.";
    };
};
