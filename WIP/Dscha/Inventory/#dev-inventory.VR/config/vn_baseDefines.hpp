///////////////////////////////////////////////////////////////////////////
/// Styles
///////////////////////////////////////////////////////////////////////////

// Control types
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

// Static styles
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

// Slider styles
#define SL_DIR            0x400
#define SL_VERT           0
#define SL_HORZ           0x400

#define SL_TEXTURES       0x10

// progress bar 
#define ST_VERTICAL       0x01
#define ST_HORIZONTAL     0

// Listbox styles
#define LB_TEXTURES       0x10
#define LB_MULTI          0x20

// Tree styles
#define TR_SHOWROOT       1
#define TR_AUTOCOLLAPSE   2

// MessageBox styles
#define MB_BUTTON_OK      1
#define MB_BUTTON_CANCEL  2
#define MB_BUTTON_USER    4


// #include "vn_uiDefines.inc"



///////////////////////////////////////////////////////////////////////////
/// Base Classes
///////////////////////////////////////////////////////////////////////////
class RscControlsGroup;
class RscPicture;

class vn_RscText
{
	idc = -1;
	type = 0;
	style = 0;
	shadow = 0;
	
	x = 0;
	y = 0;
	h = 0.037;
	w = 0.3;
	
	text = "";
	font = USEDFONT;
	SizeEx = TXT_S;
	
	colorShadow[] = {0,0,0,0.5};
	colorText[] = {1,1,1,1.0};
	colorBackground[] = {0,0,0,0};
	linespacing = 1;
	tooltipColorText[] = {1,1,1,1};
	tooltipColorBox[] = {1,1,1,1};
	tooltipColorShade[] = {0,0,0,0.65};
};


class vn_RscStructuredText
{
	idc = -1;
	type = 13;
	style = 0;
	
	x = UIW(2);
	y = UIH(2.5);
	w = UIW(15.5);
	h = UIH(0.9);
	
	colorText[] = {0.1,0.1,0.1,0.9};
	colorBackground[] = {0,0,0,0};
	shadow = 0;
	size = TXT_M;
	text = "";
	fade = 0;
	tooltip = "";
	class Attributes
	{
		align = "left";
		color = "#000000";
		colorLink = "#D09B43";
		font = USEDFONT;
		size = 0.8;
		shadow = 0;
	};
};
class vn_RscStructuredText_c: vn_RscStructuredText
{
	class Attributes
	{
		align = "center";
		color = "#000000";
		colorLink = "#D09B43";
		font = USEDFONT;
		size = 0.8;
		shadow = 0;
	};
};
class vn_RscStructuredText_r: vn_RscStructuredText
{
	class Attributes
	{
		align = "right";
		color = "#000000";
		colorLink = "#D09B43";
		font = USEDFONT;
		size = 0.8;
		shadow = 0;
	};
};
class vn_RscListNBox               
{
	idc = -1; // Control identification (without it, the control won't be displayed)
	type = CT_LISTNBOX; // Type 102
	style = ST_LEFT + LB_TEXTURES; // Style
	
	selectWithRMB = 1;	//Enable RightClick to select rows
	text = "";
	blinkingPeriod = 0; // Time in which control will fade out and back in. Use 0 to disable the effect.
	
	x = UIX_CL(1);
	y = UIY_CU(1);
	w = UIW(2);
	h = UIH(2);
	
	colorSelectBackground[] = {0.5,0.5,0.5,0.4}; // Selected item fill color
	colorSelectBackground2[] = {0.5,0.5,0.5,0.4}; // Selected item fill color (oscillates between this and colorSelectBackground)
	
	sizeEx = TXT_S; // Text size
	font = USEDFONT; // Font from CfgFontFamilies
	rowHeight = UIH(1); // Row height
	borderSize = 0;
	shadow = 0; // Shadow (0 - none, 1 - directional, color affected by colorShadow, 2 - black outline)
	
	colorText[] = {1,1,1,1}; // Text and frame color
	colorDisabled[] = {1,1,1,0.5}; // Disabled text color
	colorSelect[] = {1,1,1,1}; // Text selection color
	colorSelect2[] = {1,1,1,1}; // Text selection color (oscillates between this and colorSelect)
	colorShadow[] = {0,0,0,0.5}; // Text shadow color (used only when shadow is 1)
	
