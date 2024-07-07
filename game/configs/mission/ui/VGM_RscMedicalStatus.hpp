#define DISPLAY_W (TORSO_W + ARMS_W * 2 + 19)
#define DISPLAY_H (HEAD_H + TORSO_H + LEG_R_H)

//#define DISPLAY_X (CENTER_X - 0.5 * DISPLAY_W * VGM_GRID_W)
//#define DISPLAY_Y (CENTER_Y - 0.5 * DISPLAY_H * VGM_GRID_H)

#define DISPLAY_X (safeZoneX + safeZoneW - (DISPLAY_W) * VGM_GRID_W)
// middle of the screen
// #define DISPLAY_Y (safeZoneY + safeZoneH/2 - (DISPLAY_H/2) * VGM_GRID_H)
// above cooldown icons
#define DISPLAY_Y (safeZoneY + safeZoneH - (DISPLAY_H * VGM_GRID_H) - (5.5 * GUI_GRID_H))

#define MARGIN 0

// PX_***_X/Y are the original image sizes of the images cut from the full person
#define PX_HEAD_X 74
#define PX_HEAD_Y 78
// HEAD_W is a constant and the reference point for all the other parts, this controls whole display size
#define HEAD_W 5
// PART_H the product of the ratio of the original image and the control's width
#define HEAD_H (PX_HEAD_X/PX_HEAD_Y * HEAD_W)
#define PX_TORSO_X 111
#define PX_TORSO_Y 177
// To adjust for stretching the width of a part is calculated relative to the head
#define TORSO_W (PX_TORSO_X/PX_HEAD_X * HEAD_W)
#define TORSO_H (PX_TORSO_Y/PX_TORSO_X * TORSO_W)
#define PX_ARMS_X 32
#define PX_ARMS_Y 208
#define ARMS_W (PX_ARMS_X/PX_HEAD_X * HEAD_W)
#define ARMS_H (PX_ARMS_Y/PX_ARMS_X * ARMS_W)
#define PX_LEG_L_X 64
#define PX_LEG_L_Y 243
#define LEG_L_W (PX_LEG_L_X/PX_HEAD_X * HEAD_W)
#define LEG_L_H (PX_LEG_L_Y/PX_LEG_L_X * LEG_L_W)
#define PX_LEG_R_X 64
#define PX_LEG_R_Y 256
#define LEG_R_W (PX_LEG_R_X/PX_HEAD_X * HEAD_W)
#define LEG_R_H (PX_LEG_R_Y/PX_LEG_R_X * LEG_R_W)

class VGM_RscMedicalStatus
{
    idd = -1;
    onLoad = VGM_UIEH(onLoadHud,Medical);
    onUnload = VGM_UIEH(onUnloadHud,Medical);
    duration = 1e10;
    fadeIn = 0;
    fadeOut = 0;

    class Controls
    {
        /*class Background: VGM_ctrlBackground
        {
            x = DISPLAY_X;
            y = DISPLAY_Y;
            w = DISPLAY_W * VGM_GRID_W;
            h = DISPLAY_H * VGM_GRID_H;
        };*/

        class MainLabel: RscText
        {
            style = 2;
            text = "$STR_VGM_MEDICAL_UI_HEALTH_STATUS";
            colorText[] = {1,1,1,0.75};
            x = DISPLAY_X;
            y = DISPLAY_Y - ((5.0) * VGM_GRID_H) - (0.65 * GUI_GRID_H);
            w = DISPLAY_W * VGM_GRID_W;
            h = 1 * GUI_GRID_H;
        };
        class ControlsHint: RscText
        {
            idc = VGM_IDC_DISPLAYMEDICAL_CONTROLSHINT;
            style = 2;
            text = "$STR_VGM_MEDICAL_UI_HEALTH_STATUS_KEYBIND";
            colorText[] = {1,1,1,0.75};
            x = DISPLAY_X;
            y = DISPLAY_Y - (4.5 * VGM_GRID_H);
            w = DISPLAY_W * VGM_GRID_W;
            h = 1 * GUI_GRID_H;
            sizeEx = 0.66 * GUI_GRID_H;
        };

        class HeadIcon: VGM_ctrlPicture
        {
            idc = VGM_IDC_DISPLAYMEDICAL_HEAD;
            text = "soldier_head.paa";
            x = DISPLAY_X + (0.5 * DISPLAY_W - 0.5 * HEAD_W) * VGM_GRID_W;
            y = DISPLAY_Y + (MARGIN) * VGM_GRID_H;
            w = HEAD_W * VGM_GRID_W;
            h = HEAD_H * VGM_GRID_H;
        };
        class TorsoIcon: HeadIcon
        {
            idc = VGM_IDC_DISPLAYMEDICAL_TORSO;
            text = "soldier_torso.paa";
            x = DISPLAY_X + (0.5 * DISPLAY_W - 0.5 * TORSO_W) * VGM_GRID_W;
            y = DISPLAY_Y + (MARGIN + HEAD_H) * VGM_GRID_H;
            w = TORSO_W * VGM_GRID_W;
            h = TORSO_H * VGM_GRID_H;
        };
        class ArmLeftIcon: TorsoIcon
        {
            idc = VGM_IDC_DISPLAYMEDICAL_ARMLEFT;
            text = "soldier_arm_l.paa";
            x = DISPLAY_X + (0.5 * DISPLAY_W - ARMS_W - 0.5 * TORSO_W) * VGM_GRID_W;
            y = DISPLAY_Y + (MARGIN + HEAD_H + (HEAD_W/5.71)) * VGM_GRID_H;
            w = ARMS_W * VGM_GRID_W;
            h = ARMS_H * VGM_GRID_H;
        };
        class ArmRightIcon: ArmLeftIcon
        {
            idc = VGM_IDC_DISPLAYMEDICAL_ARMRIGHT;
            text = "soldier_arm_r.paa";
            x = DISPLAY_X + (0.5 * DISPLAY_W + 0.5 * TORSO_W) * VGM_GRID_W;
        };
        class LegLeftIcon: TorsoIcon
        {
            idc = VGM_IDC_DISPLAYMEDICAL_LEGLEFT;
            text = "soldier_leg_l.paa";
            x = DISPLAY_X + (0.5 * DISPLAY_W - 0.5 * TORSO_W - (HEAD_W/10)) * VGM_GRID_W;
            y = DISPLAY_Y + (MARGIN + HEAD_H + TORSO_H) * VGM_GRID_H;
            w = LEG_L_W * VGM_GRID_W;
            h = LEG_L_H * VGM_GRID_H;
        };
        class LegRightIcon: LegLeftIcon
        {
            idc = VGM_IDC_DISPLAYMEDICAL_LEGRIGHT;
            text = "soldier_leg_r.paa";
            x = DISPLAY_X + (0.5 * DISPLAY_W + (HEAD_W/66.66)) * VGM_GRID_W;
            w = LEG_R_W * VGM_GRID_W;
            h = LEG_R_H * VGM_GRID_H;
        };
    };
};
