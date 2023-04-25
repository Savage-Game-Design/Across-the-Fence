class VGM_DisplayTest
{
    idd = -1;
    class ControlsBackground
    {
        class Back: VGM_ctrlStaticPicture
        {
            x = safeZoneX;
            y = safeZoneY;
            w = safeZoneW;
            h = safeZoneH;
        };
    };
    class Controls
    {
        class FramedControl: VGM_ctrlBackground
        {
            x = VGM_GRID_MIN_X;
            y = VGM_GRID_MIN_Y;
            w = VGM_GRID_MAX_W * VGM_GRID_W;
            h = VGM_GRID_MAX_H * VGM_GRID_H;
        };
        class TestFrame: VGM_ctrlFrame
        {
            frameColor[] = {1,0,0,1};
            frameWidth = pixelW;
            frameHeight = pixelH;
            x = VGM_GRID_MIN_X;
            y = VGM_GRID_MIN_Y;
            w = VGM_GRID_MAX_W * VGM_GRID_W;
            h = VGM_GRID_MAX_H * VGM_GRID_H;
        };
    };
};
