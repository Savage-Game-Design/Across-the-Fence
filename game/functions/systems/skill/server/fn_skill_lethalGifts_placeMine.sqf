/*
    File: fn_skill_lethalGifts_placeMine.sqf
    Author: Atlas
    Date: 2026-03-03
    Last Update: 2026-03-03
    Public: No

    Description:
        Server handler for Lethal Gifts skill. Creates a single M14
        toe-popper mine at the given position and reveals it to the
        friendly side.

    Parameter(s):
        _pos - Position to place the mine [ARRAY]
        _side - The side to reveal the mine to [SIDE]

    Returns:
        Nothing

    Example(s):
        [_pos, playerSide] remoteExecCall ["vgm_s_fnc_skill_lethalGifts_placeMine", 2]
 */

if (!isServer) exitWith {};

params ["_pos", "_side"];

private _mine = createMine ["vn_mine_m14", _pos, [], 0];
_side revealMine _mine;
