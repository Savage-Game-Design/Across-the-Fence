#define DISPLAY_W VGM_GRID_MAX_W
#define DISPLAY_H VGM_GRID_MAX_H
#define DISPLAY_X (CENTER_X - 0.5 * DISPLAY_W * VGM_GRID_W)
#define DISPLAY_Y (CENTER_Y - 0.5 * DISPLAY_H * VGM_GRID_H)

#define MARGIN 3

// PX_***_X/Y are the original image sizes of the images cut from the full person
#define PX_HEAD_X 74
#define PX_HEAD_Y 78
// HEAD_W is a constant and the reference point for all the other parts
#define HEAD_W 20
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
class VGM_DisplayMedical
{
    idd = -1;
    onLoad = VGM_UIEH(onLoad,Medical);
    class ControlsBackground
    {
        class Min: VGM_ctrlStatic
        {
            x = DISPLAY_X;
            y = DISPLAY_Y;
            w = DISPLAY_W * VGM_GRID_W;
            h = DISPLAY_H * VGM_GRID_H;
            colorBackground[] = {1,0,0,0.2};
        };
        // class Patient: VGM_ctrlActivePicture
        // {
        //     x = DISPLAY_X;
        //     y = DISPLAY_Y;
        //     w = DISPLAY_W * VGM_GRID_W;
        //     h = DISPLAY_H * VGM_GRID_H;
        // };
    };
    class Controls
    {
        class HeadIcon: VGM_ctrlActivePicture
        {
            text = "soldier_head.paa";
            x = DISPLAY_X + (0.5 * DISPLAY_W - 0.5 * HEAD_W) * VGM_GRID_W;
            y = DISPLAY_Y + (MARGIN) * VGM_GRID_H;
            w = HEAD_W * VGM_GRID_W;
            h = HEAD_H * VGM_GRID_H;
        };
        class TorsoIcon: HeadIcon
        {
            text = "soldier_torso.paa";
            x = DISPLAY_X + (0.5 * DISPLAY_W - 0.5 * TORSO_W) * VGM_GRID_W;
            y = DISPLAY_Y + (MARGIN + HEAD_H) * VGM_GRID_H;
            w = TORSO_W * VGM_GRID_W;
            h = TORSO_H * VGM_GRID_H;
        };
        class ArmLeftIcon: TorsoIcon
        {
            text = "soldier_arm_l.paa";
            x = DISPLAY_X + (0.5 * DISPLAY_W - ARMS_W - 0.5 * TORSO_W) * VGM_GRID_W;
            y = DISPLAY_Y + (MARGIN + HEAD_H + 3.5) * VGM_GRID_H;
            w = ARMS_W * VGM_GRID_W;
            h = ARMS_H * VGM_GRID_H;
        };
        class ArmRightIcon: ArmLeftIcon
        {
            text = "soldier_arm_r.paa";
            x = DISPLAY_X + (0.5 * DISPLAY_W + 0.5 * TORSO_W) * VGM_GRID_W;
        };
        class LegLeftIcon: TorsoIcon
        {
            text = "soldier_leg_l.paa";
            x = DISPLAY_X + (0.5 * DISPLAY_W - 0.5 * TORSO_W - 2) * VGM_GRID_W;
            y = DISPLAY_Y + (MARGIN + HEAD_H + TORSO_H) * VGM_GRID_H;
            w = LEG_L_W * VGM_GRID_W;
            h = LEG_L_H * VGM_GRID_H;
        };
        class LegRightIcon: LegLeftIcon
        {
            text = "soldier_leg_r.paa";
            x = DISPLAY_X + (0.5 * DISPLAY_W + 0.3) * VGM_GRID_W;
            w = LEG_R_W * VGM_GRID_W;
            h = LEG_R_H * VGM_GRID_H;
        };

        class Head: VGM_ctrlStack
        {
#define _W 50
#define _H 50
            idc = VGM_IDC_DISPLAYMEDICAL_HEAD;
            text = "Head";
            x = DISPLAY_X;
            y = DISPLAY_Y;
            w = _W * VGM_GRID_W;
            h = _H * VGM_GRID_H;
            show = 0;
            class Controls
            {
                class Background: VGM_ctrlBackground
                {
                    x = 0;
                    w = _W * VGM_GRID_W;
                    h = _H * VGM_GRID_H;
                    stackDisable = 1;
                };
                class Frame: VGM_ctrlFrame
                {
                    x = 0;
                    w = _W * VGM_GRID_W;
                    h = _H * VGM_GRID_H;
                    stackDisable = 1;
                };
                class Title: VGM_ctrlTitle
                {
                    onLoad = VGM_UIEH(setPartTitle,Medical);
                    idc = VGM_IDC_DISPLAYMEDICAL_PART_TITLE;
                    x = 0;
                    w = _W * VGM_GRID_W;
                    h = 5 * VGM_GRID_H;
                };
                class InjuriesLabel: VGM_ctrlStructuredText
                {
                    text = "Injuries";
                    x = 0;
                    w = _W * VGM_GRID_W;
                    h = 5 * VGM_GRID_H;
                };
                class Injuries: VGM_ctrlControlsTable
                {
                    idc = VGM_IDC_DISPLAYMEDICAL_PART_INJURIES;
                    x = 0;
                    w = _W * VGM_GRID_W;
                    h = _H * VGM_GRID_H;
                    stackFill = 1;
                    class RowTemplate
                    {
                        class Image
                        {
                            controlBaseClassPath[] = {"VGM_ctrlStaticPicture"};
                            columnX = 0;
                            controlOffsetY = 0;
                            columnW = 5 * VGM_GRID_W;
                            controlH = 5 * VGM_GRID_H;
                        };
                    };
                };
            };
        };
    };
};
