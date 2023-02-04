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
    colorBackground[] = {1,1,1,1};
};

class VGM_ctrlStaticPicture: ctrlStaticPicture
{
};

class VGM_ctrlStructuredText : ctrlStructuredText
{
#ifdef __A3_DEBUG__
    colorBackground[] = {1,0,0,0.2};
#endif
    size = VGM_FONT_M * VGM_GRID_H;
    shadow = 0;
    class Attributes
    {
        font = VGM_FONT;
        color = "#000000";
        colorLink = "#D09B43";
        align = "left";
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
    sizeEx = VGM_FONT_M * VGM_GRID_H;
};

class VGM_ctrlControlsGroup: ctrlControlsGroup
{
};

class VGM_ctrlControlsGroupNoScrollbars: ctrlControlsGroupNoScrollbars
{
};

class VGM_ctrlButton: ctrlButton
{
    colorBackground[] = {0.6,0.6,0.6,1};
    colorText[] = {0,0,0,1};
    font = VGM_FONT;
    sizeEx = VGM_FONT_M * VGM_GRID_H;
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
    selectedRowColorFrom[] = {0,1,0,0};
    selectedRowColorTo[] = {0,1,0,1};
    class HeaderTemplate
    {
    };
    class RowTemplate
    {
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
    sizeEx = VGM_FONT_M * VGM_GRID_H;
    font = VGM_FONT;
};

class VGM_ctrlStack: VGM_ctrlControlsGroupNoScrollbars
{
    onLoad = "_this call vgm_c_fnc_stack_controls;";
    stackMargin = 1 * VGM_GRID_H;
};

// Controls for VGM_DisplaySkills
class VGM_ctrlSkillTreeBranchV: VGM_ctrlStatic
{
    x = 0;
    y = 0;
    w = 1 * VGM_GRID_W;
    h = 2 * VGM_GRID_H;
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
    h = (VGM_FONT_L + 2) * VGM_GRID_H;
    class Controls
    {
        class Background: VGM_ctrlStatic
        {
            x = 0;
            y = 0;
            w = 0.5 * VGM_DISPLAYSKILLS_PAGE_W * VGM_GRID_W;
            h = (VGM_FONT_L + 2) * VGM_GRID_H;
            colorBackground[] = {0.7,0.7,0.7,1};
        };
        class BackgroundMiddle: VGM_ctrlStatic
        {
            x = 0;
            y = 1 * VGM_GRID_H;
            w = 0.5 * VGM_DISPLAYSKILLS_PAGE_W * VGM_GRID_W;
            h = VGM_FONT_L * VGM_GRID_H;
            colorBackground[] = {0.8,0.8,0.8,1};
        };
        class Name: VGM_ctrlStructuredText
        {
            idc = VGM_IDC_DISPLAYSKILLS_BRANCHNAME_NAME;
            x = 0;
            y = 1 * VGM_GRID_H;
            w = 0.5 * VGM_DISPLAYSKILLS_PAGE_W * VGM_GRID_W;
            h = VGM_FONT_L * VGM_GRID_H;
            size = VGM_FONT_L * VGM_GRID_H;
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
        class Unlock: VGM_ctrlButtonPicture
        {
            idc = VGM_IDC_DISPLAYSKILLS_SKILLUNLOCK;
            text = "P:\a3\ui_f\data\GUI\Cfg\Cursors\add_gs.paa";
            colorText[] = {0,0,0,1};
            colorBackground[] = {0.7,0.7,0.7,1};
            x = (VGM_CTRLSKILL_W - 5) * VGM_GRID_W;
            y = 0;
            w = 5 * VGM_GRID_W;
            h = 5 * VGM_GRID_H;
        };
    };
};

