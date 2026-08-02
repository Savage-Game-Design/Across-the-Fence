/*
    File: fn_voicelines_playDelayed.sqf
    Author: Atlas
    Date: 2026-03-04
    Last Update: 2026-03-04
    Public: No

    Description:
        Wrapper for delayed voice line playback. Spawns a scheduled script that
        waits the specified delay then calls vgm_s_fnc_voicelines_play.

    Parameter(s):
        _delay        - Seconds to wait before playing [NUMBER]
        _category     - Voice line category [STRING]
        _subcategory  - Subcategory [STRING]
        _requiresRTO  - Whether this line requires an RTO [BOOLEAN]
        _speakerUnit  - (Optional) Unit to speak the line [OBJECT, default objNull]
        _priority     - (Optional) Priority override [BOOLEAN, default false]

    Returns:
        Spawned script handle [SCRIPT]

    Example(s):
        [5, "insertion", "lz_approach", false] call vgm_s_fnc_voicelines_playDelayed;
        [30, "tracker", "warning", true] call vgm_s_fnc_voicelines_playDelayed;
*/

if (!isServer) exitWith {scriptNull};

params ["_delay", "_category", "_subcategory", ["_requiresRTO", false], ["_speakerUnit", objNull], ["_priority", false]];

[_delay, _category, _subcategory, _requiresRTO, _speakerUnit, _priority] spawn {
    params ["_delay", "_category", "_subcategory", "_requiresRTO", "_speakerUnit", "_priority"];
    sleep _delay;
    [_category, _subcategory, _requiresRTO, _speakerUnit, _priority] call vgm_s_fnc_voicelines_play;
}
