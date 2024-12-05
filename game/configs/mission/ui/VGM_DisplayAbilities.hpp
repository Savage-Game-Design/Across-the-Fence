#define DISPLAY_X VGM_MENU_X
#define DISPLAY_Y VGM_MENU_Y
#define DISPLAY_W VGM_MENU_W
#define DISPLAY_H VGM_MENU_H

#define COLUMN_W floor ((DISPLAY_W - 11) / 3)
#define COLUMN3_X DISPLAY_X + (2 * COLUMN_W + 11) * VGM_GRID_W
#define PICTURE_H (COLUMN_W - 35)
class VGM_DisplayAbilities: VGM_DisplayMenuBase
{
    idd = VGM_IDD_DISPLAYABILITIES;
    onLoad = VGM_UIEH(onLoad,Abilities);
    class ControlsBackground: ControlsBackground
    {
        class Background: Background
        {
        };
        class BackgroundStdTitle: VGM_ctrlBackgroundTitle
        {
            x = DISPLAY_X + 1 * VGM_GRID_W;
            y = DISPLAY_Y + 1 * VGM_GRID_H;
            w = 0.75 * COLUMN_W * VGM_GRID_W;
            h = 5 * VGM_GRID_H;
        };
        class FrameStdTitle: VGM_ctrlFrame
        {
            x = DISPLAY_X + 1 * VGM_GRID_W;
            y = DISPLAY_Y + 1 * VGM_GRID_H;
            w = 0.75 * COLUMN_W * VGM_GRID_W;
            h = 5 * VGM_GRID_H;
        };
        class BackgroundStd: VGM_ctrlBackground
        {
            x = DISPLAY_X + 1 * VGM_GRID_W;
            y = DISPLAY_Y + 6 * VGM_GRID_H;
            w = COLUMN_W * VGM_GRID_W;
            h = VGM_Y_H(0.5 * DISPLAY_H - 9);
        };
        class FrameStd: VGM_ctrlFrame
        {
            x = DISPLAY_X + 1 * VGM_GRID_W;
            y = DISPLAY_Y + 6 * VGM_GRID_H;
            w = COLUMN_W * VGM_GRID_W;
            h = (0.5 * DISPLAY_H - 9) * VGM_GRID_H;
        };
        class BackgroundUltTitle: BackgroundStdTitle
        {
            y = DISPLAY_Y + (0.5 * DISPLAY_H + 3) * VGM_GRID_H;
        };
        class FrameUltTitle: FrameStdTitle
        {
            y = DISPLAY_Y + (0.5 * DISPLAY_H + 3) * VGM_GRID_H;
        };
        class BackgroundUlt: BackgroundStd
        {
            y = DISPLAY_Y + (0.5 * DISPLAY_H + 8) * VGM_GRID_H;
        };
        class FrameUlt: FrameStd
        {
            y = DISPLAY_Y + (0.5 * DISPLAY_H + 8) * VGM_GRID_H;
        };

        class BackgroundAvailableTitle: VGM_ctrlBackgroundTitle
        {
            x = DISPLAY_X + (COLUMN_W + 5) * VGM_GRID_W;
            y = DISPLAY_Y + 1 * VGM_GRID_H;
            w = COLUMN_W * VGM_GRID_W;
            h = 5 * VGM_GRID_H;
        };
        class FrameAvailableTitle: VGM_ctrlFrame
        {
            x = DISPLAY_X + (COLUMN_W + 5) * VGM_GRID_W;
            y = DISPLAY_Y + 1 * VGM_GRID_H;
            w = COLUMN_W * VGM_GRID_W;
            h = 5 * VGM_GRID_H;
        };
        class BackgroundAvailable: VGM_ctrlBackground
        {
            x = DISPLAY_X + (COLUMN_W + 5) * VGM_GRID_W;
            y = DISPLAY_Y + 6 * VGM_GRID_H;
            w = COLUMN_W * VGM_GRID_W;
            h = (DISPLAY_H - 7) * VGM_GRID_H;
        };
        class FrameAvailable: VGM_ctrlFrame
        {
            x = DISPLAY_X + (COLUMN_W + 5) * VGM_GRID_W;
            y = DISPLAY_Y + 6 * VGM_GRID_H;
            w = COLUMN_W * VGM_GRID_W;
            h = (DISPLAY_H - 7) * VGM_GRID_H;
        };

