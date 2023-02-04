#define COLUMN_W 0.25 * VGM_GRID_MAX_W
#define COLUMN_CTRL_W (COLUMN_W - 1)
#define DISPLAY_W (4 * COLUMN_W)
#define DISPLAY_H VGM_GRID_MAX_H
#define DISPLAY_X (CENTER_X - 0.5 * DISPLAY_W * VGM_GRID_W)
#define DISPLAY_Y (CENTER_Y - 0.5 * DISPLAY_H * VGM_GRID_H)

class VGM_DisplayMissions
{
    idd = VGM_IDD_DISPLAYMISSIONS;
    onLoad = VGM_UIEH(onLoad,Missions);
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
            idc = VGM_IDC_DISPLAYMISSIONS_MAP;
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
            idc = VGM_IDC_DISPLAYMISSIONS_TARGET;
            onLoad = VGM_UIEH(initTargets,Missions);
            x = _X;
            y = VGM_Y(DISPLAY_Y);
            w = _W * VGM_GRID_W;
            h = VGM_Y_H(5);
        };
        class Modifiers: VGM_ctrlStructuredText
        {
            idc = VGM_IDC_DISPLAYMISSIONS_MODIFIERS;
            text = "+targetBoxModifiers<br/>+targetBoxModifiers<br/>+targetBoxModifiers";
            x = _X;
            y = VGM_Y_Y(DISPLAY_Y,1);
            w = _W * VGM_GRID_W;
            h = VGM_Y_H(12);
            colorBackground[] = {0.8,0.8,0.8,0.75};
        };
        class FullTargetList: VGM_ctrlButton
        {
            idc = VGM_IDC_DISPLAYMISSIONS_FULLTARGETLIST;
            text = "Full Target Box List";
            x = _X;
            y = VGM_Y_Y(DISPLAY_Y,1);
            w = _W * VGM_GRID_W;
            h = 5 * VGM_GRID_H;
        };
        VGM_SET_Y(6)
        class Recon: VGM_ctrlControlsGroup
        {
            idc = VGM_IDC_DISPLAYMISSIONS_RECON;
            x = DISPLAY_X + COLUMN_W * VGM_GRID_W;
            y = VGM_Y(DISPLAY_Y);
            w = COLUMN_CTRL_W * VGM_GRID_W;
            h = VGM_Y_H(COLUMN_W + 10);
            colorBackground[] = {1,0,0,0.2};
            class Controls
            {
                class Status: VGM_ctrlStructuredText
                {
                    idc = VGM_IDC_DISPLAYMISSIONS_STATUS;
                    text = "Active";
                    x = 0;
                    y = 0;
                    w = COLUMN_CTRL_W * VGM_GRID_W;
                    h = 5 * VGM_GRID_H;
                    colorBackground[] = {1,0,0,0.2};
                };
                class Name: Status
                {
                    idc = VGM_IDC_DISPLAYMISSIONS_NAME;
                    text = "Recon";
                    size = VGM_FONT_L * VGM_GRID_H;
                    y = 5 * VGM_GRID_H;
                };
                class Image: VGM_ctrlButtonPicture
                {
                    idc = VGM_IDC_DISPLAYMISSIONS_IMAGE;
                    text = "#(rgb,1,1,1)color(0,1,0,1)";
                    onButtonClick = VGM_UIEH(selectDifficulty,Missions);
                    x = 0;
                    y = 10 * VGM_GRID_H;
                    w = COLUMN_CTRL_W * VGM_GRID_W;
                    h = COLUMN_CTRL_W * VGM_GRID_H;
                };
            };
        };
        class Standard: Recon
        {
            idc = VGM_IDC_DISPLAYMISSIONS_STANDARD;
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
            idc = VGM_IDC_DISPLAYMISSIONS_ELITE;
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
            idc = VGM_IDC_DISPLAYMISSIONS_DESCRIPTION;
            text = "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.";
            x = DISPLAY_X + COLUMN_W * VGM_GRID_W;
            y = VGM_Y(DISPLAY_Y);
            w = (3 * COLUMN_W - 1) * VGM_GRID_W;
            h = VGM_Y_H(16);
            colorBackground[] = {1,0,0,0.2};
        };
        class Generate: VGM_ctrlButton
        {
            idc = VGM_IDC_DISPLAYMISSIONS_GENERATE;
            text = "Generate";
            sizeEx = 10 * VGM_GRID_H;
            x = DISPLAY_X + (COLUMN_W + 0.75 * COLUMN_W) * VGM_GRID_W;
            y = VGM_Y_Y(DISPLAY_Y,1);
            w = (1.5 * COLUMN_W) * VGM_GRID_W;
            h = 10 * VGM_GRID_H;
            onButtonClick = VGM_UIEH(generate,Missions);
        };

        class Message: VGM_ctrlControlsGroupNoScrollbars
        {
            idc = VGM_IDC_DISPLAYMISSIONS_MESSAGE;
            show = 0;
            x = DISPLAY_X;
            y = DISPLAY_Y;
            w = DISPLAY_W * VGM_GRID_W;
            h = DISPLAY_H * VGM_GRID_H;
            class Controls
            {
                class BackgroundFull: VGM_ctrlStatic
                {
                    x = 0;
                    y = 0;
                    w = DISPLAY_W * VGM_GRID_W;
                    h = DISPLAY_H * VGM_GRID_H;
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
                class Text: VGM_ctrlStructuredText
                {
                    idc = VGM_IDC_DISPLAYMISSIONS_MESSAGE_TEXT;
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
                    idc = VGM_IDC_DISPLAYMISSIONS_MESSAGE_CONFIRM;
                    text = "Confirm";
                    onButtonClick = VGM_UIEH(handleMessage,Missions);
                    x = _MESSAGE_X + 40 * VGM_GRID_W;
                    y = VGM_Y_Y(_MESSAGE_Y,1);
                    w = (_MESSAGE_W - 80) * VGM_GRID_W;
                    h = VGM_Y_H(5);
                };
                class Cancel: Confirm
                {
                    idc = VGM_IDC_DISPLAYMISSIONS_MESSAGE_CANCEL;
                    text = "Cancel";
                    onButtonClick = VGM_UIEH(handleMessage,Missions);
                    y = VGM_Y_Y(_MESSAGE_Y,1);
                };
            };
        };
        VGM_SET_Y(0)
        class Briefing: Message
        {
            idc = VGM_IDC_DISPLAYMISSIONS_BRIEFING;
            show = 1;
            class Controls: Controls
            {
                class BackgroundFull: BackgroundFull
                {
                };
                class BackgroundBriefing: VGM_ctrlBackground
                {
                    x = COLUMN_CTRL_W * VGM_GRID_W;
                    y = VGM_Y_Y(0,0);
                    w = (3 * COLUMN_W + 1) * VGM_GRID_W;
                    h = (DISPLAY_H - 6) * VGM_GRID_H;
                };
#define _X (COLUMN_CTRL_W + 1) * VGM_GRID_W
#define _W (3 * COLUMN_W - 1)
                class Title: VGM_ctrlStructuredText
                {
                    text = "Standard Mission on targetBoxName";
                    x = _X;
                    y = VGM_Y_Y(0,1);
                    w = _W * VGM_GRID_W;
                    h = VGM_Y_H(5);
                    size = 5 * VGM_GRID_H;
                    class Attributes
                    {
                        font = VGM_FONT;
                        color = "#000000";
                        colorLink = "#D09B43";
                        align = "center";
                        shadow = 0;
                    };
                };
                class OperationName: VGM_ctrlStructuredText
                {
                    text = "Operation generatedName";
                    size = VGM_FONT_L * VGM_GRID_H;
                    x = _X;
                    y = VGM_Y_Y(0,1);
                    w = _W * VGM_GRID_W;
                    h = VGM_Y_H(5);
                };
                class Description: OperationName
                {
                    text = "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.";
                    size = VGM_FONT_M * VGM_GRID_H;
                    y = VGM_Y_Y(0,1);
                    h = VGM_Y_H(20);
                };
                class MissionPropertiesText: OperationName
                {
                    text = "Mission Properties:";
                    y = VGM_Y_Y(0,1);
                    h = VGM_Y_H(5);
                };
                class MissionProperties: VGM_ctrlControlsTable
                {
                    onLoad = VGM_UIEH(loadProperties,Missions);
                    x = _X;
                    y = VGM_Y_Y(0,1);
                    w = _W * VGM_GRID_W;
                    h = VGM_Y_H(15);
                    class RowTemplate
                    {
                        class Background
                        {
                            controlBaseClassPath[] = {"VGM_ctrlBackground"};
                            columnX = 1 * VGM_GRID_W;
                            controlOffsetY = 0;
                            columnW = (_W - 1) * VGM_GRID_W;
                            controlH = 5 * VGM_GRID_H;
                        };
                        class Property
                        {
                            controlBaseClassPath[] = {"VGM_ctrlStructuredText"};
                            columnX = 2 * VGM_GRID_W;
                            controlOffsetY = 0;
                            columnW = (_W - 53) * VGM_GRID_W;
                            controlH = 5 * VGM_GRID_H;
                        };
                        class Reveal: Property
                        {
                            controlBaseClassPath[] = {"VGM_ctrlButton"};
                            columnX = (_W - 50) * VGM_GRID_W;
                            columnW = 47 * VGM_GRID_W;
                        };
                    };
                };
#define _W 96
                class Confirm: VGM_ctrlButton
                {
                    text = "Confirm";
                    x = _X + 0 * VGM_GRID_W;
                    y = VGM_Y_Y(0,1);
                    w = _W * VGM_GRID_W;
                    h = 5 * VGM_GRID_H;
                };
                class Discard: Confirm
                {
                    text = "Discard Mission [Intel Penalty]";
                    x = _X + (_W + 1) * VGM_GRID_W;
                };
            };
        };

    };
};
