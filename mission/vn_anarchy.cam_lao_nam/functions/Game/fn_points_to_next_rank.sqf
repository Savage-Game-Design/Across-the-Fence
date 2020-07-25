/*
  Author: Aaron Clark

  Description:
	converts rank to icon

  Example Usage:
		call vn_an_fnc_points_to_next_rank

  Returns:
	0 : ARRAY -	0 : STRING - path to rank icon
	1 : STRING - rank text name

  Parameter(s):
*/
(([player] call vn_an_fnc_unit_next_rank) select 2) - (player getVariable ["vn_an_rank",0])