        class BackgroundAbilityTitle: VGM_ctrlBackgroundTitle
        {
            x = DISPLAY_X + 2 * (COLUMN_W + 5) * VGM_GRID_W;
            y = DISPLAY_Y + 1 * VGM_GRID_H;
            w = COLUMN_W * VGM_GRID_W;
            h = 5 * VGM_GRID_H;
        };
        class FrameAbilityTitle: VGM_ctrlFrame
        {
            x = DISPLAY_X + 2 * (COLUMN_W + 5) * VGM_GRID_W;
            y = DISPLAY_Y + 1 * VGM_GRID_H;
            w = COLUMN_W * VGM_GRID_W;
            h = 5 * VGM_GRID_H;
        };
        class BackgroundAbility: VGM_ctrlBackground
        {
            x = DISPLAY_X + 2 * (COLUMN_W + 5) * VGM_GRID_W;
            y = DISPLAY_Y + 6 * VGM_GRID_H;
            w = COLUMN_W * VGM_GRID_W;
            h = (DISPLAY_H - 7) * VGM_GRID_H;
        };
        class FrameAbility: VGM_ctrlFrame
        {
            x = DISPLAY_X + 2 * (COLUMN_W + 5) * VGM_GRID_W;
            y = DISPLAY_Y + 6 * VGM_GRID_H;
            w = COLUMN_W * VGM_GRID_W;
            h = (DISPLAY_H - 7) * VGM_GRID_H;
        };
    };
    class Controls: Controls
    {
        class HeaderBar: HeaderBar
        {
        };
        VGM_SET_Y(0)
        class StdTitle: VGM_ctrlTitle
        {
            idc = VGM_IDC_DISPLAYABILITIES_STDTITLE;
            text = "$STR_VGM_SKILLS_UI_ABILITY_STD";
            tooltip = "$STR_VGM_SKILLS_UI_ABILITY_STD_TOOLTIP";
            x = DISPLAY_X + 1 * VGM_GRID_W;
            y = VGM_Y_Y(DISPLAY_Y,1);
            w = 0.75 * COLUMN_W * VGM_GRID_W;
            h = VGM_Y_H(5);
        };
#define _ABILITY_H (0.5 * DISPLAY_H - 9)
        class StdEmpty: VGM_ctrlControlsGroup
        {
            idc = VGM_IDC_DISPLAYABILITIES_STDEMPTY;
            x = DISPLAY_X + 1 * VGM_GRID_W;
            y = VGM_Y_Y(DISPLAY_Y,0);
            w = COLUMN_W * VGM_GRID_W;
            h = _ABILITY_H * VGM_GRID_H;
            class Controls
            {
                class TopText: VGM_ctrlStructuredText
                {
                    text = "$STR_VGM_SKILLS_UI_STDEMPTY_TOPTEXT_TEXT";
                    x = 0;
                    y = 5 * VGM_GRID_H;
                    w = COLUMN_W * VGM_GRID_W;
                    h = 5 * VGM_GRID_H;
                    class Attributes
                    {
                        font = VGM_FONT;
                        color = "#ffffff";
                        colorLink = "#D09B43";
                        align = "center";
                        shadow = 0;
                    };
                };
                class BottomText: TopText
                {
                    text = "$STR_VGM_SKILLS_UI_STDEMPTY_BOTTOMTEXT_TEXT";
                    y = (_ABILITY_H - 10) * VGM_GRID_H;
                };
            };
        };
#define _ICON_W 18
        class StdStack: VGM_ctrlStack
        {
            idc = VGM_IDC_DISPLAYABILITIES_STDSTACK;
            x = DISPLAY_X + 1 * VGM_GRID_W;
            y = VGM_Y_Y(DISPLAY_Y,0);
            w = COLUMN_W * VGM_GRID_W;
            h = VGM_Y_H(0.5 * DISPLAY_H - 9);
            show = 0;
#define _W (COLUMN_W - 2)
            class Controls
            {
                class StdIconFrame: VGM_ctrlFrame
                {
                    stackDisable = 1;
                    x = (_W - _ICON_W + 1) * VGM_GRID_W;
                    y = 1 * VGM_GRID_H;
                    w = (_ICON_W - 1) * VGM_GRID_W + pixelW;
                    h = (_ICON_W - 1) * VGM_GRID_H + pixelH;
                    style = ST_WITH_RECT;
                };
                class StdIcon: VGM_ctrlStaticPicture
                {
                    idc = VGM_IDC_DISPLAYABILITIES_STDULT_ICON;
                    text = "#(rgb,1,1,1)color(0,1,0,0.5)";
                    stackDisable = 1;
                    x = (_W - _ICON_W + 1) * VGM_GRID_W;
                    y = 1 * VGM_GRID_H;
                    w = (_ICON_W - 1) * VGM_GRID_W;
                    h = (_ICON_W - 1) * VGM_GRID_H;
                };
                #define _W (COLUMN_W - _ICON_W - 3)
                class StdName: VGM_ctrlStructuredText
                {
                    idc = VGM_IDC_DISPLAYABILITIES_STDULT_NAME;
                    size = VGM_FONT_M;
                    x = 1 * VGM_GRID_W;
                    w = _W * VGM_GRID_W;
                    h = 5 * VGM_GRID_H;
                };
                class StdSeperator: VGM_ctrlStaticPicture
                {
                    text = "\a3\ui_f\data\GUI\RscCommon\RscBackgroundGUI\gradient_left_gs.paa";
                    x = 1 * VGM_GRID_W;
                    w = _W * VGM_GRID_W;
                    h = 0.5 * VGM_GRID_H;
                };
                class StdCategory: StdName
                {
                    idc = VGM_IDC_DISPLAYABILITIES_STDULT_CATEGORY;
                    size = VGM_FONT_M;
                    stackOffset = 0;
                    h = 5 * VGM_GRID_H;
                };
                class StdCooldown: StdCategory
                {
                    idc = VGM_IDC_DISPLAYABILITIES_STDULT_COOLDOWN;
                    h = 5 * VGM_GRID_H;
                    stackOffset = 0;
                };
                class StdDescription: StdCategory
                {
                    idc = VGM_IDC_DISPLAYABILITIES_STDULT_DESCRIPTION;
                    stackFill = 1;
                    w = (COLUMN_W - 2) * VGM_GRID_W;
                };
            };
        };
        class UltTitle: StdTitle
        {
            idc = VGM_IDC_DISPLAYABILITIES_ULTTITLE;
            text = "$STR_VGM_SKILLS_UI_ABILITY_ULT";
            tooltip = "$STR_VGM_SKILLS_UI_ABILITY_ULT_TOOLTIP";
            y = VGM_Y_Y(DISPLAY_Y,5.5);
        };
        class UltEmpty: StdEmpty
        {
            idc = VGM_IDC_DISPLAYABILITIES_ULTEMPTY;
            y = VGM_Y_Y(DISPLAY_Y,5.5);
        };
        class UltStack: StdStack
        {
            idc = VGM_IDC_DISPLAYABILITIES_ULTSTACK;
            y = VGM_Y_Y(DISPLAY_Y,0);
        };

