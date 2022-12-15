

class vgm_skillTemplate
{
    displayName = "SKILL NAME";
    description = "SKILL DESCRIPTION";
    icon = "";

    isActive = 0;
    applyOnRespawn = 0;

    conditionUnlock = "true";
    codeApply = "systemChat 'skill applied'";
    codeActivate = "systemChat 'skill activated'";
};

class vgm_skillTrees
{
    class riflemanTree
    {
        conditionUnlock = "true";

        class moreStamina: vgm_skillTemplate
        {
            codeApply = "_this setUnitTrait ['loadCoef', 2]";
        };

        class steadyAim: vgm_skillTemplate
        {
            codeApply = "_this setCustomAimCoef 0.5";
        };
    };

    class medicTree
    {
        conditionUnlock = "false";

        class medicTrait: vgm_skillTemplate
        {
            codeApply = "_this setUnitTrait ['Medic', true]";
        };
    };
};
