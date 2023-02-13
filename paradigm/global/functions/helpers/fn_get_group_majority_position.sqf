/*
    File: fn_get_group_majority_position.sqf
    Author: Savage Game Design, Xorberax
    Public: Yes

    Description:
        Gets the average position of the majority of a group while ignoring lonewolves.

    Parameter(s):
        _group - The group to get the average position of [GROUP]
    Returns:
        Average position of group [Position2D]

    Example(s):
        _groupPosition = [group player] call para_g_fnc_get_group_majority_position;
*/

#define LONEWOLF_DISTANCE 100

params [
    ["_group", grpNull, [grpNull]]
];

if (isNull _group) exitWith {
    ["ERROR", format ["Expected _group to be defined. Received _group: %1", _group]] call para_g_fnc_log;
};

private _unitsInGroup = units _group;
private _memberCountToMembers = createHashMap;
{
    private _nearGroupMembers = (_x nearEntities ["AllVehicles", LONEWOLF_DISTANCE]) select { group _x == _group };
    _memberCountToMembers set [count _nearGroupMembers, _nearGroupMembers];
} forEach _unitsInGroup;


private _majorityUnits = _memberCountToMembers get (selectMax (keys _memberCountToMembers));
private _positionSum = [0, 0];
private _unitCountSum = 0;
{
    private _unit = _x;
    private _unitPositionASL = getPosASL _x;
    _positionSum = _positionSum vectorAdd [_unitPositionASL#0, _unitPositionASL#1];
    _unitCountSum = _unitCountSum + 1;
} forEach _majorityUnits;

_positionSum vectorMultiply (1 / _unitCountSum);
