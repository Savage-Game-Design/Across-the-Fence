#define DISPLAY_W (6 * SLOT_H + 7)
#define DISPLAY_H VGM_GRID_MAX_H
#define DISPLAY_X (safeZoneX + 1 * VGM_GRID_W)
#define DISPLAY_Y CENTER_Y - 0.5 * DISPLAY_H * VGM_GRID_H
#define SLOT_SMALL_H 12
#define SLOT_H (2 * SLOT_SMALL_H + 1)
class VGM_DisplayEquipment
{
    idd = -1;
    onLoad = VGM_UIEH(onLoad,Equipment);
    class ControlsBackground
    {
        class BackgroundLeft: VGM_ctrlBackground
        {
            x = DISPLAY_X;
            y = DISPLAY_Y;
            w = (6 * SLOT_H + 7) * VGM_GRID_W;
            h = DISPLAY_H * VGM_GRID_H;
        };
        class FrameLeft: VGM_ctrlFrame
        {
            x = DISPLAY_X;
            y = DISPLAY_Y;
            w = (6 * SLOT_H + 7) * VGM_GRID_W;
            h = DISPLAY_H * VGM_GRID_H;
        };
        /* class BackgroundRight: BackgroundLeft */
        /* { */
        /*     x = DISPLAY_X + (0.5 * DISPLAY_W + 1) * VGM_GRID_W; */
        /* }; */
        /* class FrameRight: FrameLeft */
        /* { */
        /*     x = DISPLAY_X + (0.5 * DISPLAY_W + 1) * VGM_GRID_W; */
        /* }; */
        class BackgroundLevelProgress: VGM_ctrlBackground
        {
            x = DISPLAY_X + 7 * VGM_GRID_H;
            y = DISPLAY_Y + 9 * VGM_GRID_H;
            w = (0.5 * DISPLAY_W - 19) * VGM_GRID_W;
            h = 1 * VGM_GRID_H;
        };
    };
    class Controls
    {
        VGM_SET_Y(0)
        class Name: VGM_ctrlStructuredTextCentered
        {
            idc = VGM_IDC_DISPLAYEQUIPMENT_NAME;
            text = "Private Ace ""The Bronco"", Level 4";
            x = DISPLAY_X + 1 * VGM_GRID_W;
            y = VGM_Y_Y(DISPLAY_Y,1);
            w = (DISPLAY_W - 2) * VGM_GRID_W;
            h = VGM_Y_H(5);
        };
        class LevelCurrent: VGM_ctrlStructuredTextCentered
        {
            idc = VGM_IDC_DISPLAYEQUIPMENT_LEVELCURRENT;
            text = "99";
            x = DISPLAY_X + 1 * VGM_GRID_W;
            y = VGM_Y_Y(DISPLAY_Y,1);
            w = 7 * VGM_GRID_W;
            h = 5 * VGM_GRID_H;
        };
        class LevelNext: LevelCurrent
        {
            idc = VGM_IDC_DISPLAYEQUIPMENT_LEVELNEXT;
            x = DISPLAY_X + (DISPLAY_W - 8) * VGM_GRID_W;
        };
        class LevelProgress: VGM_ctrlProgress
        {
            idc = VGM_IDC_DISPLAYEQUIPMENT_LEVELPROGRESS;
            onLoad = "(_this select 0) progressSetPosition 0.25";
            x = DISPLAY_X + 7 * VGM_GRID_H;
            y = VGM_Y_Y(DISPLAY_Y,2);
            w = (DISPLAY_W - 19) * VGM_GRID_W;
            h = VGM_Y_H(1);
        };
        class LevelXP: VGM_ctrlStructuredTextCentered
        {
            idc = VGM_IDC_DISPLAYEQUIPMENT_LEVELXP;
            text = "9999/9999 EXP";
            x = DISPLAY_X + 7 * VGM_GRID_H;
            y = VGM_Y_Y(DISPLAY_Y,0);
            w = (DISPLAY_W - 19) * VGM_GRID_W;
            h = VGM_Y_H(3);
            size = 3 * VGM_GRID_H;
        };

