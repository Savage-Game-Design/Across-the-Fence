/*
    File: fn_skill_lethalGifts2_placeClaymore.sqf
    Author: Atlas
    Date: 2026-03-03
    Last Update: 2026-03-03
    Public: No

    Description:
        Server handler for Lethal Gifts 2 skill. Creates a timed
        claymore at the given position that detonates after 40s.
        Mine is revealed to the friendly side.

    Parameter(s):
        _pos - Position to place the claymore [ARRAY]
        _side - The side to reveal the mine to [SIDE]

    Returns:
        Nothing

    Example(s):
        [_pos, playerSide] remoteExecCall ["vgm_s_fnc_skill_lethalGifts2_placeClaymore", 2]
 */

if (!isServer) exitWith {};

params ["_pos", "_side"];

private _mine = createMine ["vn_mine_m18", _pos, [], 0];
_side revealMine _mine;

// Detonate after 40 seconds
[_mine] spawn {
    params ["_mine"];
    sleep 40;
    if (!isNull _mine) then {
        private _pos = getPos _mine;
        deleteVehicle _mine;
        "vn_mine_m18_ammo" createVehicle _pos;
    };
};
