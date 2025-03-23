/*
    File: fn_missions_zones_getList.sqf
    Author: Savage Game Design
    Date: 2024-03-24
    Last Update: 2024-04-04
    Public: No

    Description:
        Send missions zone data to requesting client.

    Parameter(s):
        N/A

    Returns:
        Nothing

    Example(s):
        [] remoteExecCall ["vgm_s_fnc_missions_zones_remoteExec_getList", 2];
 */

#define MISSIONS_CHANGE_INTERVAL 300

private _fnc_getModifiers = {
    private _count = 1 + random 2;

    private _modifiers = [];
    for "_i" from 1 to _count do {
        _modifiers pushBack ["test" + str _i, random 1];
    };

    _modifiers // return
};

private _seed = floor (time / MISSIONS_CHANGE_INTERVAL);
private _seedChangeIn = MISSIONS_CHANGE_INTERVAL - (time mod MISSIONS_CHANGE_INTERVAL);

// generate target boxes modfiers
if (_seed != vgm_missions_zones_lastSeed) then {

    {
        vgm_missions_zones_targetBoxesModifiers set [_x, call _fnc_getModifiers];
    } forEach vgm_missions_zones_targetBoxes;

    vgm_missions_zones_lastSeed = _seed;
};

[_seedChangeIn, vgm_missions_zones_targetBoxesModifiers] remoteExecCall ["vgm_c_fnc_missions_zones_remoteExec_receiveList", remoteExecutedOwner];
