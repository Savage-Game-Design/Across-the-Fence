#include "\a3\ui_f\hpp\defineCommonGrids.inc"
#include "inc\macros.inc"
#include "\a3\3den\UI\macroExecs.inc"
#include "inc\macroExecs.inc"

#include "ctrls.hpp"
#include "VGM_DisplaySkills.hpp"
#include "VGM_DisplayAbilities.hpp"
#include "VGM_DisplayMissions.hpp"
#include "VGM_DisplayMissionsTargets.hpp"
class RscTitles
{
    #include "VGM_RscAbilityCooldown.hpp"

    class VGM_RscProgressBar
    {
        idd = -1;
        onLoad = "uiNamespace setVariable ['vgm_rscProgressBar', _this#0]";
        duration = 1e+6;
        fadeIn = 0;
        fadeOut = 0;

        class Controls
        {
            class Background: RscText
            {
                colorBackground[] = {0,0,0,0};
                x = "safezoneXAbs";
                y = "safezoneY";
                w = "safezoneWAbs";
                h = "safezoneH";
            };

            class ProgressBar: ctrlProgress
            {
                idc = VGM_IDC_PROGRESSBAR_PROGRESSBAR;
                colorFrame[] = {0,0,0,0.5};
                colorBar[] = {VGM_UI_COLOR_ACTIVE};
                texture = "#(argb,8,8,3)color(1,1,1,0.7)";

                x = VGM_GRID_MIN_X;
                y = VGM_GRID_MIN_Y;
                w = VGM_GRID_MAX_W * VGM_GRID_W;
                h = VGM_GRID_H * 3.5;
            };

            class Title: ctrlStatic {
                idc = VGM_IDC_PROGRESSBAR_TITLE;
                style = ST_CENTER;
                sizeEx = VGM_FONT_L;
                colorBackground[] = {0,0,0,0.5};

                text = "<TEXT>";

                x = VGM_GRID_MIN_X;
                y = VGM_GRID_MIN_Y;
                w = VGM_GRID_MAX_W * VGM_GRID_W;
                h = VGM_GRID_H * 3;
            };

            class DrawHandler: ctrlMapEmpty
            {
                idc = VGM_IDC_PROGRESSBAR_DRAWHANDLER;
                w = 0;
                h = 0;
            };

        };
    };

};
#include "VGM_DisplayTest.hpp"
