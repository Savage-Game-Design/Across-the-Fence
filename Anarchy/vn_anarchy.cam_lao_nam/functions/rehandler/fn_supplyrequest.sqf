/*
  Author: Aaron Clark

  Description:
	moves player to another camp or location

  Example Usage:
	not called directly

  Passed: _player : OBJECT - player reference

  Returns:
	Nothing

  Parameter(s):
*/
params ["_supply","_officer"];

// make sure player is witin 20m of a supply officer
if !([_officer] inAreaArray [getPos _player, 20, 20, 0, false, 20] isEqualTo []) then
{
	private _spawn_pos = getMarkerPos "supply_drop_1";
	private _nearby = _spawn_pos nearSupplies 10;
	if (count _nearby <= 5) then {
		private _drops = getArray(missionConfigFile >> "gamemode" >> "supplydrops" >> _supply);
		_drops params [["_drop_name","STR_vn_mf_supplies"],["_drop_arr",[]]];
		if !(_drop_arr isEqualTo []) then
		{
			private _object = createVehicle [selectRandom _drop_arr, _spawn_pos, [], 1, "NONE"];
			[	[_drop_name],
				{
					["TaskSucceeded",["",format[localize "STR_vn_mf_dropincomming", localize (_this select 0)]]] call BIS_fnc_showNotification
				}
			] remoteExecCall ["call",_player];
		};

	} else {
		{["TaskFailed",["",localize "STR_vn_mf_supplydroponstandby"]] call BIS_fnc_showNotification} remoteExecCall ["call",_player];
	};
};
