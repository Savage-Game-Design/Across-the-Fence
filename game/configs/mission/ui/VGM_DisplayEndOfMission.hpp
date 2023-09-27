#define DW (0.5 * VGM_GRID_MAX_W)
#define DH VGM_GRID_MAX_H
#define DX VGM_GRID_MIN_X + (0.5 * DW) * VGM_GRID_W
#define DY VGM_GRID_MIN_Y
#define SPACING 3

VGM_SET_Y(0)
class VGM_DisplayEndOfMission
{
    idd = VGM_IDD_DISPLAYENDOFMISSION;
    onLoad = VGM_UIEH(onLoad,EndOfMission);
    onUnload = VGM_UIEH(onUnload,EndOfMission);
    class ControlsBackground
    {
        class Background: VGM_ctrlBackground
        {
            x = safeZoneX;
            y = safeZoneY;
            w = safeZoneW;
            h = safeZoneH;
            colorBackground[] = {0,0,0,1};
        };
    };
    class Controls
    {
        class Status: VGM_ctrlTitle
        {
            idc = VGM_IDC_DISPLAYENDOFMISSION_STATUS;
            text = "Mission Sucessful!";
            x = DX + 1 * VGM_GRID_W;
            y = VGM_Y(DY);
            w = (DW - 2) * VGM_GRID_W;
            h = VGM_Y_H(10);
            size = 10 * VGM_GRID_H;
            colorBackground[] = {VGM_UI_COLOR_BACKGROUND_TITLE};
        };
        class LevelCurrent: VGM_ctrlStructuredText
        {
            idc = VGM_IDC_DISPLAYENDOFMISSION_LEVELCURRENT;
            text = "Level 999";
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
            text = "9999 / 9999";
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
        class LevelMessage: VGM_ctrlTitle
        {
            idc = VGM_IDC_DISPLAYENDOFMISSION_LEVELMESSAGE;
            text = "Level Up!";
            x = DX + 1 * VGM_GRID_W;
            y = VGM_Y_Y(DY,SPACING);
            w = (DW - 2) * VGM_GRID_W;
            h = VGM_Y_H(5);
            colorBackground[] = {0,0.7,0,0.8};
        };
        class XpBreakdown: VGM_ctrlStructuredText
        {
            idc = VGM_IDC_DISPLAYENDOFMISSION_XPBREAKDOWN;
            text = "Lorem ipsum dolor sit amet, officia excepteur ex fugiat reprehenderit enim labore culpa sint ad nisi Lorem pariatur mollit ex esse exercitation amet. Nisi anim cupidatat excepteur officia. Reprehenderit nostrud nostrud ipsum Lorem est aliquip amet voluptate voluptate dolor minim nulla est proident. Nostrud officia pariatur ut officia. Sit irure elit esse ea nulla sunt ex occaecat reprehenderit commodo officia dolor Lorem duis laboris cupidatat officia voluptate. Culpa proident adipisicing id nulla nisi laboris ex in Lorem sunt duis officia eiusmod. Aliqua reprehenderit commodo ex non excepteur duis sunt velit enim. Voluptate laboris sint cupidatat ullamco ut ea consectetur et est culpa et culpa duis.";
            x = DX + 1 * VGM_GRID_W;
            y = VGM_Y_Y(DY, SPACING);
            w = (DW - 2) * VGM_GRID_W;
            h = VGM_Y_H(DH - 25 - (4 * SPACING));
        };
        class Continue: VGM_ctrlButton
        {
            idc = IDC_OK;
            text = "Continue";
            x = DX + (0.5 * DW - 25) * VGM_GRID_W;
            y = VGM_Y_Y(DY, SPACING);
            w = 50 * VGM_GRID_W;
            h = VGM_Y_H(5);
        };
    };
};
