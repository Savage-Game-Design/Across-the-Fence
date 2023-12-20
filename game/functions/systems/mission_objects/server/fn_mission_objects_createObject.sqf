/*
    File: fn_createObject.sqf
    Author: Savage Game Design
    Date: 2023-12-18
    Last Update: 2023-12-20
    Public: Yes

    Description:
        Create virtual object in the mission, objects will be spawned locally by clients upon mission start.

    Parameter(s):
        _mission - Mission Id or Mission to create the object in [HASHMAP, NUMBER]
        _objectData - Array with object properties [ARRAY]
            _class      - Object class [STRING]
            _position   - Object position in AGL format [ARRAY]
            _dir        - Object direction [NUMBER, defaults to 0]
            _fnc_init   - Code to be executed upon object creation [CODE]
            _initParams - Parameters passed additionaly to the init code [ANYTHING]

    Returns:
        Object ID [STRING]

    Example(s):
        [
            _mission,
            ["vn_b_ammobox_01", ASLToAGL getPosASL player]
        ] call vgm_s_fnc_mission_objects_createObject
 */

params ["_mission", "_objectData"];
_objectData params ["_class", "_position", ["_dir", 0], ["_fnc_init", {}], ["_initParams", []]];

if (_mission isEqualType 0) then {
    _mission = [_mission] call vgm_s_fnc_missions_getById;
};

private _missionObjects = vgm_s_mission_objects_data getOrDefault [(_mission get "public" get "id"), createHashMap, true];

_objectData = [_class, _position, _dir, _fnc_init, _initParams];
private _id = hashValue _objectData;
_missionObjects set [_id, _objectData];

_id // return
