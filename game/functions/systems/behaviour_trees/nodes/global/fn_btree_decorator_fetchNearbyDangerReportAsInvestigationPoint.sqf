/*
    File: fn_btree_decorator_fetchNearbyDangerReportAsInvestigationPoint.sqf
    Author: Savage Game Design
    Date: 2024-02-02
    Last Update: 2025-05-14
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
}];

_decorator set ["onTreeAssigned", {
    params ["_group", "_blackboard"];

    private _eventGroup = _group getVariable ["vgm_g_missionId", vgm_g_dangerReport_defaultLocEventGroup];

    private _locEventHandlers = [
        _eventGroup,
        _group,
        [ "player_explosion", "player_gunshots_aggregate", "player_flare" ],
        [ _group, _blackboard ],
        {
            params ["_pos", "_type", "_listener", "_eventData", "_args"];
            _args params ["_group", "_blackboard"];

            _blackboard set ["investigationPoint", ASLtoAGL _pos];
        }
    ] call vgm_g_fnc_locEvents_onNearbyEvent;

    _group setVariable ["vgm_l_btree_dangerReportHandlers", _locEventHandlers];
}];

_decorator set ["onTreeUnassigned", {
    params ["_group", "_blackboard"];

    [_group getVariable "vgm_l_btree_dangerReportHandlers"] call vgm_g_fnc_locEvents_removeHandlers;
}];


_decorator
