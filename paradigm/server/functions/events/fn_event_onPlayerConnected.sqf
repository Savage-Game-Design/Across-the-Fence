/*
    File: fn_event_onPlayerConnected.sqf
    Author:
    Date: 2022-11-27
    Last Update: 2022-11-27
    Public: No

    Description:
        No description added yet.

    Parameter(s):
        N/A

    Returns:
        Something [BOOL]

    Example(s):
        [parameter] call vgm_X_fnc_component_myFunction
 */

params ["_id", "_uid", "_name", "_jip", "_owner"];

private _machineIdReferences = localNamespace getVariable "para_event_machineIdReferences";
private _machineIdReservedIndexes = localNamespace getVariable "para_event_machineIdToReservedClientArrayIndex";

// Find the lowest index we can use.
private _reservedIndexes = values _machineIdReservedIndexes;
_reservedIndexes sort true;
private _indexToReserve = 0;
{
    if !(_x isEqualTo _indexToReserve) exitWith {};
    _indexToReserve = _indexToReserve + 1;
} forEach _reservedIndexes;

_machineIdReferences set [_owner, [_owner]];
_machineIdReservedIndexes set [_owner, _indexToReserve];
