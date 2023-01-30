/*
    File: fn_skills_receiveSkillLearn.sqf
    Author:
    Date: 2023-01-27
    Last Update: 2023-01-30
    Public: No

    Description:
        Handle receiving skill learning response from the server.

    Parameter(s):
        _reuslt - Was the learning successful [BOOL]
        _skillsData - Skills data hash if learning was successful [HASHMAP]
        _skillPath - Path of the skill that was being learned [HASHMAP]

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

[_skillsData] call vgm_c_fnc_skills_receiveSkillsData;
