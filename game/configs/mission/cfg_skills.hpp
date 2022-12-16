

class vgm_skillTemplate {
    displayName = "SKILL NAME";
    description = "SKILL DESCRIPTION";
    icon = "";

    isActive = 0;
    applyOnRespawn = 0;

    conditionUnlock = "true";
    codeApply = "systemChat 'skill applied'";
    codeActivate = "systemChat 'skill activated'";
};

class vgm_skillTrees {
    class combatTree {
        // rifleman skills
        class skills {
            class tier_1 {
                class moreStamina: vgm_skillTemplate {
                    codeApply = "_this setUnitTrait ['loadCoef', 2]";
                };

                class steadyAim: vgm_skillTemplate {
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
                class skill_7: vgm_skillTemplate {};
                class skill_8: vgm_skillTemplate {};
            };
        };

        // specializations
        class subtrees {
            class medicTree {
                class skills {
                    class tier_1 {
                        class medicTrait: vgm_skillTemplate {
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
                        class skills {
                            class tier_1 {
                                class skill_1: vgm_skillTemplate {};
                                class skill_2: vgm_skillTemplate {};
                            };
                        };
                    };
                };
            };
        };
    };

    class utility {};
    class social {};
};
