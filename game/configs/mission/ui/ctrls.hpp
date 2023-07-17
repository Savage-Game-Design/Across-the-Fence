import RscText;
import RscPicture;
import RscProgress;
import RscStructuredText;
import ctrlDefault;
import ctrlStatic;
import ctrlStructuredText;
import ctrlTree;
import ctrlControlsGroup;
import ctrlControlsGroupNoScrollbars;
import ctrlButton;
import ctrlButtonPicture;
import ctrlStaticFrame;
import ctrlStaticPicture;
import ctrlMap;
import ctrlMapEmpty;
import ctrlProgress;
import ctrlXListbox;

#define COLOR_BLACK {0,0,0,1}
class VGM_ctrlDefault: ctrlDefault {
    class ScrollBar
    {
        width = 0;
        height = 0;
        scrollSpeed = 0.06;
        arrowEmpty = "\a3\3DEN\Data\Controls\ctrlDefault\arrowEmpty_ca.paa";
        arrowFull = "\a3\3DEN\Data\Controls\ctrlDefault\arrowFull_ca.paa";
        border = "\a3\3DEN\Data\Controls\ctrlDefault\border_ca.paa";
        thumb = "\a3\3DEN\Data\Controls\ctrlDefault\thumb_ca.paa";
        color[] = {1,1,1,1};
    };
};
class VGM_ctrlStatic: ctrlStatic {};

class VGM_ctrlStaticFrame: ctrlStaticFrame
{
    colorText[] = COLOR_BLACK;
};

class VGM_ctrlBackground: VGM_ctrlStatic
{
    colorBackground[] = {VGM_UI_COLOR_BACKGROUND};
};

class VGM_ctrlBackgroundTitle: VGM_ctrlBackground
{
    colorBackground[] = {VGM_UI_COLOR_BACKGROUND_TITLE};
};

class VGM_ctrlStaticPicture: ctrlStaticPicture
{
};

class VGM_ctrlStructuredText : ctrlStructuredText
{
#ifdef __A3_DEBUG__
    // colorBackground[] = {1,0,0,0.2};
#endif
    size = VGM_FONT_M;
    shadow = 0;
    class Attributes
    {
        font = VGM_FONT;
        color = "#ffffff";
        colorLink = "#D09B43";
        align = "left";
        shadow = 0;
    };
};

class VGM_ctrlTitle: VGM_ctrlStructuredText
{
    size = VGM_FONT_M;
    class Attributes
    {
        font = VGM_FONT;
        color = "#ffffff";
        colorLink = "#D09B43";
        align = "center";
        shadow = 0;
    };
};

class VGM_ctrlTree: ctrlTree
{
    colorText[] = COLOR_BLACK;
    colorBorder[] = COLOR_BLACK;
    colorLines[] = COLOR_BLACK;
    colorArrow[] = COLOR_BLACK;
    hiddenTexture = "";
    expandedTexture = "";
    font = VGM_FONT;
    sizeEx = VGM_FONT_M;
};

class VGM_ctrlControlsGroup: ctrlControlsGroup
{
};

class VGM_ctrlControlsGroupNoScrollbars: ctrlControlsGroupNoScrollbars
{
};

class VGM_ctrlFrame: VGM_ctrlStatic
{
    style = ST_FRAME;
    colorText[] = {0,0,0,1};
};

class VGM_ctrlFramePicture: VGM_ctrlFrame
{
    colorText[] = {1,1,1,1};
};

class VGM_ctrlButton: ctrlButton
{
    colorBackground[] = {VGM_UI_COLOR_BACKGROUND_DESELECTED};
    colorText[] = {VGM_UI_COLOR_TEXT};
    colorBackgroundActive[] = {VGM_UI_COLOR_ACTIVE};
    font = VGM_FONT;
    sizeEx = VGM_FONT_M;
};

class VGM_ctrlButtonPicture: ctrlButtonPicture
{
};

class VGM_ctrlButtonInvisible: VGM_ctrlButton
{
    colorBackground[] = {0,0,0,0};
    color[] = {0,0,0,0};
    colorBackgroundActive[] = {0,0,0,0};
    colorBackgroundDisabled[] = {0,0,0,0};
    colorFocused[] = {0,0,0,0};
    colorFocused2[] = {0,0,0,0};
};

