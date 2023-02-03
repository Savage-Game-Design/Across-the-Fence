#define COLUMN_W 0.25 * VGM_GRID_MAX_W
#define COLUMN_CTRL_W (COLUMN_W - 1)
#define DISPLAY_W (4 * COLUMN_W)
#define DISPLAY_H VGM_GRID_MAX_H
#define DISPLAY_X (CENTER_X - 0.5 * DISPLAY_W * VGM_GRID_W)
#define DISPLAY_Y (CENTER_Y - 0.5 * DISPLAY_H * VGM_GRID_H)

class VGM_DisplayMissions
{
    idd = VGM_IDD_DISPLAYMISSIONS;
    onLoad = ONLOAD;
    class ControlsBackground
    {
        class Background: VGM_ctrlBackground
        {
            x = DISPLAY_X;
            y = DISPLAY_Y;
            w = DISPLAY_W * VGM_GRID_W;
            h = DISPLAY_H * VGM_GRID_H;
        };
    };
    class Controls
    {
        class Map: VGM_ctrlMap
        {
            onLoad = "_this select 0 ctrlEnable false;";
            x = DISPLAY_X;
            y = DISPLAY_Y;
            w = COLUMN_CTRL_W * VGM_GRID_W;
            h = DISPLAY_H * VGM_GRID_H;
        };
        VGM_SET_Y(DISPLAY_H - 30)
#define _X DISPLAY_X + 1 * VGM_GRID_W
#define _W (COLUMN_CTRL_W - 2)
        class Target: VGM_ctrlXListBox
        {
            onLoad = VGM_UIEH(initTargets,Missions);
            x = _X;
            y = VGM_Y(DISPLAY_Y);
            w = _W * VGM_GRID_W;
            h = VGM_Y_H(5);
        };
        class Modifiers: VGM_ctrlStructuredText
        {
            text = "+targetBoxModifiers<br/>+targetBoxModifiers<br/>+targetBoxModifiers";
            x = _X;
            y = VGM_Y_Y(DISPLAY_Y,1);
            w = _W * VGM_GRID_W;
            h = VGM_Y_H(12);
            colorBackground[] = {0.8,0.8,0.8,0.75};
        };
        class FullTargetList: VGM_ctrlButton
        {
            text = "Full Target Box List";
            x = _X;
            y = VGM_Y_Y(DISPLAY_Y,1);
            w = _W * VGM_GRID_W;
            h = 5 * VGM_GRID_H;
        };
        VGM_SET_Y(6)
        class Recon: VGM_ctrlControlsGroup
        {
            x = DISPLAY_X + COLUMN_W * VGM_GRID_W;
            y = VGM_Y(DISPLAY_Y);
            w = COLUMN_CTRL_W * VGM_GRID_W;
            h = VGM_Y_H(COLUMN_W + 10);
            colorBackground[] = {1,0,0,0.2};
            class Controls
            {
                class Status: VGM_ctrlStructuredText
                {
                    text = "Active";
                    x = 0;
                    y = 0;
                    w = COLUMN_CTRL_W * VGM_GRID_W;
                    h = 5 * VGM_GRID_H;
                    colorBackground[] = {1,0,0,0.2};
                };
                class Name: Status
                {
                    text = "Recon";
                    size = VGM_FONT_L * VGM_GRID_H;
                    y = 5 * VGM_GRID_H;
                };
                class Image: VGM_ctrlStaticPicture
                {
                    text = "#(rgb,1,1,1)color(0,1,0,1)";
                    x = 0;
                    y = 10 * VGM_GRID_H;
                    w = COLUMN_CTRL_W * VGM_GRID_W;
                    h = COLUMN_CTRL_W * VGM_GRID_H;
                };
            };
        };
        class Standard: Recon
        {
            x = DISPLAY_X + 2 * COLUMN_W * VGM_GRID_W;
            class Controls: Controls
            {
                class Status: Status
                {
                };
                class Name: Name
                {
                    text = "Standard";
                };
                class Image: Image
                {
                };
            };
        };
        class Elite: Recon
        {
            x = DISPLAY_X + 3 * COLUMN_W * VGM_GRID_W;
            class Controls: Controls
            {
                class Status: Status
                {
                };
                class Name: Name
                {
                    text = "Elite";
                };
                class Image: Image
                {
                };
            };
        };
        class Description: VGM_ctrlStructuredText
        {
            text = "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.";
            x = DISPLAY_X + COLUMN_W * VGM_GRID_W;
            y = VGM_Y(DISPLAY_Y);
            w = (3 * COLUMN_W - 1) * VGM_GRID_W;
            h = VGM_Y_H(16);
            colorBackground[] = {1,0,0,0.2};
        };
        class Generate: VGM_ctrlButton
        {
            text = "Generate";
            sizeEx = 10 * VGM_GRID_H;
            x = DISPLAY_X + (COLUMN_W + 0.75 * COLUMN_W) * VGM_GRID_W;
            y = VGM_Y_Y(DISPLAY_Y,1);
            w = (1.5 * COLUMN_W) * VGM_GRID_W;
            h = 10 * VGM_GRID_H;
            onButtonClick = UIEH(generate,Missions);
        };
        class GenerateConfirmGroup: VGM_ctrlControlsGroupNoScrollbars
        {
            show = 0;
            x = safeZoneX;
            y = safeZoneY;
            w = safeZoneW;
            h = safeZoneH;
            class Controls
            {
                class BackgroundFull: VGM_ctrlStatic
                {
                    x = 0;
                    y = 0;
                    w = safeZoneWAbs;
                    h = safeZoneH;
                    colorBackground[] = {0.3,0.3,0.3,0.8};
                };
#define _MESSAGE_W 0.5 * DISPLAY_W
#define _MESSAGE_H 20
#define _MESSAGE_X 0.5 * safeZoneWAbs - 0.5 * _MESSAGE_W * GRID_W
#define _MESSAGE_Y 0.5 * safeZoneH - 0.5 * _MESSAGE_H * VGM_GRID_H
                class BackgroundMessage: VGM_ctrlStatic
                {
                    x = _MESSAGE_X;
                    y = _MESSAGE_Y;
                    w = _MESSAGE_W * VGM_GRID_W;
                    h = _MESSAGE_H * VGM_GRID_H;
                    colorBackground[] = {0.8,0.8,0.8,1};
                };
                VGM_SET_Y(1)
                class Message: VGM_ctrlStructuredText
                {
                    text = "Generate a Recon mission in targetBoxName?";
                    size = VGM_FONT_L * VGM_GRID_H;
                    x = _MESSAGE_X + 1 * VGM_GRID_W;
                    y = VGM_Y(_MESSAGE_Y);
                    w = (_MESSAGE_W - 2) * VGM_GRID_W;
                    h = VGM_Y_H(5);
                    class Attributes
                    {
                        font = VGM_FONT;
                        color = "#000000";
                        colorLink = "#D09B43";
                        align = "center";
                        shadow = 0;
                    };
                    colorBackground[] = {1,0,0,0.2};
                };
                class Seperator: VGM_ctrlStatic
                {
                    x = _MESSAGE_X;
                    y = VGM_Y_Y(_MESSAGE_Y,1);
                    w = _MESSAGE_W * VGM_GRID_W;
                    h = pixelH;
                    colorBackground[] = {0.5,0.5,0.5,1};
                };
                class Confirm: VGM_ctrlButton
                {
                    text = "Confirm";
                    x = _MESSAGE_X + 40 * VGM_GRID_W;
                    y = VGM_Y_Y(_MESSAGE_Y,1);
                    w = (_MESSAGE_W - 80) * VGM_GRID_W;
                    h = VGM_Y_H(5);
                };
                class Cancel: Confirm
                {
                    text = "Cancel";
                    y = VGM_Y_Y(_MESSAGE_Y,1);
                };
            };
        };
    };
};
