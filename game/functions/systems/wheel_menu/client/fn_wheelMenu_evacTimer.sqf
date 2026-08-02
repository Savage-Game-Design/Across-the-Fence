/*
    File: fn_wheelMenu_evacTimer.sqf
    Author: Atlas
    Date: 2026-03-04
    Last Update: 2026-03-04
    Public: No

    Description:
        Wheel menu wrapper for setting a 30-second extraction timer.
        Checks for nearby radio (or being in the helicopter), shows a
        confirmation dialog, then sets the evacAt timer on the helicopter.

    Parameter(s):
        None (uses player context)

    Returns:
        Nothing

    Example(s):
        [] call vgm_c_fnc_wheelMenu_evacTimer;
*/

private _target = player;
private _helicopter = (group _target) getVariable ["vgm_missions_extraction_helicopter", objNull];
private _radio = _target call vgm_c_fnc_missions_gameplay_extraction_getNearbyRadio;
private _inHelicopter = objectParent _target isEqualTo _helicopter;

if (!_inHelicopter && isNull _radio) exitWith {
    hintSilent localize "STR_VGM_MISSIONS_EXTRACTION_EXTRACT_NO_RADIO";
    playSoundUI ["3DEN_notificationWarning", 0.5];
};

[_target, _helicopter] spawn {
    params ["_target", "_helicopter"];
    sleep 0.5;
    if ([localize "STR_VGM_MISSIONS_EXTRACTION_CONFIRM_TIMED_EXTRACTION", "Confirm", true, true] call BIS_fnc_guiMessage) then {
        _helicopter setVariable ["vgm_missions_extraction_evacAt", serverTime + 30, true];
        ["VGM_ExtractionEvacAt", []] remoteExec ["BIS_fnc_showNotification", units (group _target)];
    };
};
