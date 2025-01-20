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
