/*
    File: fn_btree_decorator_fetchNearbyDangerReportAsInvestigationPoint.sqf
    Author: Savage Game Design
    Date: 2024-02-02
    Last Update: 2025-08-18
    Public: Yes

    Description:
        Decorator node (see basic decorator for more info).

        Listens for nearby danger reports, and sets them as the current investigation point.

        Fails if there's no nearby danger reports or a current investigation point.

    Parameter(s):
        _params - Any parameters accepted by the node. [HASHMAP]
        _children - Node's children (should always be exactly 1 node) [ARRAY]

    Returns:
        Decorator behaviour tree node [HASHMAP]

    Example(s):
        [] call vgm_g_fnc_btree_decorator_fetchNearbyDangerReportAsInvestigationPoint;
 */

params ["_params", "_children"];

private _decorator = _this call vgm_g_fnc_btree_decorator_basic;

_decorator set ["name", "Fetch nearby danger report as investigation point"];
_decorator set ["condition", {
    params ["_node", "_state"];

    "investigationPoint" in _extern_blackboard
}];

_decorator set ["onExit", {
    params ["_node", "_state", "_result"];
    // This isn't ideal to have in this decorator - it's a bit of a side effect.
    // Ideally should be in another decorator.
    _extern_blackboard deleteAt "investigationPoint";
    _extern_blackboard deleteAt "investigationCenter";
}];

_decorator set ["onTreeAssigned", {
    params ["_group", "_blackboard"];

    private _eventGroup = _group getVariable ["vgm_g_missionId", vgm_g_dangerReport_defaultLocEventGroup];

    private _locEventHandlers = [
        _eventGroup,
        _group,
        [ "player_explosion", "player_gunshots_aggregate", "player_flare", "player_distraction", "player_voice", "ai_gunshots" ],
        [ _group, _blackboard ],
        {
            params ["_pos", "_type", "_listener", "_eventData", "_args"];
            _args params ["_group", "_blackboard"];

            // Skip own group's gunfire
            if (_type == "ai_gunshots" && {_eventData isEqualTo _group}) exitWith {};

            // Store original sound position as patrol center
            private _aglPos = ASLtoAGL _pos;
            _blackboard set ["investigationCenter", _aglPos];

            // Offset scales with distance: close = precise, far = vague
            // <25m: 5-10m offset, 25-75m: 10-25m, 75-150m: 20-45m, >150m: 35-60m
            private _hearDist = leader _group distance2D _aglPos;
            private _dist = switch (true) do {
                case (_hearDist < 25):  { 5 + random 5 };
                case (_hearDist < 75):  { 10 + random 15 };
                case (_hearDist < 150): { 20 + random 25 };
                default                 { 35 + random 25 };
            };
            private _dir = random 360;
            _blackboard set ["investigationPoint", [(_aglPos#0) + _dist * sin _dir, (_aglPos#1) + _dist * cos _dir, _aglPos#2]];
        }
    ] call vgm_g_fnc_locEvents_onNearbyEvent;

    _group setVariable ["vgm_l_btree_dangerReportHandlers", _locEventHandlers];
}];

_decorator set ["onTreeUnassigned", {
    params ["_group", "_blackboard"];

    [_group getVariable "vgm_l_btree_dangerReportHandlers"] call vgm_g_fnc_locEvents_removeHandlers;
}];


_decorator
