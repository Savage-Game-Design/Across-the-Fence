class players
{
	publicvars[] = {"vn_mf_db_player_group","vn_mf_db_friends"};
	blacklisted[] = {};
};
class buildables
{
	publicvars[] = {"para_db_buildstate","para_db_buildclass","para_db_features"};
	blacklisted[] = {};
}
class tracking
{
	class vn_mf_db_hunger
	{
		script = "vn_mf_fnc_ui_update";
	};
	class vn_mf_db_thirst : vn_mf_db_hunger {};
	class vn_mf_db_rank
	{
		script = "vn_mf_fnc_player_rank_up";
	};
	class vn_mf_db_respawners
	{
		script = "vn_mf_fnc_respawn_change";
	};
};
