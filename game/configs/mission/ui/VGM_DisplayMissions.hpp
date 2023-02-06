#define COLUMN_W VGM_DISPLAYMISSIONS_COLUMN_W
#define COLUMN_CTRL_W VGM_DISPLAYMISSIONS_COLUMN_CTRL_W
#define DISPLAY_W VGM_DISPLAYMISSIONS_W
#define DISPLAY_H VGM_DISPLAYMISSIONS_H
#define DISPLAY_X VGM_DISPLAYMISSIONS_X
#define DISPLAY_Y VGM_DISPLAYMISSIONS_Y

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
            onButtonClick = VGM_UIEH(fullTargetList,Missions);
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
            onButtonClick = VGM_UIEH_SPAWN(generate,Missions);
        };
    };
};
