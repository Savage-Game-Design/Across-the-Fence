#define ICON_SIZE 3
#define DISPLAY_W (2 * ICON_SIZE + 0.5)
#define DISPLAY_H ICON_SIZE
// Display is located on the bottom right:
#define DISPLAY_X (safeZoneX + safeZoneW - (DISPLAY_W + 0.5) * GUI_GRID_W)
#define DISPLAY_Y (safeZoneY + safeZoneH - (DISPLAY_H + 0.5) * GUI_GRID_H)
class VGM_RscAbilityCooldown
{
    idd = -1;
    onLoad = VGM_UIEH(onLoad,AbilityCooldown);
    onUnload = VGM_UIEH(onUnload,AbilityCooldown);
    duration = 1e10;
    fadeIn = 0;
    fadeOut = 0;
    class Controls
    {
        class MainLabel: RscText
        {
            style = 2;
            text = "$STR_VGM_SKILLS_UI_HUD_ACTIVES";
            colorText[] = {1,1,1,0.75};
            x = DISPLAY_X;
            y = DISPLAY_Y - 1.3 * GUI_GRID_H;
            w = DISPLAY_W * GUI_GRID_W;
            h = 1 * GUI_GRID_H;
        };

        class IconPrimary: RscPicture
        {
            idc = VGM_IDC_RSCABILITYCOOLDOWN_ICONPRIMARY;
            x = DISPLAY_X;
            y = DISPLAY_Y;
            w = ICON_SIZE * GUI_GRID_W;
            h = ICON_SIZE * GUI_GRID_H;
            text = "\a3\ui_f\data\Map\VehicleIcons\iconVehicle_ca.paa";
        };
        class CooldownPrimary: RscProgress
        {
            idc = VGM_IDC_RSCABILITYCOOLDOWN_COOLDOWNPRIMARY;
            style = ST_VERTICAL;
            colorBar[] = {1,0.8,0.8,0.5};
            x = DISPLAY_X;
            y = DISPLAY_Y;
            w = ICON_SIZE * GUI_GRID_W;
            h = ICON_SIZE * GUI_GRID_H;
        };
        class DurationPrimary: RscProgress
        {
            idc = VGM_IDC_RSCABILITYCOOLDOWN_DURATIONPRIMARY;
            style = ST_VERTICAL;
            colorBar[] = {0,1,0,0.3};
            x = DISPLAY_X;
            y = DISPLAY_Y;
            w = ICON_SIZE * GUI_GRID_W;
            h = ICON_SIZE * GUI_GRID_H;
        };
        class SecondsPrimary: RscStructuredText
        {
            idc = VGM_IDC_RSCABILITYCOOLDOWN_SECONDSPRIMARY;
            fade = 1;
            text = "999 s";
            shadow = 2;
            class Attributes
            {
                font = VGM_FONT;
                align = "right";
                shadow = 0;
            };
            x = DISPLAY_X;
            y = DISPLAY_Y + (ICON_SIZE - 1) * GUI_GRID_H;
            w = ICON_SIZE * GUI_GRID_W;
            h = 1 * GUI_GRID_H;
        };
        class IconUlimate: IconPrimary
        {
            idc = VGM_IDC_RSCABILITYCOOLDOWN_ICONULTIMATE;
            x = DISPLAY_X + (ICON_SIZE + 0.5) * GUI_GRID_W;
        };
        class CooldownUlimate: CooldownPrimary
        {
            idc = VGM_IDC_RSCABILITYCOOLDOWN_COOLDOWNULTIMATE;
            x = DISPLAY_X + (ICON_SIZE + 0.5) * GUI_GRID_W;
        };
        class DurationUlimate: DurationPrimary
        {
            idc = VGM_IDC_RSCABILITYCOOLDOWN_DURATIONULTIMATE;
            x = DISPLAY_X + (ICON_SIZE + 0.5) * GUI_GRID_W;
        };
        class SecondsUltimate: SecondsPrimary
        {
            idc = VGM_IDC_RSCABILITYCOOLDOWN_SECONDSULTIMATE;
            x = DISPLAY_X + (ICON_SIZE + 0.5) * GUI_GRID_W;
        };
    };
};
