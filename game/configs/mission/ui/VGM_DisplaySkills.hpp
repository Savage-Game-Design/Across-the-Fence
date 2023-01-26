#define W_PAGE (0.5 * VGM_GRID_MAX_W - 2)
class VGM_ctrlSkillTreeBranchV: VGM_ctrlStatic
{
    x = 0;
    y = 0;
    w = VGM_GRID_MARGIN * VGM_GRID_W;
    h = 0.5 * VGM_GRID_H;
    colorBackground[] = {0.8,0.8,0.8,1};
};
class VGM_ctrlSkillTreeBranchH: VGM_ctrlSkillTreeBranchV
{
    x = 0;
    y = 0;
    w = VGM_GRID_MARGIN * VGM_GRID_W;
    h = VGM_GRID_MARGIN * VGM_GRID_H;
};
class VGM_ctrlBranchName: VGM_ctrlControlsGroup
{
    x = 0.25 * W_PAGE * VGM_GRID_W;
    y = 0;
    w = 0.5 * W_PAGE * VGM_GRID_W;
    h = 3 * VGM_GRID_H;
    class Controls
    {
        class Background: VGM_ctrlStatic
        {
            x = 0;
            y = 0;
            w = 0.5 * W_PAGE * VGM_GRID_W;
            h = 3 * VGM_GRID_H;
            colorBackground[] = {0.7,0.7,0.7,1};
        };
        class BackgroundMiddle: VGM_ctrlStatic
        {
            x = 0;
            y = 0.5 * VGM_GRID_H;
            w = 0.5 * W_PAGE * VGM_GRID_W;
            h = 2 * VGM_GRID_H;
            colorBackground[] = {0.8,0.8,0.8,1};
        };
        class Name: VGM_ctrlStructuredText
        {
            idc = VGM_IDC_RSCDISPLAYSKILLS_BRANCHNAME_NAME;
            x = 0;
            y = 0.75 * VGM_GRID_H;
            w = 0.5 * W_PAGE * VGM_GRID_W;
            h = 1.5 * VGM_GRID_H;
            class Attributes
            {
                font = VGM_FONT;
                color = "#000000";
                colorLink = "#D09B43";
                align = "center";
                shadow = 0;
                size = 1.5;
            };
        };
    };
};
class VGM_ctrlSkill: VGM_ctrlControlsGroup
{
    x = 0;
    y = 0;
    w = 0.33 * W_PAGE * VGM_GRID_W;
    h = 5 * VGM_GRID_H;
    class Controls
    {
        class Background: VGM_ctrlStatic
        {
            x = 0;
            y = 0;
            w = 0.33 * W_PAGE * VGM_GRID_W;
            h = 5 * VGM_GRID_H;
            colorBackground[] = {0.8,0.8,0.8,1};
        };
        class Description: VGM_ctrlStructuredText
        {
            idc = VGM_IDC_RSCDISPLAYSKILLS_SKILLDESCRIPTION;
            x = 0;
            y = 1 * VGM_GRID_H;
            w = 1/3 * ((W_PAGE - 3 * VGM_GRID_MARGIN) * VGM_GRID_W);
            /* w = 10 * VGM_GRID_W; */
            h = 4 * VGM_GRID_H;
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
            x = (1/3 * (W_PAGE - 3 * VGM_GRID_MARGIN) - 1) * VGM_GRID_W;
            y = 0;
            w = 1 * VGM_GRID_W;
            h = 1 * VGM_GRID_H;
        };
    };
};

class VGM_DisplaySkills
{
    idd = VGM_IDD_RSCDISPLAYSKILLS;
    onLoad = VGM_UIEH(onLoad,Skills);
    class ControlsBackground
    {
        class Background: VGM_ctrlStatic
        {
            x = VGM_GRID_MIN_X;
            y = VGM_GRID_MIN_Y;
            w = VGM_GRID_MAX_W * VGM_GRID_W;
            h = VGM_GRID_MAX_H * VGM_GRID_H;
            colorBackground[] = {1,1,1,1};
        };
    };
    class Controls
    {
        class SPAvailable: VGM_ctrlStructuredText
        {
            idc = VGM_IDC_RSCDISPLAYSKILLS_SPAVAILABLE;
            text = "%1 Skill Points Available";
            x = VGM_GRID_MIN_X + VGM_GRID_MARGIN * VGM_GRID_H;
            y = VGM_GRID_MIN_Y + VGM_GRID_MARGIN * VGM_GRID_H;
            w = W_PAGE * VGM_GRID_W;
            h = 1 * VGM_GRID_H;
            class Attributes
            {
                font = VGM_FONT;
                color = "#000000";
                colorLink = "#D09B43";
                align = "center";
                shadow = 0;
            };
        };
        class Skills: VGM_ctrlTree
        {
            onLoad = VGM_UIEH(initSkills,Skills);
            onTreeSelChanged = VGM_UIEH(selectSkill,Skills);
            idc = VGM_IDC_RSCDISPLAYSKILLS_SKILLS;
            x = VGM_GRID_MIN_X + VGM_GRID_MARGIN * VGM_GRID_H;
            y = VGM_GRID_MIN_Y + (2 * VGM_GRID_MARGIN + 1) * VGM_GRID_H;
            w = W_PAGE * VGM_GRID_W;
            h = (VGM_GRID_MAX_H - 3 * VGM_GRID_MARGIN - 1) * VGM_GRID_H;
        };

        class HeaderRight: SPAvailable
        {
            idc = -1;
            text = "HEADER AREA - USED FOR MENU NAVIGATION - DESIGN WIP";
            x = CENTER_X + (2 - VGM_GRID_MARGIN) * VGM_GRID_W;
            y = VGM_GRID_MIN_Y + VGM_GRID_MARGIN * VGM_GRID_H;
            w = W_PAGE * VGM_GRID_W;
            h = 1 * VGM_GRID_H;
        };
        class Description: VGM_ctrlStructuredText
        {
            idc = VGM_IDC_RSCDISPLAYSKILLS_DESCRIPTION;
            x = CENTER_X + (2 - VGM_GRID_MARGIN) * VGM_GRID_W;
            y = VGM_GRID_MIN_Y + (1 + 2 * VGM_GRID_MARGIN) * VGM_GRID_H;
            w = W_PAGE * VGM_GRID_W;
            h = 5.5 * VGM_GRID_H;
            colorBackground[] = {0.8,0.8,0.8,1};
        };
        class Unlock: VGM_ctrlButton
        {
            idc = -1;
            text = "Unlock - 3 SP";
            x = CENTER_X + (19 - VGM_GRID_MARGIN) * VGM_GRID_W;
            y = VGM_GRID_MIN_Y + (7 - 2 * VGM_GRID_MARGIN) * VGM_GRID_H;
            w = 10 * VGM_GRID_W;
            h = 1 * VGM_GRID_H;
            colorBackground[] = {0.7,0.7,0.7,1};

        };
        class SkillTree: VGM_ctrlControlsGroup
        {
            idc = VGM_IDC_RSCDISPLAYSKILLS_SKILLTREE;
            x = CENTER_X + (2 - VGM_GRID_MARGIN) * VGM_GRID_W;
            y = VGM_GRID_MIN_Y + (7.5 + 3 * VGM_GRID_MARGIN) * VGM_GRID_H;
            w = W_PAGE * VGM_GRID_W;
            h = 100;
        };
    };
};


