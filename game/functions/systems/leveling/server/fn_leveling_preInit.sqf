/*
    File: fn_preInit.sqf
    Author: veteran29
    Date: 2023-05-30
    Last Update: 2023-06-01
    Public: No

    Description:
        Client preInit function for leveling system.

    Parameter(s):
        N/A

    Returns:
        Nothing
 */

if (!isServer) exitWith {};

["vgm_leveling_init", {
    params ["_player"];

    private _levelingData = _player call vgm_s_fnc_leveling_dataGetCached;
    ["vgm_leveling_initClient", _levelingData, _player] call para_g_fnc_event_triggerTargets;
}] call para_g_fnc_event_subscribe;