	colorPicture[] = {0.7,0.7,0.7,1};
	colorPictureSelected[] = {0.2,0.2,0.2,1};
	colorPictureDisabled[] = {0,0,0,1};
	
	tooltip = ""; // Tooltip text
	tooltipColorShade[] = {0,0,0,1}; // Tooltip background color
	tooltipColorText[] = {1,1,1,1}; // Tooltip text color
	tooltipColorBox[] = {1,1,1,1}; // Tooltip frame color
	
	columns[] = {0.0,0.2}; // Horizontal coordinates of columns (relative to list width, in range from 0 to 1)
	
	drawSideArrows = 0; // 1 to draw buttons linked by idcLeft and idcRight on both sides of selected line. They are resized to line height
	idcLeft = 1000; // Left button IDC
	idcRight = 1001; // Right button IDC
	
	period = 1; // Oscillation time between colorSelect/colorSelectBackground2 and colorSelect2/colorSelectBackground when selected
	
	maxHistoryDelay = 1; // Time since last keyboard type search to reset it
	
	soundSelect[] = {"\A3\ui_f\data\sound\RscListbox\soundSelect",0.09,1}; // Sound played when an item is selected
	
	// Scrollbar configuration (applied only when LB_TEXTURES style is used)
	class ListScrollBar
	{
		width = 0; // width of ListScrollBar
		height = 0; // height of ListScrollBar
		scrollSpeed = 0.01; // scrollSpeed of ListScrollBar
		
		arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa"; // Arrow
		arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa"; // Arrow when clicked on
		border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa"; // Slider background (stretched vertically)
		thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa"; // Dragging element (stretched vertically)
		
		color[] = {1,1,1,1}; // Scrollbar color
	};
	
	onCanDestroy = "";
	onDestroy = "";
	onSetFocus = "";
	onKillFocus = "";
	onKeyDown = "";
	onKeyUp = "";
	onMouseButtonDown = "";
	onMouseButtonUp = "";
	onMouseButtonClick = "";
	onMouseButtonDblClick = "";
	onMouseZChanged = "";
	onMouseMoving = "";
	onMouseHolding = "";
	
	onLBSelChanged = "systemChat str ['onLBSelChanged',_this]; false";
	onLBDblClick = "systemChat str ['onLBDblClick',_this]; false";
};

class vn_RscListBox
{
	//access = 0; // Control access (0 - ReadAndWrite, 1 - ReadAndCreate, 2 - ReadOnly, 3 - ReadOnlyVerified)
	idc = CT_LISTBOX; // Control identification (without it, the control won't be displayed)
	type = CT_LISTBOX; // Type is 5
	style = ST_LEFT + LB_TEXTURES; // Style
	//default = 0; // Control selected by default (only one within a display can be used)
	blinkingPeriod = 0; // Time in which control will fade out and back in. Use 0 to disable the effect.

	selectWithRMB = 1;	//Enable RightClick to select rows
	
	x = UIX_CL(1);
	y = UIY_CU(1);
	w = UIW(2);
	h = UIH(2);

	colorBackground[] = {0.2,0.2,0.2,1}; // Fill color
	colorSelectBackground[] = {1,0.5,0,1}; // Selected item fill color
	colorSelectBackground2[] = {0,0,0,1}; // Selected item fill color (oscillates between this and colorSelectBackground)

	sizeEx = TXT_S; // Text size
	font = USEDFONT; // Font from CfgFontFamilies
	shadow = 0; // Shadow (0 - none, 1 - directional, color affected by colorShadow, 2 - black outline)
	colorText[] = {1,1,1,1}; // Text and frame color
	colorDisabled[] = {1,1,1,0.5}; // Disabled text color
	colorSelect[] = {1,1,1,1}; // Text selection color
	colorSelect2[] = {1,1,1,1}; // Text selection color (oscillates between this and colorSelect)
	colorShadow[] = {0,0,0,0.5}; // Text shadow color (used only when shadow is 1)

	pictureColor[] = {1,0.5,0,1}; // Picture color
	pictureColorSelect[] = {1,1,1,1}; // Selected picture color
	pictureColorDisabled[] = {1,1,1,0.5}; // Disabled picture color

	tooltip = "CT_LISTBOX"; // Tooltip text
	tooltipColorShade[] = {0,0,0,1}; // Tooltip background color
	tooltipColorText[] = {1,1,1,1}; // Tooltip text color
	tooltipColorBox[] = {1,1,1,1}; // Tooltip frame color
	
