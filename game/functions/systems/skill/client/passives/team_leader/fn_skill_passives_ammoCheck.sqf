/*
    File: fn_skill_passives_ammoCheck.sqf
    Author: Savage Game Design
    Date: 2026-03-03
    Last Update: 2026-03-03
    Public: No

    Description:
        Shows team members ammo state on the HUD. Draws colored indicators
        above teammates showing their primary weapon magazine count.
        Green = well supplied, Yellow = low, Red = critical.

    Parameter(s):
        _apply - Should skill effect be applied? [BOOL]

    Returns:
        Nothing

    Example(s):
        true call vgm_c_fnc_skill_passives_ammoCheck
 */

#define ICON_SIZE 0.7
#define MAX_DRAW_DIST 50
#define COLOR_GOOD [0.4,0.8,0.4,0.7]
#define COLOR_LOW [0.9,0.7,0.2,0.7]
#define COLOR_CRITICAL [0.9,0.2,0.2,0.7]

params ["_apply"];

if (!_apply) exitWith {
    removeMissionEventHandler ["Draw3D", vgm_c_skill_passives_ammoCheck_drawEh];
};

vgm_c_skill_passives_ammoCheck_drawEh = addMissionEventHandler ["Draw3D", {
    private _units = units group player;

    {
        if (_x == player) then { continue };
        if (!alive _x) then { continue };
        if (_x distance player > MAX_DRAW_DIST) then { continue };

        // Count primary weapon magazines
        private _primaryWeapon = primaryWeapon _x;
        if (_primaryWeapon == "") then { continue };

        private _compatibleMags = getArray (configFile >> "CfgWeapons" >> _primaryWeapon >> "magazines");
        private _magCount = {_x in _compatibleMags} count magazines _x;

        // Determine color based on mag count
        private _color = call {
            if (_magCount >= 4) exitWith { COLOR_GOOD };
            if (_magCount >= 2) exitWith { COLOR_LOW };
            COLOR_CRITICAL
        };

        private _text = format ["%1", _magCount];

        drawIcon3D [
            "\a3\ui_f\data\GUI\Rsc\RscDisplayArsenal\primaryWeapon_ca.paa",
            _color,
            (ASLToAGL getPosASLVisual _x) vectorAdd [0, 0, 2.2],
            ICON_SIZE, ICON_SIZE, 0,
            _text,
            2,
            0.035,
            "PuristaMedium"
        ];
    } forEach _units;
}];
