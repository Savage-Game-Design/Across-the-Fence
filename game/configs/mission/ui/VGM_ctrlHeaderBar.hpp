#define VGM_MENUHEADER_H 7
#define VGM_MENU_X VGM_GRID_MIN_X
#define VGM_MENU_Y VGM_GRID_MIN_Y + VGM_MENUHEADER_H * VGM_GRID_H
#define VGM_MENU_W VGM_GRID_MAX_W
#define VGM_MENU_H (VGM_GRID_MAX_H - VGM_MENUHEADER_H)

#define _BTN_W ((VGM_MENU_W - 6) / 5)
#define _BTN_X(I) (I * _BTN_W + (I + 1)) * VGM_GRID_W

class VGM_ctrlHeaderBar: VGM_ctrlControlsGroupNoScrollbars
{
    x = VGM_MENU_X;
    y = VGM_GRID_MIN_Y;
    w = VGM_MENU_W * VGM_GRID_W;
    h = 7 * VGM_GRID_H;
    colorBackground[] = {1,0,0,0.2};
    class Controls
    {
        class Background: VGM_ctrlBackground
        {
            x = 0;
            y = 0;
            w = VGM_MENU_W * VGM_GRID_W;
            h = 7 * VGM_GRID_H;
        };
        class Equipment: VGM_ctrlButton
        {
            idc = -1;
            text = "Equipment";
            x = _BTN_X(0);
            y = 1 * VGM_GRID_H;
            w = _BTN_W * VGM_GRID_W;
            h = 5 * VGM_GRID_H;
        };
        class Abilities: Equipment
        {
            text = "Abilities";
            x = _BTN_X(1);
        };
        class SkillTree: Equipment
        {
            text = "Skill Tree";
            x = _BTN_X(2);
        };
        class Squad: Equipment
        {
            text = "Squad";
            x = _BTN_X(3);
        };
        class Settings: Equipment
        {
            text = "Settings";
            x = _BTN_X(4);
        };
    };
};

#undef _BTN_X
#undef _BTN_W
