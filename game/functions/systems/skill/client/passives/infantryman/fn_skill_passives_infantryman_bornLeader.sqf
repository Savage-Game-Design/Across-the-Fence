/*
    File: fn_skill_passive_infantryman_overprepared.sqf
    Author: Savage Game Design
    Date: 2023-09-14
    Last Update: 2023-09-23
    Public: No

    Description:
        Adds logic for Rifleman Tier 3 Born Leader skill.

    Parameter(s):
        _known - Is skill known [BOOL]

    Returns:
        Nothing

    Example(s):
        true call vgm_c_fnc_skill_passives_infantryman_bornLeader
 */

params ["_known"];

player setVariable ["vgm_g_skill_actives_bornLeader", _known, true];