	period = 1; // Oscillation time between colorSelect/colorSelectBackground2 and colorSelect2/colorSelectBackground when selected
	
	rowHeight = UIH(1); // Row height
	itemSpacing = 0; // Height of empty space between items
	maxHistoryDelay = 1; // Time since last keyboard type search to reset it
	canDrag = 0; // 1 (true) to allow item dragging
	
	soundSelect[] = {"\A3\ui_f\data\sound\RscListbox\soundSelect",0.09,1}; // Sound played when an item is selected
	
	// Scrollbar configuration (applied only when LB_TEXTURES style is used)
	class ListScrollBar //In older games this class is "ScrollBar"
	{
		width = 0; // width of ListScrollBar
		height = 0; // height of ListScrollBar
		scrollSpeed = 0.01; // scroll speed of ListScrollBar

		arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa"; // Arrow
		arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa"; // Arrow when clicked on
		border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa"; // Slider background (stretched vertically)
		thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa"; // Dragging element (stretched vertically)

		color[] = {1,1,1,1}; // Scrollbar color
	};

	//onCanDestroy = "systemChat str ['onCanDestroy',_this]; true";
	//onDestroy = "systemChat str ['onDestroy',_this]; false";
	//onSetFocus = "systemChat str ['onSetFocus',_this]; false";
	//onKillFocus = "systemChat str ['onKillFocus',_this]; false";
	//onKeyDown = "systemChat str ['onKeyDown',_this]; false";
	//onKeyUp = "systemChat str ['onKeyUp',_this]; false";
	//onMouseButtonDown = "systemChat str ['onMouseButtonDown',_this]; false";
	//onMouseButtonUp = "systemChat str ['onMouseButtonUp',_this]; false";
	//onMouseButtonClick = "systemChat str ['onMouseButtonClick',_this]; false";
	//onMouseButtonDblClick = "systemChat str ['onMouseButtonDblClick',_this]; false";
	//onMouseZChanged = "systemChat str ['onMouseZChanged',_this]; false";
	//onMouseMoving = "";
	//onMouseHolding = "";

	//onLBSelChanged = "systemChat str ['onLBSelChanged',_this]; false";
	//onLBDblClick = "systemChat str ['onLBDblClick',_this]; false";
	//onLBDrag = "systemChat str ['onLBDrag',_this]; false";
	//onLBDragging = "systemChat str ['onLBDragging',_this]; false";
	//onLBDrop = "systemChat str ['onLBDrop',_this]; false";
};

class vn_RscButton
{
	style = "0x02 + 0x10";
	deletable = 0;
	fade = 0;
	//access = 0;
	type = 1;
	text = "";
	colorText[] = {1,1,1,1};
	colorDisabled[] = {1,1,1,0};
	colorBackground[] = {0,0,0,0};
	colorBackgroundDisabled[] = {0,0,0,0};
	colorBackgroundActive[] = {0,0,0,0.2};
	colorFocused[] = {0,0,0,0};
	colorShadow[] = {0,0,0,0};
	colorBorder[] = {0,0,0,0};
	soundEnter[] = {"\A3\ui_f\data\sound\RscButton\soundEnter",0.09,1};
	soundPush[] = {"\A3\ui_f\data\sound\RscButton\soundPush",0.09,1};
	soundClick[] = {"\A3\ui_f\data\sound\RscButton\soundClick",0.09,1};
	soundEscape[] = {"\A3\ui_f\data\sound\RscButton\soundEscape",0.09,1};
	idc = -1;
	//style = 2;
	x = UIX_CL(1);
	y = UIY_CU(1);
	w = UIW(2);
	h = UIH(2);
	shadow = 0;
	font = USEDFONT;
	sizeEx = TXT_M;
	url = "";
	offsetX = 0;
	offsetY = 0;
	offsetPressedX = 0;
	offsetPressedY = 0;
	borderSize = 0;
};

class vn_RscButton_ImgSwitch
{
	default = 0;
	deletable = 0;
	fade = 0;

	type = CT_ACTIVETEXT;
	style = ST_PICTURE;

	idc = -1;
	x = UIX_CL(1);
	y = UIY_CU(1);
	w = UIW(2);
	h = UIH(2);

