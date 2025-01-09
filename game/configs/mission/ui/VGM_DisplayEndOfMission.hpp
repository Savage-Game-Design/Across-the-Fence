#define DW (0.5 * VGM_GRID_MAX_W)
#define DH VGM_GRID_MAX_H
#define DX VGM_GRID_MIN_X + (0.5 * DW) * VGM_GRID_W
#define DY VGM_GRID_MIN_Y
#define SPACING 5

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
            text = "Mission Successful!";
            x = DX + 1 * VGM_GRID_W;
            y = VGM_Y(DY);
            w = (DW - 2) * VGM_GRID_W;
            h = VGM_Y_H(10);
            size = 10 * VGM_GRID_H;
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
        class XpBreakdown: VGM_ctrlStructuredText
        {
            idc = VGM_IDC_DISPLAYENDOFMISSION_XPBREAKDOWN;
            text = "XP Breakdown text";
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
            colorBackground[] = {VGM_UI_COLOR_BACKGROUND_TITLE};
        };
    };
};