class VGM_ctrlControlsTable: VGM_ctrlDefault
{
    idc = -1;
    type = CT_CONTROLS_TABLE;
    style = ST_LEFT;
    firstIDC = 900;
    lastIDC = 999;
    headerHeight = 5 * VGM_GRID_H;
    lineSpacing = 1 * VGM_GRID_H;
    rowHeight = 5 * VGM_GRID_H;
    selectedRowAnimLength = 7.5;
    selectedRowColorFrom[] = {VGM_UI_COLOR_ACTIVE};
    selectedRowColorTo[] = {VGM_UI_COLOR_ACTIVE};
    class HeaderTemplate
    {
    };
    class RowTemplate
    {
        class Example
        {
            controlBaseClassPath[] = {"VGM_ctrlStructuredText"};
            columnX = 0;
            controlOffsetY = 0;
            columnW = 1;
            controlH = 1;
        };
    };
    class VScrollbar: ScrollBar
    {
        width = 2 * VGM_GRID_W;
    };
    class HScrollbar: ScrollBar
    {
        height = 0;
    };
};

class VGM_ctrlMap: ctrlMap
{
};

class VGM_ctrlXListBox: ctrlXListbox
{
    sizeEx = VGM_FONT_M;
    font = VGM_FONT;
};

class VGM_ctrlStack: VGM_ctrlControlsGroupNoScrollbars
{
    onLoad = "_this call vgm_c_fnc_stack_controls;";
    stackMargin = 1 * VGM_GRID_H;
    stackDisable = 0;
    stackFill = 0;
};

class VGM_ctrlSeperator: VGM_ctrlStatic
{
    h = pixelH;
    w = pixelW;
    colorBackground[] = {0.75,0.75,0.75,1};
};

// Controls for VGM_DisplaySkills
class VGM_ctrlSkillTreeBranchV: VGM_ctrlStatic
{
    x = 0;
    y = 0;
    w = 1 * VGM_GRID_W;
    h = 3 * VGM_GRID_H;
    colorBackground[] = {0.8,0.8,0.8,1};
};
class VGM_ctrlSkillTreeBranchH: VGM_ctrlSkillTreeBranchV
{
    x = 0;
    y = 0;
    w = 1 * VGM_GRID_W;
    h = 1 * VGM_GRID_H;
};
class VGM_ctrlBranchName: VGM_ctrlControlsGroup
{
    x = 0.25 * VGM_DISPLAYSKILLS_PAGE_W * VGM_GRID_W;
    y = 0;
    w = 0.5 * VGM_DISPLAYSKILLS_PAGE_W * VGM_GRID_W;
    h = (5 + 2) * VGM_GRID_H;
    class Controls
    {
        class Background: VGM_ctrlStatic
        {
            x = 0;
            y = 0;
            w = 0.5 * VGM_DISPLAYSKILLS_PAGE_W * VGM_GRID_W;
            h = (5 + 2) * VGM_GRID_H;
            colorBackground[] = {0.7,0.7,0.7,1};
        };
        class BackgroundMiddle: VGM_ctrlStatic
        {
            x = 0;
            y = 1 * VGM_GRID_H;
            w = 0.5 * VGM_DISPLAYSKILLS_PAGE_W * VGM_GRID_W;
            h = 5 * VGM_GRID_H;
            colorBackground[] = {0.8,0.8,0.8,1};
        };
        class Name: VGM_ctrlStructuredText
        {
            idc = VGM_IDC_DISPLAYSKILLS_BRANCHNAME_NAME;
            x = 0;
            y = 1 * VGM_GRID_H;
            w = 0.5 * VGM_DISPLAYSKILLS_PAGE_W * VGM_GRID_W;
            h = 5 * VGM_GRID_H;
            size = VGM_FONT_L;
            class Attributes
            {
                font = VGM_FONT;
                color = "#000000";
                colorLink = "#D09B43";
                align = "center";
                shadow = 0;
            };
        };
    };
};
class VGM_ctrlSkill: VGM_ctrlControlsGroupNoScrollbars
{
    x = 0;
    y = 0;
    w = VGM_CTRLSKILL_W * VGM_GRID_W;
    h = 20 * VGM_GRID_H;
    class Controls
    {
        class Background: VGM_ctrlStatic
        {
            x = 0;
            y = 0;
            w = VGM_CTRLSKILL_W * VGM_GRID_W;
            h = 20 * VGM_GRID_H;
            colorBackground[] = {0.8,0.8,0.8,1};
        };
        class Cost: VGM_ctrlStructuredText
        {
            text = "xx SP";
            idc = VGM_IDC_DISPLAYSKILLS_SKILLCOST;
            x = 0;
            y = 0;
            w = (VGM_CTRLSKILL_W - 5) * VGM_GRID_W;
            h = 5 * VGM_GRID_H;
        };
        class Description: VGM_ctrlStructuredText
        {
            idc = VGM_IDC_DISPLAYSKILLS_SKILLDESCRIPTION;
            x = 0;
            y = 5 * VGM_GRID_H;
            w = VGM_CTRLSKILL_W * VGM_GRID_W;
            h = 15 * VGM_GRID_H;
            class Attributes
            {
                font = VGM_FONT;
                color = "#000000";
                colorLink = "#D09B43";
                align = "center";
                shadow = 0;
            };
        };

