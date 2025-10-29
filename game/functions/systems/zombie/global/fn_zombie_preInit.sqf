/*
    File: fn_zombie_preInit.sqf
    Author: Savage Game Design
    Date: 2025-10-22
    Last Update: 2025-10-29
    Public: No

    Description:
        Preinit for the zombie system.
 */

vgm_g_zombie_glowingEyes = true;

vgm_g_zombie_initialDamage = 0.45;

vgm_g_zombie_screamerChance = 1 / 2;

vgm_g_zombie_screamAlertRadius = 150;
vgm_g_zombie_screamCooldown = 20;

vgm_g_zombie_alertEventPriorities = createHashMapFromArray [
    ["zombie_alert", 1.25]
];

vgm_g_zombie_animCoefs = createHashMapFromArray [
    ["slow", 1.12],
    ["medium", 0.7],
    ["crawler", 1.4]
];

vgm_g_zombie_defaultSounds = createHashMapFromArray [
    ["moan", ["\ryanzombies\sounds\moaning1.ogg", "\ryanzombies\sounds\moaning2.ogg", "\ryanzombies\sounds\moaning3.ogg", "\ryanzombies\sounds\moaning4.ogg", "\ryanzombies\sounds\moaning5.ogg", "\ryanzombies\sounds\moaning6.ogg", "\ryanzombies\sounds\moaning7.ogg"]],
    ["aggressive", RZ_NormalZombieAggressiveArray],
    ["hit", RZ_ZombieHitArray]
];
