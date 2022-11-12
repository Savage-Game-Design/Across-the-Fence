/*
    File: fn_loadbal_suggest_host.sqf
    Author:  Savage Game Design
    Public: No

    Description:
		Returns a headless client if possible, otherwise returns a client or finally the server.
		The choice is weighted by the reported FPS of the host.

    Parameter(s):
		None

    Returns:
		Client ID [NUMBER]

    Example(s):
		call para_s_fnc_loadbal_suggest_host
*/

private _target = selectRandomWeighted (missionNamespace getVariable ["para_s_loadbal_hc_weighted", []]);
if (!isNil "_target") exitWith { _target };

_target = selectRandomWeighted (missionNamespace getVariable ["para_s_loadbal_players_weighted", []]);
if (!isNil "_target") exitWith { _target };

// Finally, server is nothing else is available.
2