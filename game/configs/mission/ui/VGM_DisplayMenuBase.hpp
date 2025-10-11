#define _BTN_CNT 5
#define _BTN_W_HELP 8
#define _BTN_W ((VGM_MENU_W - 6 - _BTN_W_HELP) / _BTN_CNT)
#define _BTN_X(I) (I * _BTN_W + (I + 1)) * VGM_GRID_W
#define _STRTABLE(KEY) QUOTE(CONCAT_2($STR_VGM_HEADERBAR_,KEY))
#define _DISPLAY(NAME) QUOTE(CONCAT_2(VGM_Display,NAME))
class VGM_DisplayMenuBase
{
    idd = -1;
    class ControlsBackground
    {
        class Background: VGM_ctrlControlsGroupNoScrollbars
        {
            x = QUOTE(VGM_MENU_X);
            y = QUOTE(VGM_GRID_MIN_Y);
            w = QUOTE(VGM_MENU_W * VGM_GRID_W);
            h = QUOTE((VGM_MENU_H + VGM_MENUHEADER_H + 1) * VGM_GRID_H);
            class Controls
            {
                class BackgroundHeaderBar: VGM_ctrlBackground
                {
                    x = 0;
                    y = 0;
                    w = QUOTE(VGM_MENU_W * VGM_GRID_W);
                    h = QUOTE(VGM_MENUHEADER_H * VGM_GRID_H);
                };
                class BackgroundBody: BackgroundHeaderBar
                {
                    y = QUOTE((VGM_MENUHEADER_H + 1) * VGM_GRID_H);
                    h = QUOTE(VGM_MENU_H * VGM_GRID_H);
                };
            };
        };
    };
    class Controls
    {
        class HeaderBar: VGM_ctrlControlsGroupNoScrollbars
        {
            x = QUOTE(VGM_MENU_X);
            y = QUOTE(VGM_GRID_MIN_Y);
            w = QUOTE(VGM_MENU_W * VGM_GRID_W);
            h = QUOTE(VGM_MENUHEADER_H * VGM_GRID_H);
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
                    x = QUOTE(_BTN_X(0));
                    y = QUOTE(1 * VGM_GRID_H);
                    w = QUOTE(_BTN_W * VGM_GRID_W);
                    h = QUOTE((VGM_MENUHEADER_H - 2) * VGM_GRID_H);
                    colorBackgroundDisabled[] = {VGM_UI_COLOR_BACKGROUND_DESELECTED};
                };
                class Abilities: Equipment
                {
                    text = _STRTABLE(ABILITIES);
                    tooltip = "";
                    display = _DISPLAY(Abilities);
                    onButtonClick = VGM_UIEH(onClickAbilities,MenuBase);
                    x = QUOTE(_BTN_X(1));
                };
                class SkillTree: Equipment
                {
                    text = _STRTABLE(SKILLTREE);
                    tooltip = "";
                    display = _DISPLAY(Skills);
                    onButtonClick = VGM_UIEH(onClickSkillTree,MenuBase);
                    x = QUOTE(_BTN_X(2));
                };
                class Squad: Equipment
                {
                    text = _STRTABLE(SQUAD);
                    tooltip = "";
                    display = _DISPLAY(Squad);
                    onButtonClick = VGM_UIEH(onClickSquad,MenuBase);
                    x = QUOTE(_BTN_X(3));
                };
                class Settings: Equipment
                {
                    text = _STRTABLE(SETTINGS);
                    tooltip = "";
                    display = _DISPLAY(Settings);
                    onButtonClick = VGM_UIEH(onClickSettings,MenuBase);
                    x = QUOTE(_BTN_X(4));
                };

                class Help: VGM_ctrlButton
                {
                    text = "?";
                    tooltip = "$STR_A3_RscDisplayInterrupt_ButtonTutorialHints";
                    onButtonClick = VGM_UIEH(onClickHelp,MenuBase);
                    x = QUOTE(_BTN_X(5));
                    y = QUOTE(1 * VGM_GRID_H);
                    w = QUOTE((_BTN_W_HELP - 1) * VGM_GRID_W);
                    h = QUOTE((VGM_MENUHEADER_H - 2) * VGM_GRID_H);
                };

            };
        };
    };
};

#undef _BTN_CNT
#undef _BTN_X
#undef _BTN_W
#undef _STRTABLE
#undef _DISPLAY
