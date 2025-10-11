class VGM_DisplayTest
{
    idd = -1;
    class ControlsBackground
    {
        class Back: VGM_ctrlStaticPicture
        {
            x = QUOTE(safeZoneX);
            y = QUOTE(safeZoneY);
            w = QUOTE(safeZoneW);
            h = QUOTE(safeZoneH);
        };
    };
    class Controls
    {
        class FramedControl: VGM_ctrlBackground
        {
            x = QUOTE(VGM_GRID_MIN_X);
            y = QUOTE(VGM_GRID_MIN_Y);
            w = QUOTE(VGM_GRID_MAX_W * VGM_GRID_W);
            h = QUOTE(VGM_GRID_MAX_H * VGM_GRID_H);
        };
        class TestFrame: VGM_ctrlFrame
        {
            frameColor[] = {1,0,0,1};
            frameWidth = QUOTE(pixelW);
            frameHeight = QUOTE(pixelH);
            x = QUOTE(VGM_GRID_MIN_X);
            y = QUOTE(VGM_GRID_MIN_Y);
            w = QUOTE(VGM_GRID_MAX_W * VGM_GRID_W);
            h = QUOTE(VGM_GRID_MAX_H * VGM_GRID_H);
        };
    };
};

class VGM_DisplayTestNotepad
{
    idd = -1;
    movingEnable = 0;
    enableSimulation = 1;

    class Objects
    {
        class Notepad: VGM_RscNotepad {};
    };
};
