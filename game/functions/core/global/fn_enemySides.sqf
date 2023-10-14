/*
    File: fn_enemySides.sqf
    Author: Savage Game Design
    Date: 2023-10-13
    Last Update: 2023-10-14
    Public: Yes

    Description:
        Returns sides enemy to given side.

    Parameter(s):
        _side - Side to get enemy sides of [SIDE]

    Returns:
        Enemy sides [ARRAY]

    Example(s):
        playerSide call vgm_g_fnc_enemySides
 */

#define FRIENDSHIP_CONST 0.6

params ["_side"];

[sideEnemy, east, west, resistance, civilian] select {_side getFriend _x < FRIENDSHIP_CONST} // return
