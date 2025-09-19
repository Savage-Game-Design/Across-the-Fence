/*
    File: fn_dangerReport_getProjectileInfo.sqf
    Author: Savage Game Design
    Date: 2024-04-03
    Last Update: 2025-09-19
    Public: No

    Description:
        Retrieves report-relevant info from the configs for a specific projectile type.

        Caches the result to speed up subsequent access.

    Parameter(s):
        _ammoConfig - Config to retrieve information [CONFIG]

    Returns:
        Projectile info [HASHMAP]

    Example(s):
        [configOf _projectile] call vgm_g_fnc_dangerReport_getProjectileInfo
 */

params ["_ammoConfig"];

vgm_g_dangerReport_projectileInfoCache getOrDefaultCall [_ammoConfig, {
    private _result = createHashMap;

    _result set ["brightness", getNumber (_ammoConfig >> "brightness")];
    _result set ["indirectHit", getNumber (_ammoConfig >> "indirectHit")];
    _result set ["indirectHitRange", getNumber (_ammoConfig >> "indirectHitRange")];

    // Create a 0 to 1 representation of explosive power, that treats small explosions
    // (toepopper mines, punji traps) as disproportionately smaller than big ones.
    private _indirectHitRange = _result get "indirectHitRange";
    if (_indirectHitRange <= 1.5) then {
        _result set ["explosivePower", linearConversion [
            0,
            1.5,
            _indirectHitRange,
            0,
            0.1,
            true
        ]];
    } else {
        _result set ["explosivePower", linearConversion [
            1.5,
            10,
            _indirectHitRange,
            0.1,
            1,
            true
        ]];
    };

    private _submunitionAmmo = getText (_ammoConfig >> "submunitionAmmo");
    if (_submunitionAmmo isNotEqualTo "") then {
        private _submunitionBrightness = getNumber (configFile >> "CfgAmmo" >> _submunitionAmmo >> "brightness");
        _result set ["brightness", (_result get "brightness") max _submunitionBrightness];
    };

    _result
}, true]