        class RifleLabel: VGM_ctrlStructuredText
        {
            idc = VGM_IDC_DISPLAYEQUIPMENT_RIFLELABEL;
            text = "M16A1 Rifle";
            x = DISPLAY_X + (SLOT_H + 2) * VGM_GRID_W;
            y = VGM_Y_Y(DISPLAY_Y,1);
            w = 2 * SLOT_H * VGM_GRID_W;
            h = VGM_Y_H(5);
        };
        class Backpack: VGM_ctrlButtonPictureKeepAspect
        {
            idc = VGM_IDC_DISPLAYEQUIPMENT_BACKPACK;
            text = "\vn\characters_f_vietnam\ui\icon_vn_b_pack_01_ca.paa";
            colorBackground[] = {VGM_UI_COLOR_INACTIVE};
            x = DISPLAY_X + 1 * VGM_GRID_W;
            y = VGM_Y_Y(DISPLAY_Y,0);
            w = SLOT_H * VGM_GRID_W;
            h = SLOT_H * VGM_GRID_H;
        };
        class Rifle: Backpack
        {
            idc = VGM_IDC_DISPLAYEQUIPMENT_RIFLE;
            text = "\vn\weapons_f_vietnam\ui\icon_vn_m16_ca.paa";
            x = DISPLAY_X + (SLOT_H + 2) * VGM_GRID_W;
            w = 2 * SLOT_H * VGM_GRID_W;
        };
        class RifleOptic: Backpack
        {
            idc = VGM_IDC_DISPLAYEQUIPMENT_RIFLEOPTIC;
            x = DISPLAY_X + (3 * SLOT_H + 3) * VGM_GRID_W;
            w = SLOT_SMALL_H * VGM_GRID_W;
            h = SLOT_SMALL_H * VGM_GRID_H;
        };
        class RifleAttachment: RifleOptic
        {
            idc = VGM_IDC_DISPLAYEQUIPMENT_RIFLEATTACHMENT;
            x = DISPLAY_X + (3 * SLOT_H + SLOT_SMALL_H + 4) * VGM_GRID_W;
            h = VGM_Y_H(SLOT_SMALL_H);
        };
        class RifleMagazine: RifleOptic
        {
            idc = VGM_IDC_DISPLAYEQUIPMENT_RIFLEMAGAZINE;
            y = VGM_Y_Y(DISPLAY_Y,1);
        };
        class RifleMagazineCount: VGM_ctrlControlsGroupNoScrollbars
        {
            idc = VGM_IDC_DISPLAYEQUIPMENT_RIFLEMAGAZINECOUNT;
            x = DISPLAY_X + (3 * SLOT_H + 2 * SLOT_SMALL_H + 5) * VGM_GRID_W;
            y = VGM_Y_Y(DISPLAY_Y,-0.5 * SLOT_SMALL_H);
            w = (3 * SLOT_SMALL_H) * VGM_GRID_W;
            h = VGM_Y_H(SLOT_SMALL_H);
            class Controls
            {
                class Decrease: VGM_ctrlButtonPicture
                {
                    idc = VGM_IDC_DISPLAYEQUIPMENT_RIFLEMAGAZINECOUNT_DECREASE;
                    text = "\a3\ui_f\data\GUI\RscCommon\RscHTML\arrow_left_ca.paa";
                    x = 0;
                    y = 0;
                    w = 0.5 * SLOT_SMALL_H * VGM_GRID_W;
                    h = SLOT_SMALL_H * VGM_GRID_H;
                    colorBackground[] = {0,0,0,0};
                    colorBackgroundActive[] = {1,1,1,0.1};
                    colorText[] = {0,0,0,1};
                };
                class Image: VGM_ctrlStaticPicture
                {
                    idc = VGM_IDC_DISPLAYEQUIPMENT_RIFLEMAGAZINECOUNT_IMAGE;
                    text = "\a3\3den\Data\Displays\Display3DENMsgBox\picture_ca.paa";
                    x = 0.5 * SLOT_SMALL_H * VGM_GRID_W;
                    y = 0;
                    w = SLOT_SMALL_H * VGM_GRID_W;
                    h = SLOT_SMALL_H * VGM_GRID_H;
                };
                class Count: VGM_ctrlStatic
                {
                    idc = VGM_IDC_DISPLAYEQUIPMENT_RIFLEMAGAZINECOUNT_COUNT;
                    text = "99";
                    style = ST_RIGHT;
                    x = (1.5 * SLOT_SMALL_H) * VGM_GRID_W;
                    y = 0;
                    w = SLOT_SMALL_H * VGM_GRID_W;
                    h = SLOT_SMALL_H * VGM_GRID_H;
                    font = VGM_FONT;
                    shadow = 0;
                    sizeEx = 0.75 * SLOT_SMALL_H * VGM_GRID_H;
                };
                class Increase: Decrease
                {
                    idc = VGM_IDC_DISPLAYEQUIPMENT_RIFLEMAGAZINECOUNT_INCREASE;
                    text = "\a3\ui_f\data\GUI\RscCommon\RscHTML\arrow_right_ca.paa";
                    x = 2.5 * SLOT_SMALL_H * VGM_GRID_W;
                };
            };
        };


