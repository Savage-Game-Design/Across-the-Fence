/*
    File: fn_skill_passives_staboExtract_request.sqf
    Author: Atlas
    Date: 2026-03-06
    Last Update: 2026-03-06
    Public: No

    Description:
        Wheel menu callback for STABO extraction request. Checks for a nearby
        radio, shows confirmation dialog, then sends request to server.

    Parameter(s):
        None

    Returns:
        Nothing

    Example(s):
        [] spawn vgm_c_fnc_skill_passives_staboExtract_request;
 */

if (!hasInterface) exitWith {};

// Radio check
private _radio = player call vgm_c_fnc_missions_gameplay_extraction_getNearbyRadio;
if (isNull _radio) exitWith {
    hintSilent localize "STR_VGM_MISSIONS_EXTRACTION_REQUEST_NO_RADIO";
    playSoundUI ["3DEN_notificationWarning", 0.5];
};

// Prevent double-calling or mixing with normal extraction
private _grp = group player;
if (!(_grp getVariable ["vgm_missions_extraction_canRequest", true])) exitWith {
    hintSilent localize "STR_VGM_SKILLS_SKILL_STABO_EXTRACT_ALREADY_REQUESTED";
};

if ([localize "STR_VGM_SKILLS_SKILL_STABO_EXTRACT_CONFIRM", "Confirm", true, true] call BIS_fnc_guiMessage) then {
    private _currentMission = [] call vgm_c_fnc_missions_getCurrentMission;
    if (isNil "_currentMission") exitWith {};

    // Mark extraction as requested
    _grp setVariable ["vgm_missions_extraction_canRequest", false, true];

    // Send request to server
    [_currentMission get "id", getPosATL player] remoteExecCall ["vgm_s_fnc_skill_staboExtract_startExtract", 2];

    hintSilent localize "STR_VGM_SKILLS_SKILL_STABO_EXTRACT_REQUESTED";
    format ["STABO: Extraction requested by %1", name player] call vgm_g_fnc_logInfo;
};