	font = USEDFONT;
	shadow = 0;
	sizeEx = TXT_M;
	url = "";

	text = "";		//Texture Normal
	textUp = "";	//Texture when mouser over
	
	tooltip = "";	//erm, a Tooltip? Those tiny boxes, that appear when you move your mouse over a console

	onButtonClick = "";
	onLoad = "";

	/////////////////// IMPORTANT! DON'T TOUCH OR OVERWRITE! /////////////////////////////////////////////
	onMouseEnter = "[1,(_this#0)] call vn_fnc_UI_UpdateImg;";	 //IMPORTANT! DON'T TOUCH OR OVERWRITE! //
	onMouseExit = "[0,(_this#0)] call vn_fnc_UI_UpdateImg;";	 //IMPORTANT! DON'T TOUCH OR OVERWRITE! //
	/////////////////// IMPORTANT! DON'T TOUCH OR OVERWRITE! /////////////////////////////////////////////

	color[] = {1,1,1,1};
	colorActive[] = {1,1,1,1};
	colorDisabled[] = {1,1,1,0.25};

	tooltipColorText[] = {1,1,1,1};
	tooltipColorBox[] = {1,1,1,1};
	tooltipColorShade[] = {0,0,0,0.65};

	soundClick[] = {"",0.1,1};
	soundEnter[] = {"",0.1,1};
	soundEscape[] = {"",0.1,1};
	soundPush[] = {"",0.1,1};
	
};
/* EXAMPLE:
class vn_MyFancyButtonWithChangingTexturesWhenIHoverWithTheMouseOverItCamelCaseIsNice: vn_RscButton_ImgSwitch
{
	idc = 123;
	x = UIX_CL(1);
	y = UIY_CU(1);
	w = UIW(2);
	h = UIH(2);
	
	tooltip = "I am a Button who exchanges images, when you move your mouse over me! WOOT WOOT!";
	
	text = "\vn\ui_f_vietnam\ui\taskroster\img\papersheetB.paa";
	textUp = "\vn\ui_f_vietnam\ui\taskroster\img\papersheetC.paa";
	
	onButtonClick = "systemchat str _this;";
};

*/

class vn_RscControlsGroup : RscControlsGroup
{
	idc = 0;
	type = 15;
	style = 16;
	enable = 1;
	show = 1;
	fade = 0;
	blinkingPeriod = 0;
	
	class VScrollbar
	{
		width = UI_GRID_W * 1.5;
		scrollSpeed = 0.03;
		arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";
		arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";
		border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";
		thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";
		color[] = {1,1,1,1};
		autoScrollEnabled = 0;
		autoScrollDelay = 0;
		autoScrollRewind = 0;
		autoScrollSpeed = 0;
	};
	class HScrollbar
	{
		height = UI_GRID_H * 1.5;
		scrollSpeed = 0.03;
		arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";
		arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";
		border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";
		thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";
		color[] = {1,1,1,1};
	};
};

class vn_RscControlsGroupNoScrollbarHV : vn_RscControlsGroup
{
	class VScrollbar
	{
		width = UI_GRID_W * 0;
		scrollSpeed = 0.02;
		arrowEmpty = "";
		arrowFull = "";
		border = "";
		thumb = "";
		color[] = {1,1,1,1};
		autoScrollEnabled = 0;
		autoScrollDelay = 0;
		autoScrollRewind = 0;
		autoScrollSpeed = 0;
	};
	class HScrollbar
	{
		height = UI_GRID_H * 0;
		scrollSpeed = 0.02;
		arrowEmpty = "";
		arrowFull = "";
		border = "";
		thumb = "";
		color[] = {1,1,1,1};
	};
};

class vn_RscControlsGroupNoScrollbarH : vn_RscControlsGroup
{
	//onMouseButtonDown	= "[1,_this] call {hint str _this;}";
	//onMouseButtonUp		= "[2,_this] call {hint str _this;}";
	
	class HScrollbar
	{
		height = UI_GRID_H * 0;
		scrollSpeed = 0.02;
		arrowEmpty = "";
		arrowFull = "";
		border = "";
		thumb = "";
		color[] = {1,1,1,1};
	};
};

