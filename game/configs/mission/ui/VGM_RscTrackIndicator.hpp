// Track Indicator HUD — signal-bar meter showing footprint trail visibility
// Mirrors VGM_RscAbilityCooldown positioning to sit directly above the ACTIVES label

#define TRK_ICON_SIZE 3
#define TRK_DISPLAY_W (2 * TRK_ICON_SIZE + 0.5)
#define TRK_DISPLAY_X (safeZoneX + safeZoneW - (TRK_DISPLAY_W + 0.5) * GUI_GRID_W)
#define TRK_DISPLAY_Y (safeZoneY + safeZoneH - (TRK_ICON_SIZE + 0.5) * GUI_GRID_H)

// Bar geometry
#define TRK_BAR_W    (0.8 * GUI_GRID_W)
#define TRK_BAR_GAP  (0.3 * GUI_GRID_W)

// Bottom edge of bars = 0.4 GUI_GRID_H above the ACTIVES label top
// ACTIVES label top is at TRK_DISPLAY_Y - 1.3 * GUI_GRID_H
#define TRK_BAR_BOTTOM (TRK_DISPLAY_Y - 1.7 * GUI_GRID_H)

// Bar heights (increasing signal strength)
#define TRK_BAR1_H (0.4 * GUI_GRID_H)
#define TRK_BAR2_H (0.6 * GUI_GRID_H)
#define TRK_BAR3_H (0.8 * GUI_GRID_H)
#define TRK_BAR4_H (1.0 * GUI_GRID_H)
#define TRK_BAR5_H (1.2 * GUI_GRID_H)

// Total bar group width = 5 bars * 0.8 + 4 gaps * 0.3 = 5.2 GUI_GRID_W
// Right-align within display: offset from right edge of TRK_DISPLAY_W
#define TRK_GROUP_W (5 * 0.8 + 4 * 0.3)
#define TRK_BAR_BASE_X (TRK_DISPLAY_X + (TRK_DISPLAY_W - TRK_GROUP_W) * GUI_GRID_W)

// X position for each bar
#define TRK_BAR1_X TRK_BAR_BASE_X
#define TRK_BAR2_X (TRK_BAR_BASE_X + 1 * (TRK_BAR_W + TRK_BAR_GAP))
#define TRK_BAR3_X (TRK_BAR_BASE_X + 2 * (TRK_BAR_W + TRK_BAR_GAP))
#define TRK_BAR4_X (TRK_BAR_BASE_X + 3 * (TRK_BAR_W + TRK_BAR_GAP))
#define TRK_BAR5_X (TRK_BAR_BASE_X + 4 * (TRK_BAR_W + TRK_BAR_GAP))

// Label sits above the tallest bar
#define TRK_LABEL_H (1.0 * GUI_GRID_H)
#define TRK_LABEL_Y (TRK_BAR_BOTTOM - TRK_BAR5_H - TRK_LABEL_H)

class VGM_RscTrackIndicator
{
    idd = -1;
    onLoad = VGM_UIEH(onLoad,TrackIndicator);
    onUnload = VGM_UIEH(onUnload,TrackIndicator);
    duration = 1e10;
    fadeIn = 0;
    fadeOut = 0;
    class Controls
    {
        class TrackLabel: RscText
        {
            style = 2; // right-align
            text = "$STR_VGM_TRACKING_HUD_LABEL";
            colorText[] = {1,1,1,0.75};
            x = TRK_BAR_BASE_X;
            y = TRK_LABEL_Y;
            w = TRK_GROUP_W * GUI_GRID_W;
            h = TRK_LABEL_H;
        };

        class Bar1: RscText
        {
            idc = VGM_IDC_RSCTRACK_BAR1;
            text = "";
            colorBackground[] = {0.3,0.3,0.3,0.3};
            x = TRK_BAR1_X;
            y = TRK_BAR_BOTTOM - TRK_BAR1_H;
            w = TRK_BAR_W;
            h = TRK_BAR1_H;
        };
        class Bar2: RscText
        {
            idc = VGM_IDC_RSCTRACK_BAR2;
            text = "";
            colorBackground[] = {0.3,0.3,0.3,0.3};
            x = TRK_BAR2_X;
            y = TRK_BAR_BOTTOM - TRK_BAR2_H;
            w = TRK_BAR_W;
            h = TRK_BAR2_H;
        };
        class Bar3: RscText
        {
            idc = VGM_IDC_RSCTRACK_BAR3;
            text = "";
            colorBackground[] = {0.3,0.3,0.3,0.3};
            x = TRK_BAR3_X;
            y = TRK_BAR_BOTTOM - TRK_BAR3_H;
            w = TRK_BAR_W;
            h = TRK_BAR3_H;
        };
        class Bar4: RscText
        {
            idc = VGM_IDC_RSCTRACK_BAR4;
            text = "";
            colorBackground[] = {0.3,0.3,0.3,0.3};
            x = TRK_BAR4_X;
            y = TRK_BAR_BOTTOM - TRK_BAR4_H;
            w = TRK_BAR_W;
            h = TRK_BAR4_H;
        };
        class Bar5: RscText
        {
            idc = VGM_IDC_RSCTRACK_BAR5;
            text = "";
            colorBackground[] = {0.3,0.3,0.3,0.3};
            x = TRK_BAR5_X;
            y = TRK_BAR_BOTTOM - TRK_BAR5_H;
            w = TRK_BAR_W;
            h = TRK_BAR5_H;
        };
    };
};
