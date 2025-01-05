
class VGM_RscLevelIndicator
{
    idd = -1;
    onLoad = "['onLoad', _this#0] call vgm_c_fnc_displayLevelIndicator;";
    duration = 1e39;
    fadeIn = 0;
    fadeOut = 0;

    class Controls
    {
        class MainGroup: RscControlsGroupNoScrollbars
        {
            x = GUI_GRID_TOPCENTER_X + 10 * GUI_GRID_W;
            y = GUI_GRID_TOPCENTER_Y + 0.5 * GUI_GRID_H;
            w = 20 * GUI_GRID_W;
            h = 1.5 * GUI_GRID_H;

            class Controls
            {
                class Background: RscText
                {
                    idc = -1;
                    text = "";
                    x = 0;
                    y = 0;
                    w = 20 * GUI_GRID_W;
                    h = 1.5 * GUI_GRID_H;

                    colorBackground[] = {0,0,0,0.4};
                };

                class XpProgress: VGM_ctrlProgress
                {
                    idc = VGM_IDC_LEVEL_INDICATOR_BAR;
                    x = 0 * GUI_GRID_W;
                    y = 0;
                    w = 20 * GUI_GRID_W;
                    h = 0.7 * GUI_GRID_H;

                    colorFrame[] = {0,0,0,1};
                };

                class LevelCurrent: VGM_ctrlStructuredText
                {
                    idc = VGM_IDC_LEVEL_INDICATOR_LEVEL;
                    text = "Level 00";
                    x = 0;
                    y = 0.65 * GUI_GRID_H;
                    w = 6 * GUI_GRID_W;
                    h = 0.8 * GUI_GRID_H;

                    size = 0.8 * GUI_GRID_H;

                    class Attributes: Attributes
                    {
                        align = "left";
                        shadow = 1;
                    };
                };

                class XpText: VGM_ctrlStructuredText
                {
                    idc = VGM_IDC_LEVEL_INDICATOR_XP;
                    text = "- / - XP";
                    x = 6 * GUI_GRID_W;
                    y = 0.65 * GUI_GRID_H;
                    w = 14 * GUI_GRID_W;
                    h = 0.8 * GUI_GRID_H;

                    size = 0.8 * GUI_GRID_H;

                    class Attributes: Attributes
                    {
                        align = "right";
                        shadow = 1;
                    };
                };

            };
        };
    };
};