class vn_RscControlsGroupNoScrollbarV : vn_RscControlsGroup
{
	class VScrollbar
	{
		width = UI_GRID_W * 0;
		scrollSpeed = 0.02;
		arrowEmpty = "";
		arrowFull = "";
		border = "";
		thumb = "";
		color[] = {1,1,1,1};
		autoScrollEnabled = 0;
		autoScrollDelay = 0;
		autoScrollRewind = 0;
		autoScrollSpeed = 0;
	};
};

class vn_RscCombo
{
	idc = -1;
	x = UIX_CL(1);
	y = UIY_CU(1);
	w = UIW(2);
	h = UIH(2);
	
	type = CT_COMBO;
	//style = ST_LEFT + LB_TEXTURES; // Style
	style = ST_LEFT + LB_TEXTURES; // Style
	blinkingPeriod = 0; // Time in which control will fade out and back in. Use 0 to disable the effect.
	
	
	colorBackground[] = {0.1,0.1,0.1,0.0}; // Fill color
	colorSelectBackground[] = {0.1,0.1,0.1,0.1}; // Selected item fill color
	
	tooltip = ""; // Tooltip text
	sizeEx =  TXT_M;
	font = USEDFONT;
	shadow = 0;
	
	colorText[] = {0,0,0,0.75}; // Text and frame color
	colorDisabled[] = {1,1,1,0.5}; // Disabled text color
	colorSelect[] = {0,0,0,1}; // Text selection color
	
	pictureColor[] = {0.0,0.5,0.1,1}; // Picture color
	pictureColorSelect[] = {0.0,0.5,0.1,1}; // Selected picture color
	pictureColorDisabled[] = {1,1,1,0.5}; // Disabled picture color
	
	tooltipColorShade[] = {0,0,0,1}; // Tooltip background color
	tooltipColorText[] = {1,1,1,1}; // Tooltip text color
	tooltipColorBox[] = {1,1,1,1}; // Tooltip frame color
	
	arrowEmpty = "\A3\ui_f\data\GUI\RscCommon\rsccombo\arrow_combo_ca.paa"; // Expand arrow									//ToDo?
	arrowFull = "\A3\ui_f\data\GUI\RscCommon\rsccombo\arrow_combo_active_ca.paa"; // Collapse arrow							//ToDo?
	
	wholeHeight = PXH(10); // Maximum height of expanded box (including the control height)
	maxHistoryDelay = 1; // Time since last keyboard type search to reset it
	
	soundExpand[] = {"\A3\ui_f\data\sound\RscCombo\soundExpand",0.1,1}; // Sound played when the list is expanded			//ToDo?
	soundCollapse[] = {"\A3\ui_f\data\sound\RscCombo\soundCollapse",0.1,1}; // Sound played when the list is collapsed		//ToDo?
	soundSelect[] = {"\A3\ui_f\data\sound\RscCombo\soundSelect",0.1,1}; // Sound played when an item is selected			//ToDo?
	
	// Scrollbar configuration (applied only when LB_TEXTURES style is used)
	class ComboScrollBar
	{
		width = 0; // width of ComboScrollBar
		height = 0; // height of ComboScrollBar
		scrollSpeed = 0.01; // scrollSpeed of ComboScrollBar
		
		arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa"; // Arrow												//ToDo?
		arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa"; // Arrow when clicked on								//ToDo?
		border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa"; // Slider background (stretched vertically)					//ToDo?
		thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa"; // Dragging element (stretched vertically)						//ToDo?

		color[] = {1,1,1,1}; // Scrollbar color
	};
	
	
	onCanDestroy = "";
	onDestroy = "";
	onSetFocus = "";
	onKillFocus = "";
	onKeyDown = "";
	onKeyUp = "";
	onMouseButtonDown = "";
	onMouseButtonUp = "";
	onMouseButtonClick = "";
	onMouseButtonDblClick = "";
	onMouseZChanged = "";
	onMouseMoving = "";
	onMouseHolding = "";
	
	onLBSelChanged = "systemChat str ['CHANGE ME: onLBSelChanged',_this]; false";
};

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Wheelmenu - Baseclass
class vn_wheelMenu_base : RscPicture
{
	idc = -1;
	style = "0x30";
	
	x = PXX_CL(18);
	y = PXY_CU(18);
	w = PXW(36);
	h = PXH(36);
	
	
	text = "";
	font= "RobotoCondensed";
	sizeEx = "0.02 * safezoneH";
	colorText[]={0,0,0,1};
	colorBackground[] = {1,1,1,0.6};
};