        class LauncherLabel: RifleLabel
        {
            idc = VGM_IDC_DISPLAYEQUIPMENT_LAUNCHERLABEL;
            text = "None";
            y = VGM_Y_Y(DISPLAY_Y,0.5 * SLOT_SMALL_H + 1);
        };
        class Uniform: Backpack
        {
            idc = VGM_IDC_DISPLAYEQUIPMENT_UNIFORM;
            y = VGM_Y_Y(DISPLAY_Y,5);
        }
        class Launcher: Rifle
        {
            idc = VGM_IDC_DISPLAYEQUIPMENT_LAUNCHER;
            y = VGM_Y_Y(DISPLAY_Y,0);
        };
        class LauncherOptic: RifleOptic
        {
            idc = VGM_IDC_DISPLAYEQUIPMENT_LAUNCHEROPTIC;
            y = VGM_Y_Y(DISPLAY_Y,0);
        };
        class LauncherMagazineCount: RifleMagazineCount
        {
            idc = VGM_IDC_DISPLAYEQUIPMENT_LAUNCHERMAGAZINECOUNT;
            y = VGM_Y_Y(DISPLAY_Y,0.5 * SLOT_SMALL_H);
        };
        class LauncherMagazine: RifleMagazine
        {
            idc = VGM_IDC_DISPLAYEQUIPMENT_LAUNCHERMAGAZINE;
            y = VGM_Y_Y(DISPLAY_Y,0.5 * SLOT_SMALL_H + 1);
        };


        class ExplosiveLabel: RifleLabel
        {
            idc = VGM_IDC_DISPLAYEQUIPMENT_EXPLOSIVELABEL;
            text = "Frag Grenade";
            y = VGM_Y_Y(DISPLAY_Y,SLOT_SMALL_H + 1);
            w = SLOT_H * VGM_GRID_W;
        };
        class HandgunLabel: ExplosiveLabel
        {
            idc = VGM_IDC_DISPLAYEQUIPMENT_HANDGUNLABEL;
            text = "M1911A1";
            x = DISPLAY_X + (2 * SLOT_H + 3) * VGM_GRID_W;
        };

        class Headwear: Backpack
        {
            idc = VGM_IDC_DISPLAYEQUIPMENT_HEADWEAR;
            y = VGM_Y_Y(DISPLAY_Y,5);
        };

        class Explosive: Rifle
        {
            idc = VGM_IDC_DISPLAYEQUIPMENT_EXPLOSIVE;
            y = VGM_Y_Y(DISPLAY_Y,0);
            w = SLOT_H * VGM_GRID_W;
        };
        class Handgun: Explosive
        {
            idc = VGM_IDC_DISPLAYEQUIPMENT_HANDGUN;
            x = DISPLAY_X + (2 * SLOT_H + 3) * VGM_GRID_W;
        };
        class HandgunOptic: RifleOptic
        {
            idc = VGM_IDC_DISPLAYEQUIPMENT_HANDGUNOPTIC;
            x = DISPLAY_X + (3 * SLOT_H + 4) * VGM_GRID_W;
            y = VGM_Y_Y(DISPLAY_Y,0);
        };
        class HandgunMagazineCount: RifleMagazineCount
        {
            idc = VGM_IDC_DISPLAYEQUIPMENT_HANDGUNMAGAZINECOUNT;
            y = VGM_Y_Y(DISPLAY_Y,0.5 * SLOT_SMALL_H);
        };
        class HandgunMagazine: RifleMagazine
        {
            idc = VGM_IDC_DISPLAYEQUIPMENT_HANDGUNMAGAZINE;
            x = DISPLAY_X + (3 * SLOT_H + 4) * VGM_GRID_W;
            y = VGM_Y_Y(DISPLAY_Y,0.5 * SLOT_SMALL_H + 1);
        };

        class Utility1: Backpack
        {
            idc = VGM_IDC_DISPLAYEQUIPMENT_UTILITY1;
            x = DISPLAY_X + 1 * VGM_GRID_W;
            y = VGM_Y_Y(DISPLAY_Y,SLOT_SMALL_H + 5);
        };
        class Utility2: Utility1
        {
            idc = VGM_IDC_DISPLAYEQUIPMENT_UTILITY2;
            x = DISPLAY_X + (2 + SLOT_H) * VGM_GRID_W;
        };
        class Utility3: Utility1
        {
            idc = VGM_IDC_DISPLAYEQUIPMENT_UTILITY3;
            x = DISPLAY_X + (3 + 2 * SLOT_H) * VGM_GRID_W;
        };
        class Utility4: Utility1
        {
            idc = VGM_IDC_DISPLAYEQUIPMENT_UTILITY4;
            x = DISPLAY_X + (4 + 3 * SLOT_H) * VGM_GRID_W;
        };
        class Utility5: Utility1
        {
            idc = VGM_IDC_DISPLAYEQUIPMENT_UTILITY5;
            x = DISPLAY_X + (5 + 4 * SLOT_H) * VGM_GRID_W;
        };
        class Utility6: Utility1
        {
            idc = VGM_IDC_DISPLAYEQUIPMENT_UTILITY6;
            x = DISPLAY_X + (6 + 5 * SLOT_H) * VGM_GRID_W;
        };

