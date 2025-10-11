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
    onUnload = VGM_UIEH(onUnload,Medical);
    onMouseButtonDown = VGM_UIEH(mouseDown,Medical);
    class ControlsBackground
    {
        class Min: VGM_ctrlBackground
        {
            x = QUOTE(DISPLAY_X);
            y = QUOTE(DISPLAY_Y - (4 * VGM_GRID_H));
            w = QUOTE(DISPLAY_W * VGM_GRID_W);
            h = QUOTE(DISPLAY_H * VGM_GRID_H + (4 * VGM_GRID_H));
        };
        class TitlePatient: VGM_ctrlTitle
        {
            idc = VGM_IDC_DISPLAYMEDICAL_PATIENT_TITLE;
            text = "PatientName";
            colorBackground[] = {VGM_UI_COLOR_BACKGROUND};
            x = QUOTE(DISPLAY_X);
            y = QUOTE(DISPLAY_Y - (3.5 * VGM_GRID_H));
            w = QUOTE(DISPLAY_W * VGM_GRID_W);
            h = QUOTE(4 * VGM_GRID_H);
        };
    };
    class Controls
    {
        class Treatment: VGM_ctrlStack
        {
            #define _W 50
            #define _H 50
            idc = VGM_IDC_DISPLAYMEDICAL_TREATMENT;
            x = 0;
            y = 0;
            w = QUOTE(_W * VGM_GRID_W);
            h = QUOTE(_H * VGM_GRID_H);
            class Controls
            {
                class Background: VGM_ctrlBackground
                {
                    x = 0;
                    w = QUOTE(_W * VGM_GRID_W);
                    h = QUOTE(_H * VGM_GRID_H);
                    stackDisable = 1;
                };
                class Frame: VGM_ctrlFrame
                {
                    x = 0;
                    w = QUOTE(_W * VGM_GRID_W);
                    h = QUOTE(_H * VGM_GRID_H);
                    stackDisable = 1;
                };
                class Title: VGM_ctrlTitle
                {
                    idc = VGM_IDC_DISPLAYMEDICAL_TREATMENT_TITLE;
                    text = "Part";
                    x = 0;
                    w = QUOTE(_W * VGM_GRID_W);
                    h = QUOTE(5 * VGM_GRID_H);
                };
                class InjuriesCount: VGM_ctrlStructuredText
                {
                    idc = VGM_IDC_DISPLAYMEDICAL_TREATMENT_INJURIESCOUNT;
                    text = "99 Injuries";
                    x = 0;
                    w = QUOTE(_W * VGM_GRID_W);
                    h = QUOTE(5 * VGM_GRID_H);
                };
                class Options: VGM_ctrlControlsTable
                {
                    idc = VGM_IDC_DISPLAYMEDICAL_TREATMENT_OPTIONS;
                    x = 0;
                    w = QUOTE(_W * VGM_GRID_W);
                    h = QUOTE(_H * VGM_GRID_H);
                    stackFill = 1;
                    rowHeight = QUOTE(10 * VGM_GRID_H);
                    class RowTemplate
                    {
                        class Image
                        {
                            controlBaseClassPath[] = {"VGM_ctrlStaticPictureKeepAspect"};
                            columnX = 0;
                            controlOffsetY = 0;
                            columnW = QUOTE((16/9) * 10 * VGM_GRID_W);
                            controlH = QUOTE(10 * VGM_GRID_H);
                        };
                        class Name: Image
                        {
                            controlBaseClassPath[] = {"VGM_ctrlStructuredText"};
                            columnX = QUOTE((16/9) * 10 * VGM_GRID_W);
                            columnW = QUOTE((_W - (16/9) * 10) * VGM_GRID_W);
                        };
                        class Button: VGM_ctrlButtonInvisible
                        {
                            controlBaseClassPath[] = {"VGM_DisplayMedical", "Controls", "Treatment", "Controls", "Options", "RowTemplate", "Button"};
                            columnX = 0;
                            controlOffsetY = 0;
                            columnW = QUOTE(_W * VGM_GRID_W);
                            controlH = QUOTE(10 * VGM_GRID_H);
                            colorBackgroundActive[] = {VGM_UI_COLOR_ACTIVE_RGB, 0.3};
                            onButtonClick = VGM_UIEH(selectTreatment,Medical);
                        };
                    };
                };
            };
        };

        class HeadIcon: VGM_ctrlActivePicture
        {
            idc = VGM_IDC_DISPLAYMEDICAL_HEAD;
            text = "soldier_head.paa";
            onButtonClick = VGM_UIEH(selectPart,Medical);
            colorActive[] = {0.8,0.8,0.8,1};
            x = QUOTE(DISPLAY_X + (0.5 * DISPLAY_W - 0.5 * HEAD_W) * VGM_GRID_W);
            y = QUOTE(DISPLAY_Y + (MARGIN) * VGM_GRID_H);
            w = QUOTE(HEAD_W * VGM_GRID_W);
            h = QUOTE(HEAD_H * VGM_GRID_H);
        };
        class TorsoIcon: HeadIcon
        {
            idc = VGM_IDC_DISPLAYMEDICAL_TORSO;
            text = "soldier_torso.paa";
            x = QUOTE(DISPLAY_X + (0.5 * DISPLAY_W - 0.5 * TORSO_W) * VGM_GRID_W);
            y = QUOTE(DISPLAY_Y + (MARGIN + HEAD_H) * VGM_GRID_H);
            w = QUOTE(TORSO_W * VGM_GRID_W);
            h = QUOTE(TORSO_H * VGM_GRID_H);
        };
        class ArmLeftIcon: TorsoIcon
        {
            idc = VGM_IDC_DISPLAYMEDICAL_ARMLEFT;
            text = "soldier_arm_l.paa";
            x = QUOTE(DISPLAY_X + (0.5 * DISPLAY_W - ARMS_W - 0.5 * TORSO_W) * VGM_GRID_W);
            y = QUOTE(DISPLAY_Y + (MARGIN + HEAD_H + 3.5) * VGM_GRID_H);
            w = QUOTE(ARMS_W * VGM_GRID_W);
            h = QUOTE(ARMS_H * VGM_GRID_H);
        };
        class ArmRightIcon: ArmLeftIcon
        {
            idc = VGM_IDC_DISPLAYMEDICAL_ARMRIGHT;
            text = "soldier_arm_r.paa";
            x = QUOTE(DISPLAY_X + (0.5 * DISPLAY_W + 0.5 * TORSO_W) * VGM_GRID_W);
        };
        class LegLeftIcon: TorsoIcon
        {
            idc = VGM_IDC_DISPLAYMEDICAL_LEGLEFT;
            text = "soldier_leg_l.paa";
            x = QUOTE(DISPLAY_X + (0.5 * DISPLAY_W - 0.5 * TORSO_W - 2) * VGM_GRID_W);
            y = QUOTE(DISPLAY_Y + (MARGIN + HEAD_H + TORSO_H) * VGM_GRID_H);
            w = QUOTE(LEG_L_W * VGM_GRID_W);
            h = QUOTE(LEG_L_H * VGM_GRID_H);
        };
        class LegRightIcon: LegLeftIcon
        {
            idc = VGM_IDC_DISPLAYMEDICAL_LEGRIGHT;
            text = "soldier_leg_r.paa";
            x = QUOTE(DISPLAY_X + (0.5 * DISPLAY_W + 0.3) * VGM_GRID_W);
            w = QUOTE(LEG_R_W * VGM_GRID_W);
            h = QUOTE(LEG_R_H * VGM_GRID_H);
        };

        class ModifierList: VGM_ctrlControlsTable
        {
            #define _W 80
            #define _H_ROW 12
            idc = VGM_IDC_DISPLAYMEDICAL_MODIFIERLIST;
            x = QUOTE(DISPLAY_X + (DISPLAY_W - _W) * VGM_GRID_W);
            y = QUOTE(DISPLAY_Y);
            w = QUOTE(_W * VGM_GRID_W);
            h = QUOTE(DISPLAY_H * VGM_GRID_H);
            rowHeight = QUOTE(_H_ROW * VGM_GRID_H);
            class VScrollbar: ScrollbarInvisible
            {
            };
            class RowTemplate
            {
                class Background
                {
                    controlBaseClassPath[] = {"VGM_ctrlBackground"};
                    columnX = 0;
                    controlOffsetY = 0;
                    columnW = QUOTE(_W * VGM_GRID_W);
                    controlH = QUOTE(_H_ROW * VGM_GRID_H);
                };
                class Icon: Background
                {
                    controlBaseClassPath[] = {"VGM_ctrlStaticPicture"};
                    columnX = QUOTE(1 * VGM_GRID_W);
                    controlOffsetY = QUOTE(1 * VGM_GRID_H);
                    columnW = QUOTE((_H_ROW - 2) * VGM_GRID_W);
                    controlH = QUOTE((_H_ROW - 2) * VGM_GRID_H);
                };
                class Description: Background
                {
                    controlBaseClassPath[] = {"VGM_ctrlStructuredText"};
                    columnX = QUOTE((_H_ROW) * VGM_GRID_W);
                    controlOffsetY = QUOTE(1 * VGM_GRID_H);
                    columnW = QUOTE((_W - _H_ROW) * VGM_GRID_W);
                    controlH = QUOTE((_H_ROW - 2) * VGM_GRID_H);
                };
            };
        };

        class Help: VGM_ctrlButton
        {
            idc = -1;
            text = "?";
            colorBackground[] = {0,0,0,0};
            x = QUOTE(DISPLAY_X + DISPLAY_W * VGM_GRID_W - 4.5 * VGM_GRID_W);
            y = QUOTE(DISPLAY_Y - (3.5 * VGM_GRID_H));
            w = QUOTE(4 * VGM_GRID_W);
            h = QUOTE(4 * VGM_GRID_H);

            onButtonClick = "['vgm', 'medical', uiNamespace getVariable 'VGM_DisplayMedical'] call vgm_c_fnc_openFieldManual";
        };
    };
};
