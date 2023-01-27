/*
    File: fn_skills_receiveSkillLearn.sqf
    Author:
    Date: 2023-01-27
    Last Update: 2023-01-27
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

params ["_result", "_skillsData", "_skillPath"];

["DEBUG", format ["VGM: Received skills learn for %1 with result %2", _skillPath, _result]] call para_g_fnc_log;

// close the popup
// TODO keep the popup display in variable and close it via it
uiNamespace setVariable ["BIS_fnc_guiMessage_status", _result];

if (!_result) exitWith {
    hint "Failed to learn skill";
};

hint "Learnt skill";

["vgm_skills_learnt", _skillPath] call para_g_fnc_event_trigger;

[_skillsData] call vgm_c_fnc_skills_receiveSkillsData;
