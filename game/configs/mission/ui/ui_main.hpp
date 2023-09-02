#include "\a3\ui_f\hpp\defineCommonGrids.inc"
#include "inc\macros.inc"
#include "\a3\3den\UI\macroExecs.inc"
#include "inc\macroExecs.inc"

#include "ctrls.hpp"
#include "VGM_DisplaySkills.hpp"
#include "VGM_DisplayAbilities.hpp"
#include "VGM_DisplayMissions.hpp"
#include "VGM_DisplayMissionsTargets.hpp"
#include "VGM_DisplayMedical.hpp"

import RscHealthTextures from RscTitles;
class RscTitles
{
    #include "VGM_RscAbilityCooldown.hpp"
    #include "VGM_RscProgressBar.hpp"
    class VGM_RscHealthTextures: RscHealthTextures
    {
        onLoad = "uiNamespace setVariable ['vgm_RscHealthTextures', _this select 0]";
    };
};
#include "VGM_DisplayTest.hpp"
