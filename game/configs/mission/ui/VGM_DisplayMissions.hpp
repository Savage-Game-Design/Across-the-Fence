#define COLUMN_W 0.25 * VGM_GRID_MAX_W
#define COLUMN_CTRL_W (COLUMN_W - 1)
#define DISPLAY_W (4 * COLUMN_W)
#define DISPLAY_H (VGM_GRID_MAX_H)
#define DISPLAY_X (CENTER_X - 0.5 * DISPLAY_W * VGM_GRID_W)
#define DISPLAY_Y (CENTER_Y - 0.5 * DISPLAY_H * VGM_GRID_H)

VGM_SET_Y(6)
class VGM_DisplayMissions
{
    idd = VGM_IDD_DISPLAYMISSIONS;
    onLoad = ONLOAD;
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
        class Map: VGM_ctrlMap
        {
            x = DISPLAY_X;
            y = DISPLAY_Y;
            w = COLUMN_CTRL_W * VGM_GRID_W;
            h = DISPLAY_H * VGM_GRID_H;
        };
        class Recon: VGM_ctrlControlsGroup
        {
            x = DISPLAY_X + COLUMN_W * VGM_GRID_W;
            y = VGM_Y(DISPLAY_Y);
            w = COLUMN_CTRL_W * VGM_GRID_W;
            /* h = (COLUMN_W + 10) * VGM_GRID_H; */
            h = VGM_Y_H(COLUMN_W + 10);
            colorBackground[] = {1,0,0,0.2};
            class Controls
            {
                class Status: VGM_ctrlStructuredText
                {
                    text = "Active";
                    x = 0;
                    y = 0;
                    w = COLUMN_CTRL_W * VGM_GRID_W;
                    h = 5 * VGM_GRID_H;
                    colorBackground[] = {1,0,0,0.2};
                };
                class Name: Status
                {
                    text = "Recon";
                    size = VGM_FONT_L * VGM_GRID_H;
                    y = 5 * VGM_GRID_H;
                };
                class Image: VGM_ctrlStaticPicture
                {
                    text = "#(rgb,1,1,1)color(0,1,0,1)";
                    x = 0;
                    y = 10 * VGM_GRID_H;
                    w = COLUMN_CTRL_W * VGM_GRID_W;
                    h = COLUMN_CTRL_W * VGM_GRID_H;
                };
            };
        };
        class Standard: Recon
        {
            x = DISPLAY_X + 2 * COLUMN_W * VGM_GRID_W;
            class Controls: Controls
            {
                class Status: Status
                {
                };
                class Name: Name
                {
                    text = "Standard";
                };
                class Image: Image
                {
                };
            };
        };
        class Elite: Recon
        {
            x = DISPLAY_X + 3 * COLUMN_W * VGM_GRID_W;
            class Controls: Controls
            {
                class Status: Status
                {
                };
                class Name: Name
                {
                    text = "Elite";
                };
                class Image: Image
                {
                };
            };
        };
        class Description: VGM_ctrlStructuredText
        {
            text = "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.";
            x = DISPLAY_X + COLUMN_W * VGM_GRID_W;
            y = VGM_Y(DISPLAY_Y);
            w = (3 * COLUMN_W - 1) * VGM_GRID_W;
            h = VGM_Y_H(16);
            colorBackground[] = {1,0,0,0.2};
        };
        class Generate: VGM_ctrlButton
        {
            text = "Generate";
            sizeEx = 10 * VGM_GRID_H;
            x = DISPLAY_X + (COLUMN_W + 0.75 * COLUMN_W) * VGM_GRID_W;
            y = VGM_Y_Y(DISPLAY_Y,1);
            w = (1.5 * COLUMN_W) * VGM_GRID_W;
            h = 10 * VGM_GRID_H;
        };
    };
};
