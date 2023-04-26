class VGM_DisplaySkills
{
    idd = VGM_IDD_DISPLAYSKILLS;
    onLoad = VGM_UIEH(onLoad,Skills);
    onUnload = VGM_UIEH(onUnload,Skills);
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
            idc = VGM_IDC_DISPLAYSKILLS_SPAVAILABLE;
            text = "%1 Skill Points Available";
            x = VGM_GRID_MIN_X + 1 * VGM_GRID_H;
            y = VGM_GRID_MIN_Y + 1 * VGM_GRID_H;
            w = VGM_DISPLAYSKILLS_PAGE_W * VGM_GRID_W;
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
        class Skills: VGM_ctrlTree
        {
            idc = VGM_IDC_DISPLAYSKILLS_SKILLS;
            onLoad = VGM_UIEH(initSkillTrees,Skills);
            onTreeSelChanged = VGM_UIEH(selectSkillTree,Skills);
            x = VGM_GRID_MIN_X + 1 * VGM_GRID_H;
            y = VGM_GRID_MIN_Y + 6 * VGM_GRID_H;
            w = VGM_DISPLAYSKILLS_PAGE_W * VGM_GRID_W;
            h = (VGM_GRID_MAX_H - 7) * VGM_GRID_H;
        };

        class HeaderRight: SPAvailable
        {
            idc = -1;
            text = "HEADER AREA - USED FOR MENU NAVIGATION - DESIGN WIP";
            x = CENTER_X + 1 * VGM_GRID_W;
            y = VGM_GRID_MIN_Y + 1 * VGM_GRID_H;
            w = VGM_DISPLAYSKILLS_PAGE_W * VGM_GRID_W;
            h = 5 * VGM_GRID_H;
        };
        class Title: VGM_ctrlStructuredText
        {
            idc = VGM_IDC_DISPLAYSKILLS_TITLE;
            text = "Branch/Skill Title";
            size = VGM_FONT_L;
            x = CENTER_X + 1 * VGM_GRID_W;
            y = VGM_GRID_MIN_Y + 6 * VGM_GRID_H;
            w = (VGM_DISPLAYSKILLS_PAGE_W - 50) * VGM_GRID_W;
            h = 5 * VGM_GRID_H;
            colorBackground[] = {0.8,0.8,0.8,1};
        };
        class Unlock: VGM_ctrlButton
        {
            idc = VGM_IDC_DISPLAYSKILLS_UNLOCK;
            text = "Unlock - 3 SP";
            onButtonClick = VGM_UIEH(unlockSkill,Skills);
            x = CENTER_X + (VGM_DISPLAYSKILLS_PAGE_W - 49) * VGM_GRID_W;
            y = VGM_GRID_MIN_Y + 6 * VGM_GRID_H;
            w = 50 * VGM_GRID_W;
            h = 5 * VGM_GRID_H;
            colorBackground[] = {0.7,0.7,0.7,1};
            colorDisabled[] = {0,0,0,1};
        };
        class Description: VGM_ctrlStructuredText
        {
            idc = VGM_IDC_DISPLAYSKILLS_DESCRIPTION;
            x = CENTER_X + 1 * VGM_GRID_W;
            y = VGM_GRID_MIN_Y + 11 * VGM_GRID_H;
            w = VGM_DISPLAYSKILLS_PAGE_W * VGM_GRID_W;
            h = 16 * VGM_GRID_H;
            colorBackground[] = {0.8,0.8,0.8,1};
            size = VGM_FONT_M;
        };
        class SkillTree: VGM_ctrlControlsGroupNoScrollbars
        {
            idc = VGM_IDC_DISPLAYSKILLS_SKILLTREE;
            x = CENTER_X + 1 * VGM_GRID_W;
            y = VGM_GRID_MIN_Y + 28 * VGM_GRID_H;
            w = VGM_DISPLAYSKILLS_PAGE_W * VGM_GRID_W;
            h = (VGM_GRID_MAX_H - 28) * VGM_GRID_H;
            colorBackground[] = {1,0,0,0.2};
        };
    };
};