        class Locked: VGM_ctrlStaticPicture
        {
            idc = VGM_IDC_DISPLAYSKILLS_SKILLLOCKED;
            text = "\a3\ui_f_orange\Data\Displays\RscDisplayAANArticle\lock_ca.paa";
            show = 0;
            x = 0;
            y = 0;
            w = VGM_CTRLSKILL_W * VGM_GRID_W;
            h = 20 * VGM_GRID_H;
        };
        class Focus: VGM_ctrlButtonInvisible
        {
            idc = VGM_IDC_DISPLAYSKILLS_SKILLFOCUS;
            colorBackground[] = {0,0,0,0};
            x = 0;
            y = 0;
            w = VGM_CTRLSKILL_W * VGM_GRID_W - 5 * VGM_GRID_W;
            h = 20 * VGM_GRID_H;
        };
        class Unlock: VGM_ctrlButtonPicture
        {
            idc = VGM_IDC_DISPLAYSKILLS_SKILLUNLOCK;
            text = "\a3\ui_f\data\GUI\Cfg\Cursors\add_gs.paa";
            colorText[] = {0,0,0,1};
            colorBackground[] = {0.7,0.7,0.7,1};
            x = (VGM_CTRLSKILL_W - 5) * VGM_GRID_W;
            y = 0;
            w = 5 * VGM_GRID_W;
            h = 5 * VGM_GRID_H;
        };
    };
};

class VGM_ctrlControlsGroupOverlay: VGM_ctrlControlsGroupNoScrollbars
{
    /* onLoad = [_this select 0, true] call vgm_c_fnc_toggle_controls_group_overlay; */
    onKillFocus = diag_log ["kill focus", _this];
};

