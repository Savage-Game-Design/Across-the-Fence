import ctrlStatic;
import ctrlStructuredText;
import ctrlTree;
import ctrlControlsGroup;
import ctrlButton;
import ctrlButtonPicture;

#define COLOR_BLACK {0,0,0,1}
class VGM_ctrlStatic: ctrlStatic {};
class VGM_ctrlStructuredText : ctrlStructuredText
{
    size = 1 * VGM_GRID_H;
    shadow = 0;
    class Attributes
    {
        font = VGM_FONT;
        color = "#000000";
        colorLink = "#D09B43";
        align = "left";
        shadow = 0;
    };
};

class VGM_ctrlTree: ctrlTree
{
    colorText[] = COLOR_BLACK;
    colorBorder[] = COLOR_BLACK;
    colorLines[] = COLOR_BLACK;
    colorArrow[] = COLOR_BLACK;
    hiddenTexture = "";
    expandedTexture = "";
    font = VGM_FONT;
};

class VGM_ctrlControlsGroup: ctrlControlsGroup
{
};

class VGM_ctrlButton: ctrlButton
{
    colorText[] = {0,0,0,1};
    font = VGM_FONT;
};

class VGM_ctrlButtonPicture: ctrlButtonPicture
{
};
