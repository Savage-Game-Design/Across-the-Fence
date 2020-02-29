/*
  Author: Aaron Clark

  Description:
	changes players rank and displays info

  Example Usage:
	[_rank] call vn_mf_fnc_player_rank_up;

  Returns:
	NOTHING

  Parameter(s):
*/
params ["_name","_rank","_object"];
private _last_rank = missionNamespace getVariable ["vn_mf_last_rank",0];
private _last_rank_text = missionNamespace getVariable ["vn_mf_last_rank_text","Private"];
private _diff = (_rank-_last_rank);

([player] call vn_mf_fnc_unit_to_rank) params ["_icon", "_rank_text", "_pointsneeded"];

// check if rank has changed
if (_last_rank_text isEqualTo _rank_text) then
{
	// same rank
	"rank" cutText [format["<t font='VeteranTypewriter' color='#FFFFFF' align='center' size='2'>+ %1 %2</t>",_diff,localize "STR_vn_mf_rankpoint_short"], "PLAIN DOWN", -1, true, true];
} else {
	// rank changed
	"rank" cutText [format["<img size='5' image='%1'/><t font='VeteranTypewriter' color='#FFD700' size='5'>%5</t><br/><t font='VeteranTypewriter' color='#FFFFFF' align='center' size='2'>+ %3 %4</t><t font='VeteranTypewriter' align='right'>Rank: %2</t>",_icon,_rank_text,_diff,localize "STR_vn_mf_rankpoint_short",localize "STR_vn_mf_levelup"], "PLAIN DOWN", -1, true, true];
	// store last rank
	missionNamespace setVariable ["vn_mf_last_rank_text",_rank_text];
};