class VGM_ctrlDisplayMissionsMessage: VGM_ctrlControlsGroupOverlay //VGM_ctrlControlsGroupNoScrollbars
{
    idc = VGM_IDC_DISPLAYMISSIONS_MESSAGE;
    x = VGM_DISPLAYMISSIONS_X;
    y = VGM_DISPLAYMISSIONS_Y;
    w = VGM_DISPLAYMISSIONS_W;
    h = VGM_DISPLAYMISSIONS_H;
    class Controls
    {
        class BackgroundFull: VGM_ctrlStatic
        {
            x = 0;
            y = 0;
            w = VGM_DISPLAYMISSIONS_W * VGM_GRID_W;
            h = VGM_DISPLAYMISSIONS_H * VGM_GRID_H;
            colorBackground[] = {0.3,0.3,0.3,0.8};
        };
#define _MESSAGE_W 0.5 * VGM_DISPLAYMISSIONS_W
#define _MESSAGE_H 20
#define _MESSAGE_X 0.5 * safeZoneWAbs - 0.5 * _MESSAGE_W * VGM_GRID_W
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
            size = VGM_FONT_L;
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

class VGM_ctrlDisplayMissionsBriefing: VGM_ctrlDisplayMissionsMessage
{
    idc = VGM_IDC_DISPLAYMISSIONS_BRIEFING;
    class Controls: Controls
    {
        class BackgroundFull: BackgroundFull
        {
        };
        class BackgroundBriefing: VGM_ctrlBackground
        {
            x = VGM_DISPLAYMISSIONS_COLUMN_CTRL_W * VGM_GRID_W;
            w = (3 * VGM_DISPLAYMISSIONS_COLUMN_W + 1) * VGM_GRID_W;
            h = (VGM_DISPLAYMISSIONS_H - 6) * VGM_GRID_H;
        };
#define _W (3 * VGM_DISPLAYMISSIONS_COLUMN_W - 1)
        class BriefingStack: VGM_ctrlStack
        {
            x = (VGM_DISPLAYMISSIONS_COLUMN_CTRL_W + 1) * VGM_GRID_W;
            y = 0;
            w = _W * VGM_GRID_W;
            h = (VGM_DISPLAYMISSIONS_H - 6) * VGM_GRID_H;
            class Controls
            {
                class Title: VGM_ctrlStructuredText
                {
                    idc = VGM_IDC_DISPLAYMISSIONS_BRIEFING_TITLE;
                    text = "Standard Mission on targetBoxName";
                    x = 0;
                    w = _W * VGM_GRID_W;
                    h = VGM_Y_H(5);
                    size = VGM_FONT_L;
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
                    idc = VGM_IDC_DISPLAYMISSIONS_BRIEFING_OPERATIONNAME;
                    text = "Operation generatedName";
                    size = VGM_FONT_L;
                    x = 0;
                    w = _W * VGM_GRID_W;
                    h = VGM_Y_H(5);
                };
                class Description: OperationName
                {
                    idc = VGM_IDC_DISPLAYMISSIONS_BRIEFING_DESCRIPTION;
                    text = "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.";
                    size = VGM_FONT_M;
                    h = VGM_Y_H(20);
                    stackFill = 1;
                };
                class MissionPropertiesText: OperationName
                {
                    text = "Mission Properties:";
                    h = VGM_Y_H(5);
                };
                class MissionProperties: VGM_ctrlControlsTable
                {
                    idc = VGM_IDC_DISPLAYMISSIONS_BRIEFING_MISSIONPROPERTIES;
                    onLoad = VGM_UIEH(loadProperties,Missions);
                    x = 0;
                    w = _W * VGM_GRID_W;
                    h = VGM_Y_H(20);
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
                class Buttons: VGM_ctrlControlsGroupNoScrollbars
                {
                    x = 0;
                    w = _W * VGM_GRID_W;
                    h = 5 * VGM_GRID_H;
#define _W 96
                    class Controls
                    {
                        class ConfirmMission: VGM_ctrlButton
                        {
                            idc = VGM_IDC_DISPLAYMISSIONS_BRIEFING_CONFIRMMISSION;
                            text = "Confirm";
                            onButtonClick = VGM_UIEH(confirmMission,Missions);
                            x = 0;
                            y = 0;
                            w = _W * VGM_GRID_W;
                            h = 5 * VGM_GRID_H;
                        };
                        class DiscardMission: ConfirmMission
                        {
                            idc = VGM_IDC_DISPLAYMISSIONS_BRIEFING_DISCARDMISSION;
                            text = "Discard Mission [Intel Penalty]";
                            onButtonClick = VGM_UIEH_SPAWN(discardMission,Missions);
                            x = (_W + 1) * VGM_GRID_W;
                        };
                    };
                };
            };
        }; // BriefingStack
    };
};

#define _W 0.5 * VGM_DISPLAYMISSIONS_W
#define _H 0.5 * VGM_DISPLAYMISSIONS_H
#define _X (0.5 * _W * VGM_GRID_W)
#define _Y (0.5 * _H * VGM_GRID_H)
class VGM_ctrlDisplayMissionsObjectives: VGM_ctrlDisplayMissionsMessage
{
    idc = VGM_IDC_DISPLAYMISSIONS_OBJECTIVES;
    class Controls: Controls
    {
        class BackgroundFull: BackgroundFull
        {
        };
        class BackgroundContent: VGM_ctrlBackground
        {
            x = _X;
            y = _Y;
            w = _W * VGM_GRID_W;
            h = _H * VGM_GRID_H;
        };
        class Stack: VGM_ctrlStack
        {
            x = _X;
            y = _Y;
            w = _W * VGM_GRID_W;
            h = _H * VGM_GRID_H;
#define _W2 (_W - 2)
#define _X2 (1 * VGM_GRID_W)
            class Controls
            {
                class Title: VGM_ctrlStructuredText
                {
                    text = "Select a Primary Objective for the Mission";
                    size = VGM_FONT_L;
                    x = _X2;
                    w = _W2 * VGM_GRID_W;
                    h = 5 * VGM_GRID_H;
                    class Attributes
                    {
                        font = VGM_FONT;
                        color = "#000000";
                        colorLink = "#D09B43";
                        align = "center";
                        shadow = 0;
                    };
                };
                class Seperator: VGM_ctrlSeperator
                {
                    x = 0;
                    w = _W * VGM_GRID_W;
                };
#define _ROW_H 20
                class List: VGM_ctrlControlsTable
                {
                    idc = VGM_IDC_DISPLAYMISSIONS_OBJECTIVES_LIST;
                    x = _X2;
                    w = _W2 * VGM_GRID_W;
                    stackFill = 1;
                    rowHeight = _ROW_H * VGM_GRID_H;
                    class RowTemplate
                    {
                        class Icon
                        {
                            controlBaseClassPath[] = {"VGM_ctrlStaticPicture"};
                            columnX = 0;
                            controlOffsetY = 0;
                            columnW = _ROW_H * VGM_GRID_W;
                            controlH = _ROW_H * VGM_GRID_H;
                        };
                        class Name: Icon
                        {
                            controlBaseClassPath[] = {"VGM_ctrlStructuredText"};
                            columnX = _ROW_H * VGM_GRID_W;
                            columnW = (_W2 - _ROW_H - 3) * VGM_GRID_W;
                            controlH = 5 * VGM_GRID_H;
                        };
                        class Description: Name
                        {
                            controlOffsetY = 5 * VGM_GRID_H;
                            columnW = (_W2 - _ROW_H - 23) * VGM_GRID_W;
                            controlH = 15 * VGM_GRID_H;
                        };
                        class Level: Name
                        {
                            columnX = (_W2 - 23) * VGM_GRID_W;
                            controlOffsetY = (_ROW_H - 10) * VGM_GRID_H;
                            columnW = 20 * VGM_GRID_W;
                            controlH = 5 * VGM_GRID_H;
                        };
                        class Select: Level
                        {
                            controlBaseClassPath[] = {"VGM_ctrlButton"};
                            controlOffsetY = (_ROW_H - 5) * VGM_GRID_H;
                        };
                    };
                };
                class Buttons: VGM_ctrlControlsGroupNoScrollbars
                {
                    x = _X2;
                    w = _W2 * VGM_GRID_W;
                    h = 5 * VGM_GRID_H;
#define _W (0.25 * VGM_DISPLAYMISSIONS_W - 1.5)
                    class Controls
                    {
                        class Reroll: VGM_ctrlButton
                        {
                            idc = VGM_IDC_DISPLAYMISSIONS_OBJECTIVES_REROLL;
                            text = "Reroll Objectives [50 Intel]";
                            x = 0;
                            y = 0;
                            w = _W * VGM_GRID_W;
                            h = 5 * VGM_GRID_H;
                            onButtonClick = VGM_UIEH(objectivesReroll,Missions);
                        };
                        class Cancel: Reroll
                        {
                            idc = VGM_IDC_DISPLAYMISSIONS_OBJECTIVES_CANCEL;
                            text = "Cancel";
                            x = (_W + 1) * VGM_GRID_W;
                            onButtonClick = VGM_UIEH(objectivesCancel,Missions);
                        };
                    };
                };
            };
        };
    };
};
