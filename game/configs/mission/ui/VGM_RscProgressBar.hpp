#define PROGRESS_BAR_X (GUI_GRID_CENTER_X + GUI_GRID_CENTER_W)
#define PROGRESS_BAR_Y GUI_GRID_CENTER_Y
#define PROGRESS_BAR_W (38 * GUI_GRID_CENTER_W)
#define PROGRESS_BAR_H GUI_GRID_CENTER_H

class VGM_RscProgressBar
{
    idd = -1;
    onLoad = "uiNamespace setVariable ['vgm_rscProgressBar', _this#0]";
    duration = 1e10;
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

        class ProgressBarBackground: RscText
        {
            colorBackground[] = {0,0,0,0.25};

            x = QUOTE(PROGRESS_BAR_X);
            y = QUOTE(PROGRESS_BAR_Y);
            w = QUOTE(PROGRESS_BAR_W);
            h = QUOTE(PROGRESS_BAR_H);
        };

        class ProgressBar: RscProgress
        {
            idc = VGM_IDC_PROGRESSBAR_PROGRESSBAR;

            x = QUOTE(PROGRESS_BAR_X);
            y = QUOTE(PROGRESS_BAR_Y);
            w = QUOTE(PROGRESS_BAR_W);
            h = QUOTE(PROGRESS_BAR_H);
        };

        class Title: RscText
        {
            idc = VGM_IDC_PROGRESSBAR_TITLE;
            style = ST_CENTER;

            text = "<TEXT>";

            x = QUOTE(PROGRESS_BAR_X);
            y = QUOTE(PROGRESS_BAR_Y);
            w = QUOTE(PROGRESS_BAR_W);
            h = QUOTE(PROGRESS_BAR_H);
        };

        class DrawHandler: RscMapControlEmpty
        {
            idc = VGM_IDC_PROGRESSBAR_DRAWHANDLER;
            w = 0;
            h = 0;
        };
    };
};
