//--- Key down actions:
class vn_mf_keydown_escape_action
{
	defaultKey = 1;
	shift = "false";
	ctrl = "false";
	alt = "false";
	function = "para_c_fnc_abort_building";
	down = 1;
	displayName = "";
	access = 0;
};
class vn_mf_keydown_enable_selector
{
	defaultKey = 7;
	shift = "false";
	ctrl = "false";
	alt = "false";
	function = "vn_mf_fnc_enable_selector";
	down = 1;
	displayName = $STR_vn_mf_keybindings_selector;
	access = 1;
};
class para_vote_1
{
	defaultKey = 59;
	shift = "false";
	ctrl = "false";
	alt = "false";
	function = "para_c_fnc_vote_1";
	down = 1;
	displayName = "Vote for Option #1";
	access = 1;
};
class para_vote_2
{
	defaultKey = 60;
	shift = "false";
	ctrl = "false";
	alt = "false";
	function = "para_c_fnc_vote_2";
	down = 1;
	displayName = "Vote for Option #2";
	access = 1;
};
class para_vote_3
{
	defaultKey = 61;
	shift = "false";
	ctrl = "false";
	alt = "false";
	function = "para_c_fnc_openVoteMenu";
	down = 1;
	displayName = "Open Voting Menu";
	access = 1;
};

//--- Key up actions:
class vn_mf_debug_monitor_action
{
	defaultKey = 41;
	shift = "false";
	ctrl = "false";
	alt = "false";
	function = "vn_mf_fnc_enable_debug_monitor";
	down = 0;
	displayName = $STR_vn_mf_keybindings_debug_monitor;
	access = 1;
};
class vn_mf_task_roster_action
{
	defaultKey = 35;
	shift = "false";
	ctrl = "false";
	alt = "false";
	function = "vn_mf_fnc_enable_task_roster";
	down = 0;
	displayName = $STR_vn_mf_keybindings_task_roster;
	access = 1;
};
class vn_mf_build_mode_action_up
{
	defaultKey = 49;
	shift = "false";
	ctrl = "false";
	alt = "false";
	function = "para_c_fnc_toggle_buildmode";
	down = 0;
	displayName = $STR_vn_mf_keybindings_build_mode;
	access = 1;
};
