/*
    File: fnc_preInit.sqf
    Author: Savage Game Design
    Date: 2023-07-02
    Last Update: 2025-11-29
    Public: No

    Description:
        Status effect client preInit.
 */

if (!hasInterface) exitWith {};

["forceWalk", {
    params ["_unit", "_inEffect"];
    _unit forceWalk _inEffect;
}, true] call vgm_c_fnc_statusEffect_create;

["forceJog", {
    params ["_unit", "_inEffect"];
    _unit allowSprint !_inEffect;
}, true] call vgm_c_fnc_statusEffect_create;

["forceCrawl", {
    params ["_unit", "_inEffect"];

    // TODO look into possiblity to rewrite into animation event handlers
    // from quick resarch it was proven tricky to implement due to player getting stuck in animations
    private _script = _unit getVariable ["vgm_c_statusEffect_crawlScript", scriptNull];
    if (_inEffect && isNull _script) exitWith {
        _script = _unit spawn {
            while {true} do {
                waitUntil {
                    sleep 0.1;
                    stance _this in ["CROUCH", "STAND"]
                };
                _this playAction "PlayerProne";
            };
        };
        _unit setVariable ["vgm_c_statusEffect_crawlScript", _script];
    };

    if (!_inEffect) exitWith {
        terminate _script;
    };
}] call vgm_c_fnc_statusEffect_create;

["blockADS", {
    params ["_unit", "_inEffect"];

    private _eh = _unit getVariable "vgm_c_statusEffect_adsEh";
    if (_inEffect && isNil "_eh") exitWith {
        _eh = _unit addEventHandler ["OpticsSwitch", {
            params ["_unit", "_isADS"];
            if (!_isADS) exitWith {};
            _unit switchCamera cameraView;
        }];
        _unit setVariable ["vgm_c_statusEffect_adsEh", _eh];
    };

    if (!_inEffect) then {
        _unit setVariable ["vgm_c_statusEffect_adsEh", nil];
        _unit removeEventHandler ["OpticsSwitch", _eh];
    };
}] call vgm_c_fnc_statusEffect_create;

["explosiveSpecialist", {
    params ["_unit", "_inEffect"];
    _unit setUnitTrait ["explosiveSpecialist", _inEffect];
}, true] call vgm_c_fnc_statusEffect_create;

