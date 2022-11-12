////////////////////////////////////////////////////////////////////////////////////
//
//included by "ui_main.hpp"
//include all the import stuff, so we load this stuff inside scripts and use them.
//
////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////
/// Styles
///////////////////////////////////////////////////////////////////////////

/*Control types*/
#define CT_STATIC           0
#define CT_BUTTON           1
#define CT_EDIT             2
#define CT_SLIDER           3
#define CT_COMBO            4
#define CT_LISTBOX          5
#define CT_TOOLBOX          6
#define CT_CHECKBOXES       7
#define CT_PROGRESS         8
#define CT_HTML             9
#define CT_STATIC_SKEW      10
#define CT_ACTIVETEXT       11
#define CT_TREE             12
#define CT_STRUCTURED_TEXT  13
#define CT_CONTEXT_MENU     14
#define CT_CONTROLS_GROUP   15
#define CT_SHORTCUTBUTTON   16
#define CT_XKEYDESC         40
#define CT_XBUTTON          41
#define CT_XLISTBOX         42
#define CT_XSLIDER          43
#define CT_XCOMBO           44
#define CT_ANIMATED_TEXTURE 45
#define CT_OBJECT           80
#define CT_OBJECT_ZOOM      81
#define CT_OBJECT_CONTAINER 82
#define CT_OBJECT_CONT_ANIM 83
#define CT_LINEBREAK        98
#define CT_USER             99
#define CT_MAP              100
#define CT_MAP_MAIN         101
#define CT_LISTNBOX         102
#define CT_CHECKBOX         77

/*Static styles*/
#define ST_POS            0x0F
#define ST_HPOS           0x03
#define ST_VPOS           0x0C
#define ST_LEFT           0x00
#define ST_RIGHT          0x01
#define ST_CENTER         0x02
#define ST_DOWN           0x04
#define ST_UP             0x08
#define ST_VCENTER        0x0C

#define ST_TYPE           0xF0
#define ST_SINGLE         0x00
#define ST_MULTI          0x10
#define ST_TITLE_BAR      0x20
#define ST_PICTURE        0x30
#define ST_FRAME          0x40
#define ST_BACKGROUND     0x50
#define ST_GROUP_BOX      0x60
#define ST_GROUP_BOX2     0x70
#define ST_HUD_BACKGROUND 0x80
#define ST_TILE_PICTURE   0x90
#define ST_WITH_RECT      0xA0
#define ST_LINE           0xB0

#define ST_SHADOW         0x100
#define ST_NO_RECT        0x200
#define ST_KEEP_ASPECT_RATIO  0x800

#define ST_TITLE          ST_TITLE_BAR + ST_CENTER

/*Slider styles*/
#define SL_DIR            0x400
#define SL_VERT           0
#define SL_HORZ           0x400

#define SL_TEXTURES       0x10

/*progress bar */
#define ST_VERTICAL       0x01
#define ST_HORIZONTAL     0

/*Listbox styles*/
#define LB_TEXTURES       0x10
#define LB_MULTI          0x20

/*Tree styles*/
#define TR_SHOWROOT       1
#define TR_AUTOCOLLAPSE   2

/*MessageBox styles*/
#define MB_BUTTON_OK      1
#define MB_BUTTON_CANCEL  2
#define MB_BUTTON_USER    4



//SafeZone stuff
//Basic
//X
#define SZX(NUM)		(NUM * safezoneW + safezoneX)
#define SZX_CL(NUM)		((0.5 - NUM) * safezoneW + safezoneX)
#define SZX_CR(NUM)		((0.5 + NUM) * safezoneW + safezoneX)
//Y
#define SZY(NUM)		(NUM * safezoneH + safezoneY)
#define SZY_CU(NUM)		((0.5 - NUM) * safezoneH + safezoneY)
#define SZY_CD(NUM)		((0.5 + NUM) * safezoneH + safezoneY)
//W+H
#define SZW(NUM)		(NUM * safezoneW)
#define SZH(NUM)		(NUM * safezoneH)



////// Scaling with InterfaceSize - But at least stays at the same size, across all Resolutions/AspectRatios
//X Calculations:
#define UIX_CALC_A		(((getResolution select 4) min 1.2) / 40)
#define UIX_CALC_B		(safezoneX + (safezoneW - ((getResolution select 7) min 1.2))/2)
#define UIX_CALC		UIX_CALC_A + UIX_CALC_B

