/*
    File: fn_skill_passives_fuzemaster.sqf
    Author: Atlas
    Date: 2026-03-03
    Last Update: 2026-03-03
    Public: No

    Description:
        Tail passive — Fuze-master. Adds a player action to cycle M18
        claymore mines between proximity detonation and remote detonation
        modes. Removes old magazine and adds the replacement type.

    Parameter(s):
        _known - Is skill known [BOOL]

    Returns:
        Nothing

    Example(s):
        true call vgm_c_fnc_skill_passives_fuzemaster
 */

params ["_known"];

if (!_known) exitWith {
    if (!isNil "vgm_c_skill_fuzemaster_actionId") then {
        player removeAction vgm_c_skill_fuzemaster_actionId;
        vgm_c_skill_fuzemaster_actionId = nil;
    };
};

vgm_c_skill_fuzemaster_actionId = player addAction [
    localize "STR_VGM_SKILLS_SKILL_FUZEMASTER_ACTION",
    {
        // Cycle between M18 proximity and M18 remote
        private _proxMag = "vn_mine_m18_mag";
        private _remoteMag = "vn_mine_m18_range_mag";
        private _mags = magazines player;

        if (_proxMag in _mags) exitWith {
            player removeMagazine _proxMag;
            player addMagazine _remoteMag;
            hint localize "STR_VGM_SKILLS_SKILL_FUZEMASTER_REMOTE";
        };

        if (_remoteMag in _mags) exitWith {
            player removeMagazine _remoteMag;
            player addMagazine _proxMag;
            hint localize "STR_VGM_SKILLS_SKILL_FUZEMASTER_PROXIMITY";
        };
    },
    nil,
    1.5,
    false,
    true,
    "",
    "'vn_mine_m18_mag' in magazines _this || 'vn_mine_m18_range_mag' in magazines _this"
];
