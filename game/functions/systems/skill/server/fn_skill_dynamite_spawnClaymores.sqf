/*
    File: fn_skill_dynamite_spawnClaymores.sqf
    Author: Atlas
    Date: 2026-03-03
    Last Update: 2026-03-03
    Public: No

    Description:
        Server handler for Dynamite skill. Creates claymore mines at
        the given positions and reveals them to the friendly side.

    Parameter(s):
        _positions - Array of positions to place claymores [ARRAY]
        _side - The side to reveal mines to [SIDE]

    Returns:
        Nothing

    Example(s):
        [_positions, playerSide] remoteExecCall ["vgm_s_fnc_skill_dynamite_spawnClaymores", 2]
 */

if (!isServer) exitWith {};

params ["_positions", "_side"];

{
    private _mine = createMine ["vn_mine_m18", _x, [], 0];
    _side revealMine _mine;
} forEach _positions;

format ["Dynamite: Spawned %1 claymores", count _positions] call vgm_g_fnc_logInfo;
