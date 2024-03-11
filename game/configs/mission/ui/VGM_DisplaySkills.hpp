#define _DISPLAY_X VGM_MENU_X
#define _DISPLAY_Y VGM_MENU_Y
#define _DISPLAY_W VGM_MENU_W
#define _DISPLAY_H VGM_MENU_H
#define _PAGE_W (0.5 * VGM_MENU_W - 2)
#define _ICON_H 10
#define _SKILLS_W (_ICON_H + 3)

class VGM_DisplaySkills: VGM_DisplayMenuBase
{
    idd = VGM_IDD_DISPLAYSKILLS;
    onLoad = VGM_UIEH(onLoad,Skills);
    onUnload = VGM_UIEH(onUnload,Skills);
    class ControlsBackground: ControlsBackground
    {
        class Background: Background
        {
        };
    };
    class Controls: Controls
    {
        class HeaderBar: HeaderBar
        {
        };
        class Skills: VGM_ctrlListBox
        {
            idc = VGM_IDC_DISPLAYSKILLS_SKILLS;
            onLoad = VGM_UIEH(initSkillTrees,Skills);
            onLBSelChanged = VGM_UIEH(selectSkillTree,Skills);
            x = _DISPLAY_X + 1 * VGM_GRID_W;
            y = _DISPLAY_Y + 1 * VGM_GRID_H;
            w = (_ICON_H + 3) * VGM_GRID_W;
            h = (_DISPLAY_H - 2) * VGM_GRID_H;
            rowHeight = _ICON_H * VGM_GRID_H;
            style = ST_PICTURE;
        };
        class SPAvailable: VGM_ctrlStructuredText
        {
            idc = VGM_IDC_DISPLAYSKILLS_SPAVAILABLE;
            text = "%1 Skill Points Available";
            x = _DISPLAY_X + (_SKILLS_W + 1) * VGM_GRID_W;
            y = _DISPLAY_Y + 1 * VGM_GRID_H;
            w = _DISPLAY_W * VGM_GRID_W;
            h = 5 * VGM_GRID_H;
        };

        class Title: VGM_ctrlStructuredText
        {
            idc = VGM_IDC_DISPLAYSKILLS_TITLE;
            text = "Branch/Skill Title";
            size = VGM_FONT_L;
            x = _DISPLAY_X + (_SKILLS_W + 1) * VGM_GRID_W;
            y = _DISPLAY_Y + 6 * VGM_GRID_H;
            w = (_PAGE_W - 50) * VGM_GRID_W;
            h = 5 * VGM_GRID_H;
        };
        class Unlock: VGM_ctrlButton
        {
            idc = VGM_IDC_DISPLAYSKILLS_UNLOCK;
            text = "Unlock - 3 SP";
            onButtonClick = VGM_UIEH(unlockSkill,Skills);
            x = CENTER_X + (_PAGE_W - 49) * VGM_GRID_W;
            y = _DISPLAY_Y + 1 * VGM_GRID_H;
            w = 50 * VGM_GRID_W;
            h = 5 * VGM_GRID_H;
        };
        class Description: VGM_ctrlStructuredText
        {
            idc = VGM_IDC_DISPLAYSKILLS_DESCRIPTION;
            x = CENTER_X + 1 * VGM_GRID_W;
            y = _DISPLAY_Y + 6 * VGM_GRID_H;
            w = _PAGE_W * VGM_GRID_W;
            h = 16 * VGM_GRID_H;
        };
        class SkillTree: VGM_ctrlControlsGroupNoScrollbars
        {
            idc = VGM_IDC_DISPLAYSKILLS_SKILLTREE;
            x = _DISPLAY_X + (_SKILLS_W + 2) * VGM_GRID_W;
            y = _DISPLAY_Y + 11 * VGM_GRID_H;
            w = (_DISPLAY_W - _SKILLS_W - 3) * VGM_GRID_W;
            h = (_DISPLAY_H - 12) * VGM_GRID_H;
            colorBackground[] = {1,0,0,0.2};
        };
    };
};

#undef _DISPLAY_X
#undef _DISPLAY_Y
#undef _DISPLAY_W
#undef _DISPLAY_H
