/*
    File: fn_get_group_majority_position.sqf
    Author: Savage Game Design, Xorberax
    Public: Yes

    Description:
        Gets the average position of the majority of a group while ignoring lonewolves.

    Parameter(s):
        _group - The group to get the average position of [GROUP]
        _groupMemberPredicate - The condition that must be satisfied to count as a nearby group member. [CODE]. Optional.
    Returns:
        Average position of group or [0, 0, 0] if undetermined [PositionAGL]

    Example(s):
        _groupMajorityPosition = [group player] call para_g_fnc_get_group_majority_position;
        _groupMajorityPositionOfAliveMembers = [group player, { alive _this }] call para_g_fnc_get_group_majority_position;
*/

#define LONEWOLF_DISTANCE 100

params [
    ["_group", grpNull, [grpNull]],
    ["_groupMemberPredicate", { true }, [{}]],
    ["_groupMemberPredicateArguments", [], [[]]]
];

if (isNull _group) exitWith {
    ["ERROR", format ["Expected _group to be defined. Received _group: %1", _group]] call para_g_fnc_log;
};

private _unitsInGroup = units _group;
private _largestUnitGrouping = [];
private _totalUnitsInLargestUnitGrouping = 0;
{
    private _unit = _x;
    private _nearbyGroupMembers = (_unitsInGroup inAreaArray  [getPos _unit, LONEWOLF_DISTANCE, LONEWOLF_DISTANCE]) select { [_x, _groupMemberPredicateArguments] call _groupMemberPredicate };
    private _totalNearbyGroupMembers = count _nearbyGroupMembers;
    if (_totalNearbyGroupMembers > _totalUnitsInLargestUnitGrouping) then {
        _largestUnitGrouping = _nearbyGroupMembers;
        _totalUnitsInLargestUnitGrouping = _totalNearbyGroupMembers;
    };
} forEach _unitsInGroup;

if (_totalUnitsInLargestUnitGrouping == 0) exitWith {
    [0, 0, 0];
};

private _positionSum = [0, 0, 0];
{
    private _unit = _x;
    private _unitPosition = getPos _unit;
    _positionSum = _positionSum vectorAdd [_unitPosition#0, _unitPosition#1];
} forEach _largestUnitGrouping;

_positionSum vectorMultiply (1 / _totalUnitsInLargestUnitGrouping);
