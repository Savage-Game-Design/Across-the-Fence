/*
    File: coordinates.inc
    Author: Savage Game Design
    Date: 2023-01-31
    Public: Yes

    Description:
        Defines UI coordinates. The coordinate system uses the pixel grid system
        (https://community.bistudio.com/wiki/Arma_3:_Pixel_Grid_System) and more
        specifically the pixelGridNoUIScale command to make the UI look the same
        on all UI scale settings at least.
*/

#include "\a3\3den\UI\macros.inc" // imports CENTER_X/Y, pixelScale

//// Define the width and height of a single column/line
// 3 * VGM_GRID_H is the default height of a control
// 1 grid is the spacing between two controls
#define VGM_GRID_W (pixelW * pixelGridNoUIScale * pixelScale)
#define VGM_GRID_H (pixelH * pixelGridNoUIScale * pixelScale)

//// Define boundaries so the UI does not go off-screen
// Maximum width of a control when palced at the minimum x coordinate
#define VGM_GRID_MAX_W 160
// Maximum height of a control when placed at the minimum y coordinate
#define VGM_GRID_MAX_H 110
// Minimum x coordinate, anything left of it should be considered offscreen
#define VGM_GRID_MIN_X (CENTER_X - 0.5 * VGM_GRID_MAX_W * VGM_GRID_W)
// Minimum y coordinate, anything above of it should be considered offscreen
#define VGM_GRID_MIN_Y (CENTER_Y - 0.5 * VGM_GRID_MAX_H * VGM_GRID_H)

//// Coordinates specific to UIs or controls
// Width of the folder's page in the skill tree UI
#define VGM_DISPLAYSKILLS_PAGE_W (0.5 * VGM_GRID_MAX_W - 2)
// Width of a ctrlSkill used in the skill tree UI
#define VGM_CTRLSKILL_W (1/3 * (VGM_DISPLAYSKILLS_PAGE_W - 2))

// Font heights used for size and sizeEx attributes
#define VGM_FONT_S 2.5
#define VGM_FONT_M 3 // Default size

