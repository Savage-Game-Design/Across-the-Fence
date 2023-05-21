/*
    File: fn_skills_requestSkillActivation.sqf
    Author: Savage Game Design
    Date: 2023-05-21
    Last Update: 2023-05-21
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

params ["_skillPath"];

["DEBUG", "VGM: Requesting skill activation"] call para_g_fnc_log;

systemChat format ["VGM: Requesting skill activation: %1", _skillPath];
[player, _skillPath] remoteExecCall ["vgm_s_fnc_skills_handle_skillActivationRequest", 2];