// This is a very complex status effect, as there's so much variation in where magazines are taken from / put
// due to the different reload types (e.g. manually dragging a magazine onto the gun).
// This shouldn't be a way to farm magazines by dumping them into containers, but it's hard to guarantee.
["infiniteMagazines", {
    params ["_unit", "_inEffect"];

    if (!_inEffect) exitWith {
        _unit setVariable ["vgm_c_statusEffect_infiniteMagazines_addMagOnTake", nil];
        _unit setVariable ["vgm_c_statusEffect_infiniteMagazines_deleteMagOnPut", nil];
        _unit removeEventHandler ["Reloaded", _unit getVariable ["vgm_c_statusEffect_infiniteMagazines_reloadedEh", -1]];
        _unit removeEventHandler ["MagazineUnloaded", _unit getVariable ["vgm_c_statusEffect_infiniteMagazines_magazineUnloadedEh", -1]];
        _unit removeEventHandler ["WeaponChanged", _unit getVariable ["vgm_c_statusEffect_infiniteMagazines_weaponChangedEh", -1]];
        _unit removeEventHandler ["Put", _unit getVariable ["vgm_c_statusEffect_infiniteMagazines_putEh", -1]];
        _unit removeEventHandler ["Take", _unit getVariable ["vgm_c_statusEffect_infiniteMagazines_takeEh", -1]];
    };

    // Allow the player to unload whatever magazine is currently in their weapon, but none of the duplicated magazines.
    _unit setVariable ["vgm_c_statusEffect_infiniteMagazines_unloadedMuzzles", createHashMap];

    private _reloadedEh = _unit addEventHandler ["Reloaded", {
        params ["_unit", "_weapon", "_muzzle", "_newMagazine", "_oldMagazine"];

        private _unitWeapons = [primaryWeapon _unit, handgunWeapon _unit, secondaryWeapon _unit];
        if !(_weapon in _unitWeapons) exitWith {};

        _newMagazine params ["_newMagType", "_newMagAmmo"];
        _oldMagazine params ["_oldMagType", "_oldMagAmmo"];

        // Allow the player to unload their first magazine and get a free one without losing their first mag, in case it's their last of that type.
        private _unloadedMuzzles = _unit getVariable "vgm_c_statusEffect_infiniteMagazines_unloadedMuzzles";
        private _hasBeenUnloaded =  _unloadedMuzzles getOrDefault [[_weapon, _muzzle], false];

        if (_hasBeenUnloaded) then {
            // Remove the unloaded magazine, to prevent players restocking on ammo for after the effect ends.
            // Should always go to player's inventory? No "Put" event fires for reload, so we can't be 100% sure where it ends up.
            [_unit, [_oldMagType, _oldMagAmmo]] call vgm_g_fnc_removeMagazineAmmo;
        } else {
            _unloadedMuzzles set [[_weapon, _muzzle], true];
        };

        // Fill up the current magazine so it behaves like a fresh mag.
        private _maxAmmo = getNumber (configFile >> "CfgMagazines" >> _newMagType >> "count");
        _unit setAmmo [_muzzle, _maxAmmo];

        // Add an identical magazine to the player's inventory to act like the mag never left.
        // Handled by the "Take" event which always fires after "Reloaded".
        // Can't handle here in case the reloading magazine is taken from a container - we don't know that in this handler.
        _unit setVariable ["vgm_c_statusEffect_infiniteMagazines_addMagOnTake", _newMagazine];
    }];

    _unit setVariable ["vgm_c_statusEffect_infiniteMagazines_reloadedEh", _reloadedEh];

    // Prevent the player from manually unloading the free magazines to stockpile them.
    private _magazineUnloadedEh = _unit addEventHandler ["MagazineUnloaded", {
        params ["_unit", "_weapon", "_muzzle", "_magazine"];
        _magazine params ["_magType", "_magAmmo"];

        // Empty magazines as discarded - no Put will fire.
        if (_magAmmo isEqualTo 0) exitWith {};

        // Allow the player to unload their first magazine and get a free one without losing their first mag, in case it's their last of that type.
        private _unloadedMuzzles = _unit getVariable "vgm_c_statusEffect_infiniteMagazines_unloadedMuzzles";
        private _hasBeenUnloaded =  _unloadedMuzzles getOrDefault [[_weapon, _muzzle], false];

        if (_hasBeenUnloaded) then {
            _unit setVariable ["vgm_c_statusEffect_infiniteMagazines_deleteMagOnPut", _magazine];
        } else {
            _unloadedMuzzles set [[_weapon, _muzzle], true];
        };
    }];

    _unit setVariable ["vgm_c_statusEffect_infiniteMagazines_magazineUnloadedEh", _magazineUnloadedEh];

    _unit setVariable ["vgm_c_statusEffect_infiniteMagazines_emptyWeaponsHandled", createHashMap];

    private _weaponChangedEh = _unit addEventHandler ["WeaponChanged", {
        params ["_unit", "_oldWeapon", "_newWeapon", "_oldMode", "_newMode", "_oldMuzzle", "_newMuzzle", "_turretIndex"];

        private _emptyWeaponsHandled = _unit getVariable "vgm_c_statusEffect_infiniteMagazines_emptyWeaponsHandled";
        private _key = [_newWeapon, _newMuzzle];

        if (_key in _emptyWeaponsHandled) exitWith {};

        private _possibleMags = compatibleMagazines [currentWeapon _unit, currentMuzzle _unit];
        private _mags = magazines _unit arrayIntersect _possibleMags;

        if (_mags isNotEqualTo []) exitWith {};

        // Prevent the same weapon getting more than one magazine while the effect is active.
        // Prevents ammo farming.
        _emptyWeaponsHandled set [_key, true];
        _unit addMagazine (_possibleMags # 0);
    }];

    _unit setVariable ["vgm_c_statusEffect_infiniteMagazines_weaponChangedEh", _weaponChangedEh];

    // Put always fires after a "MagazineUnloaded" event.
    // Does not fire after "Reloaded" event.
    // Use this to remove the magazine from whatever container it was put in.
    private _putEh = _unit addEventHandler ["Put", {
        params ["_unit", "_container", "_item"];

        private _magUnloaded = _unit getVariable "vgm_c_statusEffect_infiniteMagazines_deleteMagOnPut";
        if (isNil "_magUnloaded") exitWith {};
        _magUnloaded params ["_magType", "_magAmmo"];

        if (_magType isNotEqualTo _item) exitWith {};

        _unit setVariable ["vgm_c_statusEffect_infiniteMagazines_deleteMagOnPut", nil];
        // "Put" is not always called with the container - sometimes it's called with the unit, where addMagazineAmmoCargo doesn't work.
        if (_container isEqualTo _unit) then {
            // Remove the magazine from wherever it ended up on the player.
            [_unit, _magUnloaded] call vgm_g_fnc_removeMagazineAmmo;
        } else {
            _container addMagazineAmmoCargo [_magType, -1, _magAmmo];
        };
    }];

    _unit setVariable ["vgm_c_statusEffect_infiniteMagazines_putEh", _putEh];

    // Take always fires after a "Reloaded" event.
    // Use this to replenish the magazine from whatever container it was taken from.
    private _takeEh = _unit addEventHandler ["Take", {
        params ["_unit", "_container", "_item"];

        private _magReloaded = _unit getVariable "vgm_c_statusEffect_infiniteMagazines_addMagOnTake";
        if (isNil "_magReloaded") exitWith {};
        _magReloaded params ["_magType", "_magAmmo"];

        if (_magType isNotEqualTo _item) exitWith {};

        _unit setVariable ["vgm_c_statusEffect_infiniteMagazines_addMagOnTake", nil];
        // This case didn't happen when testing - but as Put has a similar case, it makes sense to be careful here.
        if (_container isEqualTo _unit) exitWith {
            _unit addMagazine [_magType, _magAmmo];
        };

        // Only allow this replenishment logic to work for the player's inventory so we don't have to worry about locality and latency.
        private _validContainers = [uniformContainer _unit, vestContainer _unit, backpackContainer _unit];
        if (_container in _validContainers) exitWith {
            _container addMagazineAmmoCargo [_magType, 1, _magAmmo];
        };
    }];

    _unit setVariable ["vgm_c_statusEffect_infiniteMagazines_takeEh", _takeEh];
}] call vgm_c_fnc_statusEffect_create;
