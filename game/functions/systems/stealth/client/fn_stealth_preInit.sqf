/*
    File: fn_stealth_preInit.sqf
    Author: Savage Game Design
    Date: 2025-01-18
    Last Update: 2025-01-20
    Public: No

    Description:
        Preinit for the stealth system.

*/

vgm_c_stealth_stanceMultipliers = createHashMapFromArray [
    ["STAND", 1],
    ["CROUCH", 1.2],
    ["PRONE", 1.5],
    ["UNDEFINED", 1],
    ["", 1]
];

vgm_c_stealth_lastEntityScanPos = [-9999, -9999, -9999];
vgm_c_stealth_entityCheckQueue = [];

vgm_c_stealth_looking = createHashMap;
vgm_c_stealth_lookingQueue = [];

vgm_c_stealth_isVisible = false;
vgm_c_stealth_visibleUntil = nil;

vgm_c_stealth_visibleDurationWhenSeen = 15;

#ifdef __A3_DEBUG__
    vgm_c_stealth_drawDebug = false;

    vgm_c_stealth_debugEH = addMissionEventHandler ["Draw3D", {
        if (vgm_c_stealth_drawDebug == false) exitWith {};
        {
            if (side _x != east) then {continue};
            private _canSee1 = lineIntersectsSurfaces [eyePos player, aimPos _x, player, _x, true, 1, "FIRE"] isEqualTo [];
            private _canSee2 = lineIntersectsSurfaces [eyePos player, eyePos _x, player, _x, true, 1, "FIRE"] isEqualTo [];
            if !(_canSee1 || _canSee2) then {continue};
            _x getVariable ["vgm_c_stealth_visibleResults", [false, -1]] params ["_isVisible", "_visibility", "_spotThreshold"];
            private _color = [[0,1,0,1],[1,0,0,1]] select _isVisible;
            drawIcon3D [
                "",
                [[0,0,0,0],_color],
                ASLtoAGL aimPos _x vectorAdd [0,0, 0.5],
                0,
                0,
                0,
                format ["V:%1 - %2 / %3", _isVisible, _visibility, _spotThreshold]
            ]
        } forEach (player nearEntities ["CAManBase", 300]);
    }];
#endif
