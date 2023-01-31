import ctrlStatic;
import ctrlStructuredText;
import ctrlTree;
import ctrlControlsGroup;
import ctrlControlsGroupNoScrollbars;
import ctrlButton;
import ctrlButtonPicture;

#define COLOR_BLACK {0,0,0,1}
class VGM_ctrlStatic: ctrlStatic {};
class VGM_ctrlStructuredText : ctrlStructuredText
{
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
    colorText[] = {0,0,0,1};
    font = VGM_FONT;
    sizeEx = VGM_FONT_M * VGM_GRID_H;
};

class VGM_ctrlButtonPicture: ctrlButtonPicture
{
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
class VGM_ctrlSkill: VGM_ctrlControlsGroup
{
    x = 0;
    y = 0;
    w = VGM_CTRLSKILL_W * VGM_GRID_W;
    h = 30 * VGM_GRID_H;
    class Controls
    {
        class Background: VGM_ctrlStatic
        {
            x = 0;
            y = 0;
            w = VGM_CTRLSKILL_W * VGM_GRID_W;
            h = 30 * VGM_GRID_H;
            colorBackground[] = {0.8,0.8,0.8,1};
        };
        class Description: VGM_ctrlStructuredText
        {
            idc = VGM_IDC_DISPLAYSKILLS_SKILLDESCRIPTION;
            x = 0;
            y = 5 * VGM_GRID_H;
            w = VGM_CTRLSKILL_W * VGM_GRID_W;
            h = 25 * VGM_GRID_H;
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
