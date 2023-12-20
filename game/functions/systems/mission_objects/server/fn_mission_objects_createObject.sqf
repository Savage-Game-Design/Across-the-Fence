/*
    File: fn_createObject.sqf
    Author: Savage Game Design
    Date: 2023-12-18
    Last Update: 2023-12-20
    Public: No

    Description:
        No description added yet.

    Parameter(s):
        N/A

    Returns:
        Something [BOOL]

    Example(s):
        [_mission, ["vn_b_ammobox_01", ASLToAGL getPosASL player]] call vgm_s_fnc_mission_objects_createObject
 */

params ["_mission", "_objectData"];
_objectData params ["_class", "_position", ["_dir", 0], ["_fnc_init", {}], ["_initParams", []]];

private _missionObjects = vgm_s_mission_objects_data getOrDefault [(_mission get "public" get "id"), createHashMap, true];

_objectData = [_class, _position, _dir, _fnc_init, _initParams];
private _id = hashValue _objectData;
_missionObjects set [_id, _objectData];

_id // return
