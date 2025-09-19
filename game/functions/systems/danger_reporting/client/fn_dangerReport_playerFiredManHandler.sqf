/*
    File: fn_dangerReport_playerFiredManHandler.sqf
    Author: Savage Game Design
    Date: 2024-03-02
    Last Update: 2025-09-19
    Public: No

    Description:
        "FiredMan" handler for the player, that reports gunshots and explosions.

    Parameter(s):
        N/A

    Returns:
        Something [BOOL]

    Example(s):
        player addEventHandler ["FiredMan", vgm_c_fnc_dangerReport_playerFiredManHandler];
 */

params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_vehicle"];

_projectile addEventHandler ["Explode", {
    params ["_projectile", "_pos", "_velocity"];

    private _projectileInfo = [configOf _projectile] call vgm_g_fnc_dangerReport_getProjectileInfo;
    private _brightness = _projectileInfo get "brightness";

    // Flares
    if (_brightness > 0) exitWith {
        [
            vgm_c_dangerReport_locEventGroup,
            _pos,
            _brightness * vgm_c_dangerReport_brightnessToRangeMultiplier,
            "player_flare",
            [_brightness]
        ] call vgm_g_fnc_locEvents_triggerEvent;
    };

    // Explosives
    if ((_projectileInfo get "indirectHit") > 0) exitWith {
        private _notifyRadius = linearConversion [
            0,
            1,
            _projectileInfo get "explosivePower",
            vgm_c_dangerReport_explosionNoiseRadiusRange # 0,
            vgm_c_dangerReport_explosionNoiseRadiusRange # 1
        ];

        [
            vgm_c_dangerReport_locEventGroup,
            _pos,
            _notifyRadius,
            "player_explosion",
            [configOf _projectile]
        ] call vgm_g_fnc_locEvents_triggerEvent;
    };
}];

// Throwing grenades and placing charges shouldn't count as shooting.
if (_weapon in ["Put", "Throw"]) exitWith {};

private _muzzleAttachment = _unit weaponAccessories _weapon select 0;

private _isSuppressed = vgm_c_dangerReport_shotSuppressionCache getOrDefaultCall [
    [_weapon, _muzzleAttachment, _ammo],
    {
        private _return = false;
        // Weapons with an integral suppressor use an ammo type with a audibleFire < 1
        private _ammoVolume = getNumber (configFile >> "CfgAmmo" >> _ammo >> "audibleFire");
        if (_ammoVolume < 1) then {
            _return = true;
        };

        // Check if muzzle is a silencer.
        if (!_return && _muzzleAttachment isNotEqualTo "") then {
            // Check the muzzle attachment's audibleFire coef.
            private _audibleFire = getNumber (configFile >> "CfgWeapons" >> _muzzleAttachment >> "ItemInfo" >> "AmmoCoef" >> "audibleFire");
            // Technically, silencers could have different effectiveness. In reality, everything in VN and vanilla is basically the same.
            // Need to check if _audibleFire < 1, as it looks like a loundener also exists with audibleFire 1.1.
            _return = _audibleFire > 0 && _audibleFire < 1;
        };

        _return
    },
    true
];

private _recentShots = vgm_c_dangerReport_recentShots;
private _previousTotalShots = _recentShots get "totalShots";

_recentShots set ["averagePosition",
    (_recentShots get "averagePosition")
    vectorMultiply _previousTotalShots
    vectorAdd (getPosASL player)
    vectorMultiply (1 / (_previousTotalShots + 1))
];

_recentShots set ["totalShots", (_recentShots get "totalShots") + 1];

private _key = ["unsuppressedShots", "suppressedShots"] select _isSuppressed;
_recentShots set [_key, (_recentShots get _key) + 1];

// Queue up recent shots to be sent to the server when the time period ends.
if (vgm_c_dangerReport_nextRecentShotsTime < time) then {
    vgm_c_dangerReport_nextRecentShotsTime = time + vgm_c_dangerReport_recentShotsPeriod;
};
