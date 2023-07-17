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

        class ProgressBarBackground: VGM_ctrlStatic
        {
            colorBackground[] = {0,0,0,0.25};

            x = VGM_GRID_MIN_X + ((VGM_GRID_MAX_W * 0.5) * VGM_GRID_W) * 0.5;
            y = VGM_GRID_MIN_Y;
            w = (VGM_GRID_MAX_W * 0.5) * VGM_GRID_W;
            h = VGM_GRID_H * 3.5;
        };

        class ProgressBar: VGM_ctrlProgress
        {
            idc = VGM_IDC_PROGRESSBAR_PROGRESSBAR;

            x = VGM_GRID_MIN_X + ((VGM_GRID_MAX_W * 0.5) * VGM_GRID_W) * 0.5;
            y = VGM_GRID_MIN_Y;
            w = (VGM_GRID_MAX_W * 0.5) * VGM_GRID_W;
            h = VGM_GRID_H * 3.5;
        };

        class Title: VGM_ctrlStatic
        {
            idc = VGM_IDC_PROGRESSBAR_TITLE;
            style = ST_CENTER;
            sizeEx = VGM_FONT_S;

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