//Y Calculations:
#define UIY_CALC_A		((((getResolution select 4) min 1.2) / 1.2) / 25)
#define UIY_CALC_B		(safezoneY + (safezoneH - (((getResolution select 7) min 1.2) / 1.2))/2)
#define UIY_CALC		UIY_CALC_A + UIY_CALC_B
//X
#define UIX(NUM)		((NUM) * UIX_CALC)
#define UIX_LR(NUM)		(UIW(NUM) + safeZoneX)						//FROM Left -> Right
#define UIX_RL(NUM)		((UIW(NUM)*-1) + safeZoneX + safeZoneW)		//FROM Right -> Left
#define UIX_CR(NUM)		(((NUM) + 20) * UIX_CALC)						//FROM Center -> Right
#define UIX_CL(NUM)		((((NUM)*-1) + 20) * UIX_CALC)				//FROM Center -> Left
//Y
#define UIY(NUM)		((NUM) * UIY_CALC)
#define UIY_TD(NUM)		((UIH(NUM)) + safezoneY)					//FROM Top -> Downwards
#define UIY_BU(NUM)		((UIH(NUM)*-1) + safezoneY + safezoneH)		//FROM Bottom -> Upwards
#define UIY_CD(NUM)		(((NUM) + 12.5) * UIY_CALC)					//FROM Center -> Downwards
#define UIY_CU(NUM)		((((NUM)*-1) + 12.5) * UIY_CALC)				//FROM Center -> Upwards
//Width/Height
#define UIW(NUM)		((NUM) * UIX_CALC_A)
#define UIH(NUM)		((NUM) * UIY_CALC_A)


// Added: 20-11-19 - Dscha
// PixelGrid-Safezone hybrid - Same sizes and positions for every resolution
// Safezone is acting as the Anchorpoint
#define UI_GRID_W_UI	(pixelW * pixelGridNoUIScale)	// One grid width - ignoring InterfaceSize
#define UI_GRID_H_UI	(pixelH * pixelGridNoUIScale)	// One grid height - ignoring InterfaceSize

#define PXSZ_W(NUM) (NUM*UI_GRID_W_UI)
#define PXSZ_H(NUM) (NUM*UI_GRID_H_UI)

// NUMSZ = Anchorpoint in Safezone
// NUMPX = PixelGrid
#define PXSZ_X_LR(NUMSZ,NUMPX) ( SZX((NUMSZ/100)) + PXSZ_W(NUMPX) )		// Start: Left -> moving: Right
#define PXSZ_X_RL(NUMSZ,NUMPX) ( SZX((1-(NUMSZ/100))) - PXSZ_W(NUMPX) )	// Start: Right -> moving: left
#define PXSZ_X_CR(NUMSZ,NUMPX) ( SZX((0.5+(NUMSZ/100))) + PXSZ_W(NUMPX) )	// Start: Left -> moving: Right
#define PXSZ_X_CL(NUMSZ,NUMPX) ( SZX((0.5-(NUMSZ/100))) - PXSZ_W(NUMPX) )	// Start: Right -> moving: left

#define PXSZ_Y_TD(NUMSZ,NUMPX) ( SZY((NUMSZ/100)) + PXSZ_H(NUMPX) )		// Start: Top -> moving: Down
#define PXSZ_Y_BU(NUMSZ,NUMPX) ( SZY((1-(NUMSZ/100))) - PXSZ_H(NUMPX) )	// Start: Bottom -> moving: Up
#define PXSZ_Y_CD(NUMSZ,NUMPX) ( SZY((0.5+(NUMSZ/100))) + PXSZ_H(NUMPX) )	// Start: Center -> moving: Down
#define PXSZ_X_CU(NUMSZ,NUMPX) ( SZY((0.5-(NUMSZ/100))) - PXSZ_H(NUMPX) )	// Start: Center -> moving: Up
/*
Example:
_ctrlA ctrlSetPosition
[
	 PXSZ_X_CL(0,2.5)
	,PXSZ_Y_TD(5,0)
	,PXSZ_W(5)
	,PXSZ_H(5)
];
== The center of _ctrlA is in the horizontal center and moved 5% down from the top of the Screen.
Adding another one:
_ctrlB ctrlSetPosition
[
	 PXSZ_X_CL(0,7.5)
	,PXSZ_Y_TD(5,5)
	,PXSZ_W(5)
	,PXSZ_H(5)
];
== _ctrlB's top right corner/edge is at the same point as _ctrlA's bottom left corner/edge.
*/


// Colors:
#define COLOR_KEYBINDINGS_NORMAL_SELECTED [1,1,1,1]
#define COLOR_KEYBINDINGS_NORMAL_UNSELECTED [1,1,1,0.5]
#define COLOR_KEYBINDINGS_DOUBLEBIND_SELECTED [1,0,0,1]
#define COLOR_KEYBINDINGS_DOUBLEBIND_UNSELECTED [1,0,0,0.5]

//Text stuff:
#define USEDFONT "tt2020base_vn"
#define USEDFONT_B "tt2020base_vn_bold"
#define USEDFONT_ALT "tt2020style_e_vn"
#define USEDFONT_ALT_B "tt2020style_e_vn_bold"

#define CALCRESANDAR	UIY_CALC_A
#define TXT_CST(NUM)	(UIY_CALC_A * NUM)

