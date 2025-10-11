#define _W 50
#define _X safeZoneX + safeZoneW - (_W + 1) * VGM_GRID_W
class VGM_DisplayMissionsTargets
{
    idd = VGM_IDD_DISPLAYMISSIONSTARGETS;
    onLoad = VGM_UIEH(onLoad,MissionsTargets);
    class ControlsBackground
    {
        class BackgroundRight: VGM_ctrlBackground
        {
            x = QUOTE(_X - 1 * VGM_GRID_W);
            y = QUOTE(safeZoneY);
            w = QUOTE((_W + 2) * VGM_GRID_W);
            h = QUOTE(safeZoneH);
        };
    };
    class Controls
    {
        class Map: VGM_ctrlMap
        {
            idc = VGM_IDC_DISPLAYMISSIONSTARGET_MAP;
            x = QUOTE(safeZoneX);
            y = QUOTE(safeZoneY);
            w = QUOTE(safeZoneW - ((_W + 2) * VGM_GRID_W));
            h = QUOTE(safeZoneH);
            class Legend // Disabled
            {
                x = 0;
                y = 0;
                w = 0;
                h = 0;
                color[] = {0,0,0,0};
                colorBackground[] = {1,1,1,0};
                font = VGM_FONT;
                sizeEX = 0;
            };
        };
        class Stack: VGM_ctrlStack
        {
            x = QUOTE(_X);
            y = QUOTE(safeZoneY);
            w = QUOTE(_W * VGM_GRID_W);
            h = QUOTE(safeZoneH);
            class Controls
            {
                class Name: VGM_ctrlStructuredText
                {
                    idc = VGM_IDC_DISPLAYMISSIONSTARGET_NAME;
                    text = "dedTargetBoxName";
                    x = 0;
                    w = QUOTE(_W * VGM_GRID_W);
                    h = QUOTE(5 * VGM_GRID_H);
                    size = VGM_FONT_L;
                };
                class Mods: Name
                {
                    idc = VGM_IDC_DISPLAYMISSIONSTARGET_MODS;
                    text = "dedTargetBoxMods";
                    size = VGM_FONT_M;
                    stackFill = 1;
                };
                class Accept: VGM_ctrlButton
                {
                    idc = VGM_IDC_DISPLAYMISSIONSTARGET_ACCEPT;
                    text = "Accept";
                    x = 0;
                    w = QUOTE(_W * VGM_GRID_W);
                    h = QUOTE(5 * VGM_GRID_H);
                };
                class Back: Accept
                {
                    idc = VGM_IDC_DISPLAYMISSIONSTARGET_BACK;
                    text = "Back";
                    onButtonClick = VGM_UIEH(back,MissionsTargets);
                };
            };
        };
    };
};
