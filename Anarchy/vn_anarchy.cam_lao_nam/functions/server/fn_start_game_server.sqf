"VN: Server Init started" call BIS_fnc_log;

if (isNil "vn_an_gamestarting") then
{
	vn_an_gamestarting = true;

	private _gamemode_config = (missionConfigFile >> "gamemode");

	// setup game optimizations server side
	setviewdistance (getNumber(_gamemode_config >> "performance" >> "setviewdistance"));
	setobjectviewdistance (getArray(_gamemode_config >> "performance" >> "setobjectviewdistance")); // this also controls ai target range
	setterraingrid (getNumber(_gamemode_config >> "performance" >> "setterraingrid"));
	(getArray(_gamemode_config >> "performance" >> "enableenvironment")) params ["_ambientlife","_ambientsound"];
	enableenvironment [[false,true] select _ambientlife,[false,true] select _ambientsound];

	// start scheduler
	vn_an_schedulerJobs = [];
	0 call vn_an_fnc_scheduler_start;
	0 spawn vn_an_fnc_scheduler_monitor;







	//Example unit types. Should be made more dynamic as the gamemode progresses.
	unit_civilian = "uns_civilian1";
	units_vc_basic = ["vn_o_men_vc_local_03","vn_o_men_vc_local_03","vn_o_men_vc_local_12"];
	units_vc_officer = ["vn_o_men_vc_local_01"];
	units_vc_smg = ["vn_o_men_vc_local_06","vn_o_men_vc_local_05","vn_o_men_vc_local_04"];
	units_vc_marksman = ["vn_o_men_vc_local_10"];
	units_vc_medic = ["vn_o_men_vc_local_08"];
	units_vc_grenadier = ["vn_o_men_vc_local_07"];
	units_vc_at = ["vn_o_men_vc_local_14"];
	units_vc_mg = ["vn_o_men_vc_local_11"];

	units_sog_teamleader = ["vn_b_men_sog_01", "vn_b_men_sog_13"];
	units_sog_rto = ["vn_b_men_sog_02", "vn_b_men_sog_14"];
	units_sog_medic = ["vn_b_men_sog_03", "vn_b_men_sog_15"];
	units_sog_scout = ["vn_b_men_sog_09", "vn_b_men_sog_19"];
	units_sog_grenadier = ["vn_b_men_sog_07", "vn_b_men_sog_11"];
	units_sog_machinegunner = ["vn_b_men_sog_06", "vn_b_men_sog_16", "vn_b_men_sog_18"];

	vehicles_nva_helis = ["uns_Mi8T_VPAF"];
	vehicles_nva_planes = ["uns_an2_cas"];

	jungleTraps = [
	    "uns_tripwire_punj1",
	    "uns_tripwire_punj2",
	    "uns_tripwire_punj3",
	    "uns_tripwire_punj4"
	];

	enemyAPMines = [
	    "uns_mine_md82"
	];

	enemyATMines = [
	    "uns_mine_tm57"
	];

	friendlyAPMines = [
	    "uns_mine_m14",
	    "uns_mine_m16"
	];

	friendlyATMines = [
	    "uns_mine_t59"
	];

	incendiaryMines = [
	    "uns_mine_xm54"
	];

	// start patrol subsystem
	[] call vn_an_fnc_patrol_subsystem_init;

	

	// flag server as ready
	missionNamespace setVariable ["vn_an_server_ready", true, true];
};

"VN: Server Init finished" call BIS_fnc_log;
