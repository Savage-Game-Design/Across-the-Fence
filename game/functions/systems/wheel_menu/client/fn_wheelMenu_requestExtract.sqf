/*
    File: fn_wheelMenu_requestExtract.sqf
    Author: Atlas
    Date: 2026-03-04
    Last Update: 2026-03-04
    Public: No

    Description:
        Wheel menu wrapper for requesting extraction. Checks for a nearby radio,
        shows a confirmation dialog, then calls the extraction request function.

    Parameter(s):
        None (uses player context)

    Returns:
        Nothing

    Example(s):
        [] call vgm_c_fnc_wheelMenu_requestExtract;
*/

private _target = player;

// Block extraction if player is inside a radio jammer's radius
private _jamDist = call vgm_c_fnc_radioJamming_isPlayerJammed;
if (_jamDist >= 0) exitWith {
    hint format [localize "STR_VGM_RADIO_JAMMED", (round (_jamDist / 100)) * 100];
    playSoundUI ["3DEN_notificationWarning", 0.5];
};

private _radio = _target call vgm_c_fnc_missions_gameplay_extraction_getNearbyRadio;

if (isNull _radio) exitWith {
    hint localize "STR_VGM_MISSIONS_EXTRACTION_REQUEST_NO_RADIO";
    playSoundUI ["3DEN_notificationWarning", 0.5];
};

[_target, _radio] spawn {
    sleep 0.5;
    if (["Are you sure?", "Confirm", true, true] call BIS_fnc_guiMessage) then {
        _this call vgm_c_fnc_missions_gameplay_extraction_requestExtraction;
    };
};
