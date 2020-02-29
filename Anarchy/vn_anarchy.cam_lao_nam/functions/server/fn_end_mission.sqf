/*
  Author: Aaron Clark

  Description:
	End mission event

  Example Usage:
	call vn_mf_fnc_end_mission

  Returns:
	OBJECT

  Parameter(s):
    NA
*/
["CLEAR"] call vn_mf_fnc_hive;
["SAVE"] call vn_mf_fnc_hive;

'EveryoneWon' call BIS_fnc_endMissionServer;

diag_log "Game ended!";
