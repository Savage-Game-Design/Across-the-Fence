/*
    File: fn_skill_passives_kickOffTime_enableAction.sqf
    Author: Savage Game Design
    Date: 2025-11-08
    Last Update: 2025-12-14
    Public: No

    Description:
        Adds or removes the "Rest overnight vote" action

    Parameter(s):
        _enableAction - True if the action should be added, false otherwise [BOOLEAN]

    Returns:
        Nothing

    Example(s):
        true call vgm_c_fnc_skill_passives_kickOffTime_enableAction;
 */

params ["_enableAction"];

private _actionId = player getVariable ["vgm_c_skill_passives_kickOffTime_actionId", -1];
private _isCorrectAction = player actionParams _actionId select 0 == localize "STR_VGM_SKILLS_SKILL_KICKOFF_TIME_ACTION";

if (_enableAction && (_actionId < 0 || !_isCorrectAction)) exitWith {
    _actionId = player addAction [
        localize "STR_VGM_SKILLS_SKILL_KICKOFF_TIME_ACTION",
        {
            [] remoteExecCall ["vgm_s_fnc_timeOfDayVote_remoteExec_startPreMissionVote", 2];
        },
        [],
        0.05,
        false,
        true,
        "",
        "true",
        -1
    ];

    player setVariable ["vgm_c_skill_passives_kickOffTime_actionId", _actionId];
};

if (!_enableAction && _actionId > 0) exitWith {
    player removeAction _actionId;
    player setVariable ["vgm_c_skill_passives_kickOffTime_actionId", -1];
};
