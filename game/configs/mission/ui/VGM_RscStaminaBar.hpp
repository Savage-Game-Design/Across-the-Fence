
class VGM_RscStaminaBar
{
    idd = -1;
    onLoad = "['onLoad', _this#0] call vgm_c_fnc_displayStaminaBar;";
    duration = 1e39;
    fadeIn = 0;
    fadeOut = 0;

    class Controls
    {
        class VGM_ctrlStaminaBar: RscControlsGroupNoScrollbars
        {
            idc = VGM_IDC_STAMINABAR_CONTAINER;
            x = IGUI_GRID_STAMINA_X;
            y = IGUI_GRID_STAMINA_Y;
            w = IGUI_GRID_STAMINA_WAbs;
            h = 0.2 * IGUI_GRID_STAMINA_H;

            class Controls {
                class StaminaBar: RscPicture {
                    idc = VGM_IDC_STAMINABAR_BAR;
                    text = "\A3\Ui_f\data\IGUI\RscIngameUI\RscUnitInfo\stamina_ca.paa";
                    x = 0;
                    y = 0;
                    w = IGUI_GRID_STAMINA_WAbs;
                    h = 0.2 * IGUI_GRID_STAMINA_H;
                };
            };
        };
    };
};
