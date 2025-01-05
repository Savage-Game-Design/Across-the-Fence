
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
            h = 1 * GUI_GRID_H;

            class Controls
            {
                class Test: RscText
                {
                    idc = -1;
                    text = "";
                    x = 0;
                    y = 0;
                    w = 20 * GUI_GRID_W;
                    h = 1 * GUI_GRID_H;

                    colorBackground[] = {1,0,0,1};
                };

                class LevelCurrent: VGM_ctrlStructuredText
                {
                    idc = -1;
                    text = "00";
                    x = 0;
                    y = 0;
                    w = 2 * GUI_GRID_W;
                    h = 1 * GUI_GRID_H;

                    class Attributes: Attributes
                    {
                        align = "right";
                        shadow = 1;
                    };
                };

                class XpProgress: VGM_ctrlProgress
                {
                    idc = -1;
                    x = 2 * GUI_GRID_W;
                    y = 0;
                    w = 16 * GUI_GRID_W;
                    h = 1 * GUI_GRID_H;
                    colorFrame[] = {1,1,1,1};
                };
                class XpText: VGM_ctrlStructuredText
                {
                    idc = -1;
                    text = "- / -";
                    x = 2 * GUI_GRID_W;
                    y = 0;
                    w = 16 * GUI_GRID_W;
                    h = 1 * GUI_GRID_H;
                    class Attributes
                    {
                        font = VGM_FONT;
                        color = "#ffffff";
                        colorLink = "#D09B43";
                        align = "center";
                        shadow = 1;
                    };
                };

                class LevelNext: LevelCurrent
                {
                    idc = -1;
                    x = 2 * GUI_GRID_W + 16 * GUI_GRID_W;

                    class Attributes: Attributes
                    {
                        align = "left";
                    };
                };

            };
        };
    };
};
