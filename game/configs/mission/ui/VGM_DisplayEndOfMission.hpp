#define DW (0.5 * VGM_GRID_MAX_W)
#define DH VGM_GRID_MAX_H
#define DX VGM_GRID_MIN_X + (0.5 * DW) * VGM_GRID_W
#define DY VGM_GRID_MIN_Y
#define SPACING 5

class VGM_DisplayEndOfMission
{
    idd = VGM_IDD_DISPLAYENDOFMISSION;
    onLoad = VGM_UIEH(onLoad,EndOfMission);
    onUnload = VGM_UIEH(onUnload,EndOfMission);
    class ControlsBackground
    {
        VGM_SET_Y(0)
        class Black: RscText
        {
            idc = 5001;
            colorBackground[] = {0,0,0,1};
            x = "safezoneXAbs";
            y = "safezoneY";
            w = "safezoneWAbs";
            h = "safezoneH";
        };
        class Table: RscPictureKeepAspect
        {
            // 2048 x 1024
            text = __EVAL(\
                selectRandom [\
                    "\vn\missions_f_vietnam\data\img\debrief\debrief_01.paa",\
                    "\vn\missions_f_vietnam\data\img\debrief\debrief_02.paa",\
                    "\vn\missions_f_vietnam\data\img\debrief\debrief_03.paa",\
                    "\vn\missions_f_vietnam\data\img\debrief\debrief_04.paa",\
                    "\vn\missions_f_vietnam\data\img\debrief\debrief_05.paa",\
                    "\vn\missions_f_vietnam\data\img\debrief\debrief_06.paa",\
                    "\vn\missions_f_vietnam\data\img\debrief\debrief_07.paa"\
                ]\
            );

            x = "safezoneX + safeZoneW/2 - safeZoneH*2/2";
            y = "safezoneY";
            w = "safeZoneH*2";
            h = "safezoneH";
        };
        class TableOverlay: Table
        {
            style = ST_PICTURE;
            text = "#(argb,2048,1024,3)color(0,0,0,1)";
            colorText[] = {1,1,1,0.42};
        };

        class BlackCenter: RscText
        {
            idc = 5001;
            colorBackground[] = {0,0,0,0.55};
            x = DX + 1 * VGM_GRID_W;
            y = VGM_Y(DY);
            w = (DW - 2) * VGM_GRID_W;
            h = VGM_Y_H(DH - SPACING);
        };
    };
    class Controls
    {
        VGM_SET_Y(0)
        class Status: VGM_ctrlTitle
        {
            idc = VGM_IDC_DISPLAYENDOFMISSION_STATUS;
            text = "Mission Successful!";
            x = DX + 1 * VGM_GRID_W;
            y = VGM_Y(DY);
            w = (DW - 2) * VGM_GRID_W;
            h = VGM_Y_H(10);
            size = 10 * VGM_GRID_H;
        };
        class LevelCurrent: VGM_ctrlStructuredText
        {
            idc = VGM_IDC_DISPLAYENDOFMISSION_LEVELCURRENT;
            text = "Level -";
            x = DX + 1 * VGM_GRID_W;
            y = VGM_Y_Y(DY, SPACING);
            w = 25 * VGM_GRID_W;
            h = 5 * VGM_GRID_H;
            class Attributes
            {
                font = VGM_FONT;
                color = "#ffffff";
                colorLink = "#D09B43";
                align = "right";
                shadow = 1;
            };
        };
        class LevelProgress: VGM_ctrlProgress
        {
            idc = VGM_IDC_DISPLAYENDOFMISSION_LEVELPROGRESS;
            x = DX + 27 * VGM_GRID_W;
            y = VGM_Y(DY);
            w = (DW - 2 * 27) * VGM_GRID_W;
            h = 5 * VGM_GRID_H;
            colorFrame[] = {1,1,1,1};
        };
        class XpProgress: VGM_ctrlStructuredText
        {
            idc = VGM_IDC_DISPLAYENDOFMISSION_XPPROGRESS;
            text = "- / -";
            x = DX + (0.5 * DW - 20) * VGM_GRID_W;
            y = VGM_Y(DY);
            w = 40 * VGM_GRID_W;
            h = VGM_Y_H(5);
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
            idc = VGM_IDC_DISPLAYENDOFMISSION_LEVELNEXT;
            x = DX + (DW - 26) * VGM_GRID_W;
            class Attributes
            {
                font = VGM_FONT;
                color = "#ffffff";
                colorLink = "#D09B43";
                align = "left";
                shadow = 1;
            };
        };
#define _W 0.5 * DW
        class LevelMessage: VGM_ctrlTitle
        {
            idc = VGM_IDC_DISPLAYENDOFMISSION_LEVELMESSAGE;
            text = "Level Up!";
            x = DX + (0.5 * DW - 0.5 * _W) * VGM_GRID_W;
            y = VGM_Y_Y(DY,SPACING);
            w = _W * VGM_GRID_W;
            h = VGM_Y_H(5);
            colorBackground[] = {0,0.7,0,0.8};
        };
        class XpBreakdownContainer: VGM_ctrlControlsGroup
        {
            idc = -1;
            x = DX + 1 * VGM_GRID_W;
            y = VGM_Y_Y(DY, SPACING);
            w = (DW - 2) * VGM_GRID_W;
            h = VGM_Y_H(DH - 25 - (4 * SPACING));

            class Controls
            {
                class XpBreakdown: VGM_ctrlStructuredText
                {
                    idc = VGM_IDC_DISPLAYENDOFMISSION_XPBREAKDOWN;
                    text = "XP Breakdown text";
                    x = 0; y = 0;
                    w = (DW - 2) * VGM_GRID_W;
                    h = VGM_Y_H(5); // will be set dynamically
                };
            };
        };
        class Continue: VGM_ctrlButton
        {
            idc = IDC_OK;
            text = "Continue";
            x = DX + (0.5 * DW - 25) * VGM_GRID_W;
            y = VGM_Y_Y(DY, SPACING);
            w = 50 * VGM_GRID_W;
            h = VGM_Y_H(5.5);
            colorBackground[] = {VGM_UI_COLOR_BACKGROUND_TITLE};
        };
    };
};
