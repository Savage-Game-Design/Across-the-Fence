/*
    File: fn_medical_feedbackHit.sqf
    Author: Savage Game Design
    Date: 2023-07-15
    Last Update: 2023-08-18
    Public: No

    Description:
        Handle feedback effects of being hit.

    Parameter(s):
        None

    Returns:
        Nothing

    Example(s):
        [] call vgm_c_fnc_medical_feedbackHit
 */

if (BIS_canStartRed) then {
    BIS_hitArray call BIS_fnc_radialRed;
};
