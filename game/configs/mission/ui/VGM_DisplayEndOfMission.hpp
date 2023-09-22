#define DISPLAY_X VGM_GRID_MIN_X
#define DISPLAY_Y VGM_GRID_MIN_Y
#define DISPLAY_W VGM_GRID_MAX_W
#define DISPLAY_H VGM_GRID_MAX_H

#define COLUMN_W (0.5 * DISPLAY_W - 2)
class VGM_DisplayEndOfMission
{
    idd = VGM_IDD_DISPLAYENDOFMISSION;
    onLoad = VGM_UIEH(onLoad,EndOfMission);
    class ControlsBackground
    {
        class Background: VGM_ctrlBackground
        {
            x = DISPLAY_X;
            y = DISPLAY_Y;
            w = DISPLAY_W * VGM_GRID_W;
            h = DISPLAY_H * VGM_GRID_H;
        };
    };
    class Controls
    {
        class CurrentMissionTitle: VGM_ctrlTitle
        {
            text = "Current Mission";
            x = DISPLAY_X + 1 * VGM_GRID_W;
            y = DISPLAY_Y + 1 * VGM_GRID_H;
            w = (0.5 * DISPLAY_W - 2) * VGM_GRID_W;
        };
        class Description: VGM_ctrlStructuredText
        {
            idc = VGM_IDC_DISPLAYENDOFMISSION_DESCRIPTION;
            text = "Lorem ipsum dolor sit amet, officia excepteur ex fugiat reprehenderit enim labore culpa sint ad nisi Lorem pariatur mollit ex esse exercitation amet. Nisi anim cupidatat excepteur officia. Reprehenderit nostrud nostrud ipsum Lorem est aliquip amet voluptate voluptate dolor minim nulla est proident. Nostrud officia pariatur ut officia. Sit irure elit esse ea nulla sunt ex occaecat reprehenderit commodo officia dolor Lorem duis laboris cupidatat officia voluptate. Culpa proident adipisicing id nulla nisi laboris ex in Lorem sunt duis officia eiusmod. Aliqua reprehenderit commodo ex non excepteur duis sunt velit enim. Voluptate laboris sint cupidatat ullamco ut ea consectetur et est culpa et culpa duis.";
            x = DISPLAY_X + 1 * VGM_GRID_W;
            y = DISPLAY_Y + 7 * VGM_GRID_H;
            w = COLUMN_W * VGM_GRID_W;
            h = (DISPLAY_H - 15 - 5) * VGM_GRID_H;
        };
        class Create: VGM_ctrlButton
        {
            idc = VGM_IDC_DISPLAYENDOFMISSION_CREATE;
            text = "Create";
            x = DISPLAY_X + 1 * VGM_GRID_W;
            y = DISPLAY_Y + (DISPLAY_H - 12) * VGM_GRID_H;
            w = COLUMN_W * VGM_GRID_W;
            h = 5 * VGM_GRID_H;
        };
        class Deploy: Create
        {
            idc = VGM_IDC_DISPLAYENDOFMISSION_DEPLOY;
            text = "Deploy";
            y = DISPLAY_Y + (DISPLAY_H - 6) * VGM_GRID_H;
        };

        class MissionsTitle: CurrentMissionTitle
        {
            text = "Missions";
            x = DISPLAY_X + (COLUMN_W + 3) * VGM_GRID_W;
        };
        class List: VGM_ctrlListBox
        {
            idc = VGM_IDC_DISPLAYENDOFMISSION_LIST;
            x = DISPLAY_X + (COLUMN_W + 3) * VGM_GRID_W;
            y = DISPLAY_Y + 7 * VGM_GRID_H;
            w = COLUMN_W * VGM_GRID_W;
            h = (DISPLAY_H - 14) * VGM_GRID_H;
        };
        class Join: Deploy
        {
            idc = VGM_IDC_DISPLAYENDOFMISSION_JOIN;
            text = "Join";
            x = DISPLAY_X + (COLUMN_W + 3) * VGM_GRID_W;
        };
    };
};
