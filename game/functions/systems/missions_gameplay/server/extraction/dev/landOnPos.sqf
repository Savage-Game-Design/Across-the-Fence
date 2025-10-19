/*
_lzPosition = getPosATL player;
// _lzPosition = vgm_extraction_debug_lastPos;
[_lzPosition] call compileScript ["functions\systems\missions_gameplay\server\extraction\dev\landOnPos.sqf"];
*/

["VGM_S_fnc_missions_gameplay_extraction_scriptedLand"] call BIS_fnc_recompile;

params ["_lzPosition"];

deleteVehicleCrew vgm_extraction_debug_heli;
deleteVehicle vgm_extraction_debug_heli;
deleteVehicle vgm_extraction_debug_helipad;

_safeLzPositionATL = _lzPosition;
_safeLzPositionATL set [2, 0];

_class = "vn_b_air_uh1d_02_07";
private _helicopter = [_class] call vgm_s_fnc_missions_gameplay_createCrewedHelicopter;
private _group = group _helicopter;
private _distance = 210;
private _originPos = markerPos "vgm_shared_hub";

private _helipad = createVehicle ["Land_HelipadCircle_F", [0,0,0], [], 0, "NONE"];
_helipad setPosATL _safeLzPositionATL;

private _spawnPos = _lzPosition getPos [_distance, _lzPosition getDir _originPos];
_spawnPos set [2, 50];
_helicopter setPosATL _spawnPos;

private _wpPos = _lzPosition getPos [100 min _distance, _lzPosition getDir _originPos];

private _landWp = _group addWaypoint [_wpPos, 0];
_helicopter setVariable ["vgm_mission_extraction_helipad", _helipad];
_landWp setWaypointStatements ["true", toString {
	if (!isServer) exitWith {};
	[vehicle this] call vgm_s_fnc_missions_gameplay_extraction_scriptedLand;
}];

vgm_extraction_debug_lastPos = _lzPosition;
vgm_extraction_debug_heli = _helicopter;
vgm_extraction_debug_helipad = _helipad;

_helicopter
