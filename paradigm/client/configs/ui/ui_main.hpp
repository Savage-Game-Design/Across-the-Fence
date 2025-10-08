//included by "..\interface.hpp"

////////////////////////

////////////////////////

//Base (most important) stuff
#include "dynamicGroups\ui_dg_def_base.hpp"
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
#include "dynamicGroups\ui_dg_def_idc.hpp"
#include "dynamicGroups\main.hpp"
