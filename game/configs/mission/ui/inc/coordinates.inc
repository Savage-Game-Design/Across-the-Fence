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

#include "\a3\3den\UI\macros.inc" // imports CENTER_X/Y
#include "\a3\ui_f\hpp\definecommongrids.inc"

//// Define the width and height of a single column/row
// 3 * VGM_GRID_H is the default height of a control
// 1 grid is the spacing between two controls
#define VGM_PIXELSCALE 0.375
#define VGM_GRID_W (pixelW * pixelGridNoUIScale * VGM_PIXELSCALE)
#define VGM_GRID_H (pixelH * pixelGridNoUIScale * VGM_PIXELSCALE)

//// Define boundaries so the UI does not go off-screen
// Maximum width of a control when palced at the minimum x coordinate
#define VGM_GRID_MAX_W 260
// Maximum height of a control when placed at the minimum y coordinate
#define VGM_GRID_MAX_H 140
// Minimum x coordinate, anything left of it should be considered offscreen
#define VGM_GRID_MIN_X (CENTER_X - 0.5 * VGM_GRID_MAX_W * VGM_GRID_W)
// Minimum y coordinate, anything above of it should be considered offscreen
#define VGM_GRID_MIN_Y (CENTER_Y - 0.5 * VGM_GRID_MAX_H * VGM_GRID_H)

//// Coordinates specific to UIs or controls
// Width of the folder's page in the skill tree UI
#define VGM_DISPLAYSKILLS_PAGE_W (0.5 * VGM_GRID_MAX_W - 2)
// Width of a ctrlSkill used in the skill tree UI
#define VGM_CTRLSKILL_W (1/3 * (VGM_DISPLAYSKILLS_PAGE_W - 2))
// Mission Selection UI
#define VGM_DISPLAYMISSIONS_COLUMN_W 0.25 * VGM_GRID_MAX_W
#define VGM_DISPLAYMISSIONS_COLUMN_CTRL_W (VGM_DISPLAYMISSIONS_COLUMN_W - 1)
#define VGM_DISPLAYMISSIONS_W (4 * VGM_DISPLAYMISSIONS_COLUMN_W)
#define VGM_DISPLAYMISSIONS_H VGM_GRID_MAX_H
#define VGM_DISPLAYMISSIONS_X (CENTER_X - 0.5 * VGM_DISPLAYMISSIONS_W * VGM_GRID_W)
#define VGM_DISPLAYMISSIONS_Y (CENTER_Y - 0.5 * VGM_DISPLAYMISSIONS_H * VGM_GRID_H)

// Menu UIs
#define VGM_MENUHEADER_H 9
#define VGM_MENU_X VGM_GRID_MIN_X
#define VGM_MENU_Y VGM_GRID_MIN_Y + (VGM_MENUHEADER_H + 1) * VGM_GRID_H
#define VGM_MENU_W VGM_GRID_MAX_W
#define VGM_MENU_H (VGM_GRID_MAX_H - (VGM_MENUHEADER_H + 1))
