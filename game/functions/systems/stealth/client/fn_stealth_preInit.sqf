/*
    File: fn_stealth_preInit.sqf
    Author: Savage Game Design
    Date: 2025-01-18
    Last Update: 2025-01-22
    Public: No

    Description:
        Preinit for the stealth system.

*/

/////////////////
// CONFIG VARS //
/////////////////

vgm_c_stealth_visibleDurationWhenSeen = 60;

vgm_c_stealth_visibleOnFiredDelay = 3;
vgm_c_stealth_visibleDurationOnFired = 30;

vgm_c_stealth_stanceMultipliers = createHashMapFromArray [
    ["STAND", 1],
    ["CROUCH", 1.2],
    ["PRONE", 2],
    ["UNDEFINED", 1],
    ["", 1]
];

/////////////////

// True when the player is visible.
vgm_c_stealth_isVisible = false;
// Schedule when the player will become visible
// Format: [when to make the player visible, duration of visibility]
vgm_c_stealth_visibleIn = nil;
// Schedule when the player will stop being visible
vgm_c_stealth_visibleUntil = nil;

// Tracks where the player was when the entity check queue was last refreshed.
vgm_c_stealth_lastEntityQueueScanPos = [-9999, -9999, -9999];
// Queue of AI to be processed in the per frame handler
vgm_c_stealth_entityCheckQueue = [];

// AI that can currently see the player
vgm_c_stealth_looking = createHashMap;
// Queue of AI to be processed in the per frame handler
vgm_c_stealth_lookingQueue = [];


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
                format ["V:%1 - %2 / %3 - %4s", _isVisible, _visibility, _spotThreshold, _x getVariable ["vgm_c_stealth_spotTimeDebug", -1]]
            ]
        } forEach (player nearEntities ["CAManBase", 300]);
    }];
#endif