        class Load: VGM_ctrlControlsGroupNoScrollbars
        {
#define _W 40
            idc = VGM_IDC_DISPLAYEQUIPMENT_LOAD;
            text = "Equipment Load<br/><t size='1.5'>Light</t>";
            x = DISPLAY_X + (DISPLAY_W + 1) * VGM_GRID_W;
            y = DISPLAY_Y;
            w = _W * VGM_GRID_W;
            h = 13 * VGM_GRID_H;
            class Controls
            {
                class Background: VGM_ctrlBackground
                {
                    x = 0;
                    y = 0;
                    w = _W * VGM_GRID_W;
                    h = 13 * VGM_GRID_H;
                };
                class Frame: VGM_ctrlFrame
                {
                    x = 0;
                    y = 0;
                    w = _W * VGM_GRID_W;
                    h = 13 * VGM_GRID_H;
                };
                class Label: VGM_ctrlStructuredTextCentered
                {
                    text = "Equipment Load";
                    x = 0;
                    y = 0;
                    w = _W * VGM_GRID_W;
                    h = 5 * VGM_GRID_H;
                };
                class Value: Label
                {
                    idc = VGM_IDC_DISPLAYEQUIPMENT_LOAD_VALUE;
                    text = "Light";
                    y = 5 * VGM_GRID_H;
                    h = 7 * VGM_GRID_H;
                    class Attributes
                    {
                        font = VGM_FONT;
                        color = "#ffffff";
                        colorLink = "#D09B43";
                        align = "center";
                        shadow = 0;
                        size = 1.5;
                    };
                };
                class Progress: VGM_ctrlProgress
                {
                    idc = VGM_IDC_DISPLAYEQUIPMENT_LOAD_PROGRESS;
                    onLoad = "(_this#0) progressSetPosition 0.25";
                    x = 0;
                    y = 12 * VGM_GRID_H;
                    w = _W * VGM_GRID_W;
                    h = 1 * VGM_GRID_H;
                };
            };
        };
VGM_SET_Y(0)
        class BuildSummary: Load
        {
#define _H (7 * 5 + 2)
            idc = VGM_IDC_DISPLAYEQUIPMENT_BUILDSUMMARY;
            y = DISPLAY_Y + (DISPLAY_H - _H) * VGM_GRID_H;
            h = _H * VGM_GRID_H;
            class Controls: Controls
            {
                class Background: Background
                {
                    h = _H * VGM_GRID_H;
                };
                class Frame: Frame
                {
                    h = _H * VGM_GRID_H;
                };
                class Label: VGM_ctrlStructuredText
                {
                    text = "Build Summary:";
                    x = 0;
                    y = 0;
                    w = _W * VGM_GRID_W;
                    h = VGM_Y_H(5);
                };
                class Rifleman: Label
                {
                    text = "Rifleman:";
                    y = VGM_Y_Y(0,0);
                    w = (_W - 7) * VGM_GRID_W;
                };
                class RiflemanPoints: Rifleman
                {
                    idc = VGM_IDC_DISPLAYEQUIPMENT_BUILDSUMMARY_RIFLEMANPOINTS;
                    text = "99";
                    x = (_W - 7) * VGM_GRID_W;
                    w = 7 * VGM_GRID_W;
                    class Attributes
                    {
                        font = VGM_FONT;
                        color = "#ffffff";
                        colorLink = "#D09B43";
                        align = "right";
                        shadow = 0;
                    };
                };
                class ServiceEssentials: Rifleman
                {
                    text = "Service Essentials:";
                    y = VGM_Y_Y(0,5);
                };
                class ServiceEssentialsPoints: RiflemanPoints
                {
                    idc = VGM_IDC_DISPLAYEQUIPMENT_BUILDSUMMARY_SERVICEPOINTS;
                    y = VGM_Y_Y(0,0);
                };
                class BasicAid: Rifleman
                {
                    text = "Basic Aid";
                    y = VGM_Y_Y(0,5);
                };
                class BasicAidPoints: RiflemanPoints
                {
                    idc = VGM_IDC_DISPLAYEQUIPMENT_BUILDSUMMARY_BASICAIDPOINTS;
                    y = VGM_Y_Y(0,0);
                };
                class Autorifleman: Rifleman
                {
                    text = "Autorifleman";
                    y = VGM_Y_Y(0,5);
                };
                class AutoriflemanPoints: RiflemanPoints
                {
                    idc = VGM_IDC_DISPLAYEQUIPMENT_BUILDSUMMARY_AUTORIFLEMANPOINTS;
                    y = VGM_Y_Y(0,0);
                };
                class Marksman: Rifleman
                {
                    text = "Marksman";
                    y = VGM_Y_Y(0,5);
                };
                class MarksmanPoints: RiflemanPoints
                {
                    idc = VGM_IDC_DISPLAYEQUIPMENT_BUILDSUMMARY_MARKSMANPOINTS;
                    y = VGM_Y_Y(0,0);
                };
                class Seperator: VGM_ctrlSeperator
                {
                    x = 1 * VGM_GRID_W;
                    y = VGM_Y_Y(0,6);
                    w = (_W - 2) * VGM_GRID_W;
                };
                class Total: Rifleman
                {
                    text = "Total";
                    y = VGM_Y_Y(0,1);
                };
                class TotalPoints: RiflemanPoints
                {
                    idc = VGM_IDC_DISPLAYEQUIPMENT_BUILDSUMMARY_TOTALPOINTS;
                    y = VGM_Y_Y(0,0);
                };
            };
        };

#define _W 40
#define _H 100
VGM_SET_Y(0)
        class AdvancedStats: VGM_ctrlControlsGroupNoScrollbars
        {
            idc = VGM_IDC_DISPLAYEQUIPMENT_ADVANCEDSTATS;
            x = safeZoneX + safeZoneW - 40 * VGM_GRID_W;
            y = (DISPLAY_Y + 0.5 * DISPLAY_H * VGM_GRID_H) - 0.5 * _H * VGM_GRID_H;
            w = _W * VGM_GRID_W;
            h = _H * VGM_GRID_H;
            class Controls
            {
                class Background: VGM_ctrlBackground
                {
                    x = 0;
                    y = 0;
                    w = _W * VGM_GRID_W;
                    h = _H * VGM_GRID_H;
                };
                class Frame: VGM_ctrlFrame
                {
                    x = 0;
                    y = 0;
                    w = _W * VGM_GRID_W;
                    h = _H * VGM_GRID_H;
                };
                class Title: VGM_ctrlStructuredText
                {
                    text = "Advanced Stats";
                    x = 0;
                    y = VGM_Y_Y(0,0);
                    w = _W * VGM_GRID_W;
                    h = VGM_Y_H(5);
                };
                class List: VGM_ctrlControlsTable
                {
                    idc = VGM_IDC_DISPLAYEQUIPMENT_ADVANCEDSTATS_LIST;
                    firstIDC = VGM_IDC_DISPLAYEQUIPMENT_ADVANCEDSTATS_LIST_FIRSTIDC;
                    lastIDC = VGM_IDC_DISPLAYEQUIPMENT_ADVANCEDSTATS_LIST_LASTIDC;
                    x = 0;
                    y = VGM_Y_Y(0,0);
                    w = _W * VGM_GRID_W;
                    h = VGM_Y_H(_H - 10);
                    class RowTemplate
                    {
                        class Name
                        {
                            controlBaseClasspath[] = {"VGM_ctrlStructuredText"};
                            columnX = 0;
                            controlOffsetY = 0;
                            columnW = 0.75 * _W * VGM_GRID_W;
                            controlH = 5 * VGM_GRID_H;
                        };
                        class Value: Name
                        {
                            columnX = 0.75 * _W * VGM_GRID_W;
                            columnW = 0.25 * _W * VGM_GRID_W;
                        };
                    };
                };
                class Hide: VGM_ctrlButton
                {
                    text = "Hide";
                    x = 0;
                    y = VGM_Y_Y(0,0);
                    w = _W * VGM_GRID_W;
                    h = 5 * VGM_GRID_H;
                };
            };
        };

        class Cosmetics: VGM_ctrlButton
        {
            idc = VGM_IDC_DISPLAYEQUIPMENT_COSMETICS;
            text = "Change Cosmetics";
            x = DISPLAY_X + (DISPLAY_W + 43) * VGM_GRID_W;
            y = DISPLAY_Y + (DISPLAY_H - 5) * VGM_GRID_H;
            w = 40 * VGM_GRID_W;
            h = 5 * VGM_GRID_H;
        };
    };
};
