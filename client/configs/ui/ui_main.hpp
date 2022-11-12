//included by "..\interface.hpp"

////////////////////////

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

////////////////////////

//Base (most important) stuff
#include "ui_def_base.inc"
#include "ui_def_ctrl_base.hpp"

#include "ui_hud_shared.hpp"

#include "building_menu\menu.hpp"
#include "voting_menu\menu.hpp"

// Options Menu
#include "options_menu\menu.hpp"
#include "options_menu\config.hpp"

// Keybindings menu
#include "keybindings_menu\para_RscDisplayKeybindingsMenu.hpp"

//Infopanel (rewards, XP/RP, etc)
#include "infopanel\infopanel_quickShow.hpp"

// Notification Overlay
#include "notification_overlay\config.hpp"
#include "notification_overlay\controls.hpp"

// Survival cards
#include "survival_hints\controls.hpp"

// Bug report form
#include "bug_report\menu.hpp"

// Welcome screen
#include "welcome_screen\dialog.hpp"

//We provide a base class if running in-mission, otherwise we declare RscTitles.
#ifdef PARA_MISSION	
class ParadigmRscTitles {
	#include "RscTitles.hpp"
};
#else
class RscTitles {
	#include "RscTitles.hpp"
};
#endif

// Dynamic Groups
#include "dynamicGroups\ui_dg_def_base.hpp"
#include "dynamicGroups\ui_dg_def_idc.hpp"
#include "dynamicGroups\main.hpp" 
