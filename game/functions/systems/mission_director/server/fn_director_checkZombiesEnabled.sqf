/*
    File: fn_director_checkZombiesEnabled.sqf
    Author: Savage Game Design
    Date: 2025-10-29
    Last Update: 2025-10-29
    Public: Yes

    Description:
        Returns whether zombies are enabled in the gamemode.

    Parameter(s):
        None

    Returns:
        Are zombies enabled? [BOOL]

    Example(s):
        [] call vgm_s_fnc_director_checkZombiesEnabled;
 */

private _hasVietnamZombiesCompat = allAddonsInfo findIf {"zombies_f_vietnam_c" in (_x # 0)} > -1;

_hasVietnamZombiesCompat
