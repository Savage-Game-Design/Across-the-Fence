/*
    File: fn_skill_passives_addAircraft.sqf
    Author: Savage Game Design
    Date: 2023-09-23
    Last Update: 2026-01-25
    Public: No

    Description:
        When known, adds an available aircraft to the RTO system.

    Parameter(s):
        _known - Is skill known [BOOL]
        _aircraftId - Aircraft ID [STRING]

    Returns:
        Nothing

    Example(s):
        [true, "test_plane"] call vgm_c_fnc_skill_passives_addAircraft
 */

params ["_known", "_aircraftId"];

if (_known) then {
    vgm_c_skill_passives_addAircraft_aircraftIds pushBack _aircraftId;
} else {
    vgm_c_skill_passives_addAircraft_aircraftIds = vgm_c_skill_passives_addAircraft_aircraftIds - [_aircraftId];
};
