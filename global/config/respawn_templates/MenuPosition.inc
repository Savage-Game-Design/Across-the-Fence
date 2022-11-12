/*
	Can be included in a mission file to enable Paradigm's respawn menu as an option.
	This respawn menu is a *replacement* for vanilla MenuPosition - some functionality may differ.
*/

// Class used in respawnTemplates entry
class MenuPosition
{
	// Function or script executed upon death.
	onPlayerKilled = "para_g_fnc_respawn_menu";
	// Function or script executed upon respawn.
	onPlayerRespawn = "para_g_fnc_respawn_menu";
	respawnTypes[] = {2,3};
	// 1 to respawn player when he joins the game. Available only for INSTANT and BASE respawn types
	// Can be overridden by description.ext attribute of the same name
	respawnOnStart = 0;
};