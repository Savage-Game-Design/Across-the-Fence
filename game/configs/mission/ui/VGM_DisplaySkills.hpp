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
            x = VGM_GRID_MIN_X + 1 * VGM_GRID_H;
            y = VGM_GRID_MIN_Y + 1 * VGM_GRID_H;
            w = VGM_DISPLAYSKILLS_PAGE_W * VGM_GRID_W;
            h = 3 * VGM_GRID_H;
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
            idc = VGM_IDC_RSCDISPLAYSKILLS_SKILLS;
            onLoad = VGM_UIEH(initSkills,Skills);
            onTreeSelChanged = VGM_UIEH(selectSkill,Skills);
            x = VGM_GRID_MIN_X + 1 * VGM_GRID_H;
            y = VGM_GRID_MIN_Y + 5 * VGM_GRID_H;
            w = VGM_DISPLAYSKILLS_PAGE_W * VGM_GRID_W;
            h = (VGM_GRID_MAX_H - 6) * VGM_GRID_H;
        };

        class HeaderRight: SPAvailable
        {
            idc = -1;
            text = "HEADER AREA - USED FOR MENU NAVIGATION - DESIGN WIP";
            x = CENTER_X + 1 * VGM_GRID_W;
            y = VGM_GRID_MIN_Y + 1 * VGM_GRID_H;
            w = VGM_DISPLAYSKILLS_PAGE_W * VGM_GRID_W;
            h = 3 * VGM_GRID_H;
        };
        class Description: VGM_ctrlStructuredText
        {
            idc = VGM_IDC_RSCDISPLAYSKILLS_DESCRIPTION;
            x = CENTER_X + 1 * VGM_GRID_W;
            y = VGM_GRID_MIN_Y + 5 * VGM_GRID_H;
            w = VGM_DISPLAYSKILLS_PAGE_W * VGM_GRID_W;
            h = 9 * VGM_GRID_H;
            colorBackground[] = {0.8,0.8,0.8,1};
            size = VGM_FONT_S * VGM_GRID_H;
        };
        class Unlock: VGM_ctrlButton
        {
            idc = -1;
            text = "Unlock - 3 SP";
            x = CENTER_X + 44 * VGM_GRID_W;
            y = VGM_GRID_MIN_Y + 14 * VGM_GRID_H;
            w = 35 * VGM_GRID_W;
            h = 3 * VGM_GRID_H;
            colorBackground[] = {0.7,0.7,0.7,1};
        };
        class SkillTree: VGM_ctrlControlsGroupNoScrollbars
        {
            idc = VGM_IDC_RSCDISPLAYSKILLS_SKILLTREE;
            x = CENTER_X + 1 * VGM_GRID_W;
            y = VGM_GRID_MIN_Y + 18 * VGM_GRID_H;
            w = VGM_DISPLAYSKILLS_PAGE_W * VGM_GRID_W;
            h = (VGM_GRID_MAX_H - 19) * VGM_GRID_H;
            colorBackground[] = {1,0,0,0.2};
        };
    };
};


