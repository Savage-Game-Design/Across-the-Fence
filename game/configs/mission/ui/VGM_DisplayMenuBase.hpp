#define VGM_MENUHEADER_H 9
#define VGM_MENU_X VGM_GRID_MIN_X
#define VGM_MENU_Y VGM_GRID_MIN_Y + (VGM_MENUHEADER_H + 1) * VGM_GRID_H
#define VGM_MENU_W VGM_GRID_MAX_W
#define VGM_MENU_H (VGM_GRID_MAX_H - (VGM_MENUHEADER_H + 1))

#define _BTN_W ((VGM_MENU_W - 6) / 5)
#define _BTN_X(I) (I * _BTN_W + (I + 1)) * VGM_GRID_W
#define _STRTABLE(KEY) #$STR_VGM_HEADERBAR_##KEY
class VGM_DisplayMenuBase
{
    idd = -1;
    class ControlsBackground
    {
        class Background: VGM_ctrlControlsGroupNoScrollbars
        {
            x = VGM_MENU_X;
            y = VGM_GRID_MIN_Y;
            w = VGM_MENU_W * VGM_GRID_W;
            h = (VGM_MENU_H + VGM_MENUHEADER_H + 1) * VGM_GRID_H;
            class Controls
            {
                class BackgroundHeaderBar: VGM_ctrlBackground
                {
                    x = 0;
                    y = 0;
                    w = VGM_MENU_W * VGM_GRID_W;
                    h = VGM_MENUHEADER_H * VGM_GRID_H;
                };
                class BackgroundBody: BackgroundHeaderBar
                {
                    y = (VGM_MENUHEADER_H + 1) * VGM_GRID_H;
                    h = VGM_MENU_H * VGM_GRID_H;
                };
            };
        };
    };
    class Controls
    {
        class HeaderBar: VGM_ctrlControlsGroupNoScrollbars
        {
            x = VGM_MENU_X;
            y = VGM_GRID_MIN_Y;
            w = VGM_MENU_W * VGM_GRID_W;
            h = VGM_MENUHEADER_H * VGM_GRID_H;
            class Controls
            {
                class Equipment: VGM_ctrlButton
                {
                    idc = -1;
                    text = _STRTABLE(EQUIPMENT);
                    x = _BTN_X(0);
                    y = 1 * VGM_GRID_H;
                    w = _BTN_W * VGM_GRID_W;
                    h = (VGM_MENUHEADER_H - 2) * VGM_GRID_H;
                };
                class Abilities: Equipment
                {
                    text = _STRTABLE(ABILITIES);
                    x = _BTN_X(1);
                };
                class SkillTree: Equipment
                {
                    text = _STRTABLE(SKILLTREE);
                    x = _BTN_X(2);
                };
                class Squad: Equipment
                {
                    text = _STRTABLE(SQUAD);
                    x = _BTN_X(3);
                };
                class Settings: Equipment
                {
                    text = _STRTABLE(SETTINGS);
                    x = _BTN_X(4);
                };
            };
        };
    };
};

#undef _BTN_X
#undef _BTN_W
