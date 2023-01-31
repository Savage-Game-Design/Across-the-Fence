#include "\a3\3den\UI\macros.inc" // imports CENTER_X/Y, pixelScale
// Define the width and height of a single column/line
#define VGM_GRID_W (pixelW * pixelGridNoUIScale * pixelScale)
#define VGM_GRID_H (pixelH * pixelGridNoUIScale * pixelScale)

// Define boundaries so the UI does not go off-screen
#define VGM_GRID_MAX_W 160
#define VGM_GRID_MAX_H 110
#define VGM_GRID_MIN_X (CENTER_X - 0.5 * VGM_GRID_MAX_W * VGM_GRID_W)
#define VGM_GRID_MIN_Y (CENTER_Y - 0.5 * VGM_GRID_MAX_H * VGM_GRID_H)

#define VGM_DISPLAYSKILLS_PAGE_W (0.5 * VGM_GRID_MAX_W - 2)
#define VGM_CTRLSKILL_W (1/3 * (VGM_DISPLAYSKILLS_PAGE_W - 2))

#define VGM_FONT_S 2.5
#define VGM_FONT_M 3