        VGM_SET_Y(5)
        class StdStackButton: VGM_ctrlButtonInvisible
        {
            x = DISPLAY_X + 1 * VGM_GRID_W;
            y = VGM_Y_Y(DISPLAY_Y,1);
            w = COLUMN_W * VGM_GRID_W;
            h = VGM_Y_H(0.5 * DISPLAY_H - 9);
            colorBackgroundActive[] = {VGM_UI_COLOR_ACTIVE_RGB, 0.1};
            onButtonClick = VGM_UIEH(slotSelectStandard,Abilities);
        };
        class UltStackButton: StdStackButton
        {
            y = VGM_Y_Y(DISPLAY_Y,10.5);
            onButtonClick = VGM_UIEH(slotSelectUltimate,Abilities);
        };

#define _X DISPLAY_X + (COLUMN_W + 5) * VGM_GRID_W
#define _W COLUMN_W
VGM_SET_Y(0);
        class AvailableTitle: StdTitle
        {
            idc = VGM_IDC_DISPLAYABILITIES_AVAILABLETITLE;
            tooltip = "";
            x = _X;
            w = _W * VGM_GRID_W;
        };
#define _ICON_W 20
        class Available: VGM_ctrlControlsTable
        {
            idc = VGM_IDC_DISPLAYABILITIES_AVAILABLE;
            rowHeight = (_ICON_W + 9) * VGM_GRID_H;
            x = _X;
            y = VGM_Y_Y(DISPLAY_Y, 6.5);
            w = _W * VGM_GRID_W;
            h = (DISPLAY_H - 8) * VGM_GRID_H;
            onLBSelChanged = VGM_UIEH(skillSelected,Abilities);
            colorBackground[] = {1,0,0,1};
VGM_SET_Y(0.5 * _ICON_W + 2.5 - 5)
            class RowTemplate
            {
                class Frame
                {
                    controlBaseClassPath[] = {"VGM_ctrlFrame"};
                    columnX = 1 * VGM_GRID_W;
                    controlOffsetY = 1 * VGM_GRID_H;
                    columnW = (_W - 4) * VGM_GRID_W;
                    controlH = (_ICON_W + 7) * VGM_GRID_H;
                }
                class Name
                {
                    controlBaseClassPath[] = {"VGM_ctrlStructuredText"};
                    columnX = 1 * VGM_GRID_W;
                    controlOffsetY = (0.5 * _ICON_W) * VGM_GRID_H;
                    columnW = (_W - _ICON_W - 4) * VGM_GRID_W;
                    controlH = VGM_Y_H(5);
                };
                class Category: Name
                {
                    controlOffsetY = (0.5 * _ICON_W + 5) * VGM_GRID_H;
                };
                class FrameRight
                {
                    controlBaseClassPath[] = {"VGM_ctrlFrame"};
                    columnX = (COLUMN_W - _ICON_W - 5) * VGM_GRID_W;
                    controlOffsetY = 1 * VGM_GRID_H;
                    columnW = (_ICON_W + 2) * VGM_GRID_W;
                    controlH = (_ICON_W + 7) * VGM_GRID_H;
                };
                class Icon
                {
                    controlBaseClassPath[] = {"VGM_ctrlStaticPicture"};
                    columnX = (COLUMN_W - _ICON_W - 4) * VGM_GRID_W;
                    controlOffsetY = 2 * VGM_GRID_H;
                    columnW = _ICON_W * VGM_GRID_W;
                    controlH = _ICON_W * VGM_GRID_H;
                };
                class Equip: Icon
                {
                    controlBaseClassPath[] = {"VGM_ctrlButton"};
                    controlOffsetY = (_ICON_W + 2) * VGM_GRID_H;
                    controlH = 5 * VGM_GRID_H;
                };
            };
        };
        class AvailableEmpty: VGM_ctrlStructuredTextCentered
        {
            idc = VGM_IDC_DISPLAYABILITIES_AVAILABLEEMPTY;
            text = "$STR_VGM_SKILLS_UI_AVAILABLEEMPTY_TEXT";
            x = _X;
            y = VGM_Y_Y(DISPLAY_Y, 0);
            w = _W * VGM_GRID_W;
            h = (DISPLAY_H - 8) * VGM_GRID_H;
        };

#define _X DISPLAY_X + 2 * (COLUMN_W + 5) * VGM_GRID_W
        class AbilityTitle: AvailableTitle
        {
            idc = VGM_IDC_DISPLAYABILITIES_ABILITYTITLE;
            x = _X;
        };
#define _W (COLUMN_W - 2)
        class AbilityStack: VGM_ctrlStack
        {
            colorBackground[] = {1,0,0,0.2};
            idc = VGM_IDC_DISPLAYABILITIES_ABILITYSTACK;
            x = _X;
            y = DISPLAY_Y + 6.5 * VGM_GRID_H;
            w = COLUMN_W * VGM_GRID_W;
            h = (DISPLAY_H - 7) * VGM_GRID_H;
            class Controls
            {
                class AbilityDescription: VGM_ctrlStructuredText
                {
                    idc = VGM_IDC_DISPLAYABILITIES_ABILITYDESCRIPTION;
                    stackFill = 1;
                    x = 1 * VGM_GRID_W;
                    w = _W * VGM_GRID_W;
                };
                class Row: ctrlControlsGroupNoScrollbars
                {
                    x = 1 * VGM_GRID_W;
                    w = _W * VGM_GRID_W;
                    h = 10 * VGM_GRID_H;
                    class Controls
                    {
                        class AbilityCategory: VGM_ctrlStructuredText
                        {
                            idc = VGM_IDC_DISPLAYABILITIES_ABILITYCATEGORY;
                            x = 0;
                            y = 0;
                            w = (_W - 10) * VGM_GRID_W;
                            h = 5 * VGM_GRID_H;
                        };
                        class AbilityCooldown: AbilityCategory
                        {
                            idc = VGM_IDC_DISPLAYABILITIES_ABILITYCOOLDOWN;
                            y = 5 * VGM_GRID_H;
                        };
                        class AbilityIconFrame: VGM_ctrlFrame
                        {
                            x = (_W - 10) * VGM_GRID_W;
                            y = 0.5 * VGM_GRID_H;
                            w = 9 * VGM_GRID_W + pixelW;
                            h = 9 * VGM_GRID_H + pixelH;
                        };
                        class AbilityIcon: VGM_ctrlStaticPicture
                        {
                            idc = VGM_IDC_DISPLAYABILITIES_ABILITYICON;
                            text = "#(rgb,1,1,1)color(0,1,0,1)";
                            x = (_W - 10) * VGM_GRID_W;
                            y = 0.5 * VGM_GRID_H;
                            w = 9 * VGM_GRID_W;
                            h = 9 * VGM_GRID_H;
                        };
                    };
                };
                class _Spacer: VGM_ctrlStatic
                {
                    x = 0;
                    y = 0;
                    w = 0;
                    h = 0.5 * VGM_GRID_H;
                };
                class FrameAbilityImage: VGM_ctrlFrame
                {
                    stackDisable = 1;
                    x = 1.5 * VGM_GRID_W;
                    y = 64.5 * VGM_GRID_H;
                    w = (_W - 1) * VGM_GRID_W + pixelW;
                    h = ((9/16) * _W - 1) * VGM_GRID_H + pixelH;
                };
                class AbilityImage: VGM_ctrlStaticPicture
                {
                    idc = VGM_IDC_DISPLAYABILITIES_ABILITYIMAGE;
                    text = "#(rgb,1,1,1)color(0,1,0,0.5)";
                    x = 1.5 * VGM_GRID_W;
                    w = (_W - 1) * VGM_GRID_W;
                    h = ((9/16) * _W - 1) * VGM_GRID_H;
                };
                class _Spacer1: _Spacer
                {
                };
                class AbilityEquip: VGM_ctrlButton
                {
                    idc = VGM_IDC_DISPLAYABILITIES_ABILITYEQUIP;
                    onButtonClick = VGM_UIEH(equipSkill,Abilities);
                    text = "$STR_VGM_SKILLS_UI_EQUIP";
                    x = (0.25 * _W + 0.5) * VGM_GRID_W;
                    w = (0.5 * _W - 1) * VGM_GRID_W;
                    h = 9 * VGM_GRID_H;
                };
                class _Spacer2: _Spacer
                {
                };
            };
        };
        class AbilityEmpty: VGM_ctrlStructuredTextCentered
        {
            idc = VGM_IDC_DISPLAYABILITIES_ABILITYEMPTY;
            text = "$STR_VGM_SKILLS_UI_ABILITYEMPTY_TEXT";
            x = _X;
            y = VGM_Y_Y(DISPLAY_Y, 0);
            w = COLUMN_W * VGM_GRID_W;
            h = 10 * VGM_GRID_H;
        };
    };
};

