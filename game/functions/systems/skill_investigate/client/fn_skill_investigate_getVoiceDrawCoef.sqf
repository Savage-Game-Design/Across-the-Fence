/*
    File: fn_skill_investigate_getVoiceDrawCoef.sqf
    Author: Savage Game Design
    Date: 2024-02-11
    Last Update: 2024-02-16
    Public: No

    Description:
        Get icon size coef based on SAM voice type.

    Parameter(s):
        _voiceType - Voice type [STRING]

    Returns:
        Icon draw size coef [NUMBER]

    Example(s):
        "far" call vgm_c_fnc_skill_investigate_getVoiceDrawCoef
 */

params ["_voiceType"];

createHashMapFromArray [
    ["close", 1.5],
    ["close_tunnel", 1],
    ["far", 1.2]
] getOrDefault [_voiceType, 1.5] // return
