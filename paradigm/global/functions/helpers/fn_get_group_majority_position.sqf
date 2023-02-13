/*
    File: fn_get_group_majority_position.sqf
    Author: Savage Game Design, Xorberax
    Public: Yes

    Description:
        Gets the average position of the majority of a group while ignoring lonewolves.

    Parameter(s):
        _group - The group to get the average position of [GROUP]
        _groupMemberPredicate - The condition that must be satisfied to count as a nearby group member [CODE]. Optional.
    Returns:
        Average position of group or [0, 0, 0] if undetermined [PositionAGL]

    Example(s):
        _groupMajorityPosition = [group player] call para_g_fnc_get_group_majority_position;
        _groupMajorityPositionOfAliveMembers = [group player, { alive _this }] call para_g_fnc_get_group_majority_position;
*/

#define LONEWOLF_DISTANCE 100

params [
    ["_group", grpNull, [grpNull]],
    ["_groupMemberPredicate", { true }, [{}]]
];

if (isNull _group) exitWith {
    ["ERROR", format ["Expected _group to be defined. Received _group: %1", _group]] call para_g_fnc_log;
};

private _unitsInGroup = units _group;
private _memberCountToMembers = createHashMap;
{
    private _unit = _x;
    private _nearGroupMembers = (_unit nearEntities ["AllVehicles", LONEWOLF_DISTANCE]) select { group _x == _group && _x call _groupMemberPredicate};
    if (count (_nearGroupMembers select { _x != _unit }) > 0) then {
        _memberCountToMembers set [count _nearGroupMembers, _nearGroupMembers];
    };
} forEach _unitsInGroup;

if (count _memberCountToMembers == 0) exitWith {
    [0, 0, 0];
};

private _majorityUnits = _memberCountToMembers get (selectMax (keys _memberCountToMembers));
private _positionSum = [0, 0];
private _unitCountSum = 0;
{
    private _unit = _x;
    private _unitPosition = getPos _unit;
    _positionSum = _positionSum vectorAdd [_unitPosition#0, _unitPosition#1, 0];
    _unitCountSum = _unitCountSum + 1;
} forEach _majorityUnits;

_positionSum vectorMultiply (1 / _unitCountSum);
