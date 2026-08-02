/*
    File: fn_skill_passives_heartOfDarkness.sqf
    Author: Atlas
    Date: 2026-03-03
    Last Update: 2026-03-03
    Public: No

    Description:
        Tail passive — Heart of Darkness. Adds a player action to craft
        punji traps or tripwire mines in the field. Requires a toolkit.
        Alternates between punji and tripwire. 30s cooldown.

    Parameter(s):
        _known - Is skill known [BOOL]

    Returns:
        Nothing

    Example(s):
        true call vgm_c_fnc_skill_passives_heartOfDarkness
 */

#define CRAFT_DURATION 5
#define COOLDOWN 30

params ["_known"];

if (!_known) exitWith {
    if (!isNil "vgm_c_skill_heartOfDarkness_actionId") then {
        player removeAction vgm_c_skill_heartOfDarkness_actionId;
        vgm_c_skill_heartOfDarkness_actionId = nil;
    };
};

vgm_c_skill_heartOfDarkness_lastCraft = -COOLDOWN;
vgm_c_skill_heartOfDarkness_alternate = false;

vgm_c_skill_heartOfDarkness_actionId = player addAction [
    localize "STR_VGM_SKILLS_SKILL_HEART_OF_DARKNESS_ACTION",
    {
        // Check cooldown
        if (serverTime - vgm_c_skill_heartOfDarkness_lastCraft < COOLDOWN) exitWith {
            hint format ["Cooldown: %1s remaining", ceil (COOLDOWN - (serverTime - vgm_c_skill_heartOfDarkness_lastCraft))];
        };

        // Start crafting via hold action on ground
        vgm_c_skill_heartOfDarkness_lastCraft = serverTime;

        if (vgm_c_skill_heartOfDarkness_alternate) then {
            player addMagazine "vn_mine_tripwire_f1_mag";
            hint localize "STR_VGM_SKILLS_SKILL_HEART_OF_DARKNESS_TRIPWIRE";
        } else {
            player addMagazine "vn_mine_punji_01_mag";
            hint localize "STR_VGM_SKILLS_SKILL_HEART_OF_DARKNESS_PUNJI";
        };

        vgm_c_skill_heartOfDarkness_alternate = !vgm_c_skill_heartOfDarkness_alternate;
        ["Tail/Heart of Darkness: crafted trap"] call vgm_g_fnc_logInfo;
    },
    nil,
    1.5,
    false,
    true,
    "",
    "'ToolKit' in items _this && serverTime - (missionNamespace getVariable ['vgm_c_skill_heartOfDarkness_lastCraft', -30]) >= 30"
];
