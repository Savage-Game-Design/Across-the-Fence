/*
    File: fn_dangerReport_getProjectileInfo.sqf
    Author: Savage Game Design
    Date: 2024-04-03
    Last Update: 2024-11-02
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
    _result set ["indirectHitRadius", getNumber (_ammoConfig >> "indirectHitRadius")];

    private _submunitionAmmo = getText (_ammoConfig >> "submunitionAmmo");
    if (_submunitionAmmo isNotEqualTo "") then {
        private _submunitionBrightness = getNumber (configFile >> "CfgAmmo" >> _submunitionAmmo >> "brightness");
        _result set ["brightness", (_result get "brightness") max _submunitionBrightness];
    };

    _result
}, true]