// // Veteran Font
// #define TXT_XXS 		(UIY_CALC_A * 0.3)
// #define TXT_XS			(UIY_CALC_A * 0.5)
// #define TXT_S			(UIY_CALC_A * 0.7)
// #define TXT_M			(UIY_CALC_A * 0.9)
// #define TXT_L			(UIY_CALC_A * 1.1)
// #define TXT_XL			(UIY_CALC_A * 1.3)
// #define TXT_XXL			(UIY_CALC_A * 1.5)

// TT2020 size (takes the same place as the Veteran)
#define TXT_XXS			(UIY_CALC_A * 0.2)
#define TXT_XS			(UIY_CALC_A * 0.4)
#define TXT_S			(UIY_CALC_A * 0.65)
#define TXT_M			(UIY_CALC_A * 0.85)
#define TXT_L			(UIY_CALC_A * 1)
#define TXT_XL			(UIY_CALC_A * 1.3)
#define TXT_XXL			(UIY_CALC_A * 1.4)

//	PixelGrid-Safezone Fontsizes:
//	RscText Sizes:
#define TXT_PXSZ_XS				(PXSZ_H(0.75))
#define TXT_PXSZ_S				(PXSZ_H(0.85))
#define TXT_PXSZ_M				(PXSZ_H(1))
#define TXT_PXSZ_L				(PXSZ_H(1.4))
#define TXT_PXSZ_XL				(PXSZ_H(1.8))
/*	RscStructuredText Sizes:
Example usage:
_ctrl ctrlSetStructuredText parseText format["<t size='%1'>Lorem Ipsum</t>", TXT_PXSZ_STRC_S];
*/
#define TXT_PXSZ_STRC_XS	(PXSZ_H(24))
#define TXT_PXSZ_STRC_S		(PXSZ_H(30))
#define TXT_PXSZ_STRC_M		(PXSZ_H(37))
#define TXT_PXSZ_STRC_L		(PXSZ_H(44))
#define TXT_PXSZ_STRC_XL	(PXSZ_H(51))

// // Dscha's TT2020 size
// #define TXT_XXS				(UIY_CALC_A * 0.25)
// #define TXT_XS				(UIY_CALC_A * 0.5)
// #define TXT_S				(UIY_CALC_A * 0.75)
// #define TXT_M				(UIY_CALC_A * 1)
// #define TXT_L				(UIY_CALC_A * 1.2)
// #define TXT_XL				(UIY_CALC_A * 1.4)
// #define TXT_XXL				(UIY_CALC_A * 1.6)



//TASK ROSTER STANDARD VALUES:
//Background folder
#define PARA_FOLDER_X			UIX_CL(22.2)
#define PARA_FOLDER_Y			UIY_CU(12.5)
#define PARA_FOLDER_W			UIW(44.4)
#define PARA_FOLDER_H			UIH(25)

//Sheet: LEFT side
#define PARA_SHEET_L_X			UIX_CL(19)
#define PARA_SHEET_L_Y			UIY_CU(12)
#define PARA_SHEET_L_W			UIW(19.5)
#define PARA_SHEET_L_H			UIH(25)

//Sheet: RIGHT side
#define PARA_SHEET_R_X			UIX_CR(0.5)
#define PARA_SHEET_R_Y			UIY_CU(12)
#define PARA_SHEET_R_W			UIW(19.5)
#define PARA_SHEET_R_H			UIH(25)

//Cordles in the center
#define PARA_CORDLES_X			UIX_CL(1.6)
#define PARA_CORDLES_Y			UIY_CU(3.9)
#define PARA_CORDLES_W			UIW(4.25)
#define PARA_CORDLES_H			UIH(7.9)

//Mission Infos:
#define PARA_MISSIONSHEET_X	UIX_CR(0.5)
#define PARA_MISSIONSHEET_Y	UIY_CU(11.9)
#define PARA_MISSIONSHEET_W	UIW(19.5)
#define PARA_MISSIONSHEET_H	UIH(25)

#define PARA_MISSIONSHEET_POLA_W	UIW(19.5)
#define PARA_MISSIONSHEET_POLA_H	UIH(25)

// Dynamic Group Menu Left Side Group Ctrl:
#define PARA_DG_MANAGE_X  UIX_CL(18.3)
#define PARA_DG_MANAGE_Y  UIY_CU(11)
#define PARA_DG_MANAGE_W  UIW(17)
#define PARA_DG_MANAGE_H  UIH(20)

// Dynamic Group Menu Right Side Group Ctrl:
#define PARA_DG_GROUP_X  UIX_CR(2)
#define PARA_DG_GROUP_Y  UIY_CU(10)
#define PARA_DG_GROUP_W  UIW(17)
#define PARA_DG_GROUP_H  UIH(19)

// onLoad and onUnload script macro:
// #define PARA_INIT_DISPLAY(CLASSNAME) \
// 	onLoad = ["onLoad", _this, #CLASSNAME] call para_c_fnc_ui_initMissionDisplay;\
// 	onUnload = ["onUnload", _this, #CLASSNAME] call para_c_fnc_ui_initMissionDisplay;\

//Main File for IDDs and IDCs
#include "ui_def_idc.inc"
