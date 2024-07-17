#define _BTN_W ((VGM_MENU_W - 6) / 5)
#define _BTN_X(I) (I * _BTN_W + (I + 1)) * VGM_GRID_W
#define _STRTABLE(KEY) #$STR_VGM_HEADERBAR_##KEY
#define _DISPLAY(NAME) QUOTE(CONCAT_2(VGM_Display,NAME))
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
                    tooltip = _STRTABLE(MANAGE_EQUIPMENT);
                    display = _DISPLAY(Equipment); // The display that is opened when clicking the button
                    onLoad = VGM_UIEH(onLoadButton,MenuBase);
                    onButtonClick = VGM_UIEH(onClickEquipment,MenuBase);
                    x = _BTN_X(0);
                    y = 1 * VGM_GRID_H;
                    w = _BTN_W * VGM_GRID_W;
                    h = (VGM_MENUHEADER_H - 2) * VGM_GRID_H;
                    colorBackgroundDisabled[] = {VGM_UI_COLOR_BACKGROUND_DESELECTED};
                };
                class Abilities: Equipment
                {
                    text = _STRTABLE(ABILITIES);
                    tooltip = "";
                    display = _DISPLAY(Abilities);
                    onButtonClick = VGM_UIEH(onClickAbilities,MenuBase);
                    x = _BTN_X(1);
                };
                class SkillTree: Equipment
                {
                    text = _STRTABLE(SKILLTREE);
                    tooltip = "";
                    display = _DISPLAY(Skills);
                    onButtonClick = VGM_UIEH(onClickSkillTree,MenuBase);
                    x = _BTN_X(2);
                };
                class Squad: Equipment
                {
                    text = _STRTABLE(SQUAD);
                    tooltip = "";
                    display = _DISPLAY(Squad);
                    onButtonClick = VGM_UIEH(onClickSquad,MenuBase);
                    x = _BTN_X(3);
                };
                class Settings: Equipment
                {
                    text = _STRTABLE(SETTINGS);
                    tooltip = "";
                    display = _DISPLAY(Settings);
                    onButtonClick = VGM_UIEH(onClickSettings,MenuBase);
                    x = _BTN_X(4);
                };
            };
        };
    };
};

#undef _BTN_X
#undef _BTN_W
#undef _STRTABLE
#undef _DISPLAY
