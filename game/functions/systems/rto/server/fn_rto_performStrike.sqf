/*
    File: fn_rto_performStrike.sqf
    Author: Ethan Johnson and Savage Game Design
    Date: 2026-01-31
    Last Update: 2026-04-19
    Public: Yes

    Description:
        Spawns a plane with predetermined settings from the artillery module GUI

    Parameter(s):
        _planeCfg - Plane config [CONFIG]
        _startPos - Start position for the run  [ARRAY]
        _endPos - End position for the run [ARRAY]
        _magazine - Array of magazines which will be fired from the vehicle [ARRAY]
        _startFiringDistance - How far away the vehicle should be before it starts firing [NUMBER]
        _dispersion - How many metres should the shot vary by. Only applies to guided weapons [NUMBER]
        _unit - Unit that called the artillery [OBJECT]
        _illumination - Is the artillery run an illumination run [NUMBER]

    Returns:
        Function reached the end [BOOL]

    Example(s):
        [configfile >> "cfgvehicles" >> "aircraft_class", "aircraft_class", [0,0,0], [100,100,0], 0, ["rockets"], player, 0] call vgm_fnc_rto_performStrike;
 */

params ["_planeCfg", "_startPos", "_endPos", "_magazine", "_startFiringDistance", "_dispersion" ,"_unit", "_illumination"];

private _vehicle_class = configName _planeCfg;

// No magazine - nothing to fire
private _hasWeapons = count _magazine > 0;

private _dir = _startPos getDir _endPos;
if (_startPos distance2D _endPos < 1) then {_dir = 0};

// No weapons - illumination only, fly an altered route.
if (_illumination > 0 && !_hasWeapons) then {
    // Set target just past the marked target, so the plane goes overhead.
    _startPos = _startPos getPos [200, _dir];
    // Set height for a flyover
    _startPos set [2, 250];
};

private _posATL = _startPos;
private _pos = +_posATL;
_pos set [2,(_pos select 2) + getterrainheightasl _pos];


private _dis = 3000;
private _alt = 1000;
private _pitch = atan (_alt / _dis);
private _speed = 400 / 2.2;
private _duration = ([0,0] distance [_dis,_alt]) / _speed;


//--- Create plane
private _planePos = _pos getPos [_dis, _dir + 180];
_planePos set [2,(_pos select 2) + _alt];
private _planeSide = (getnumber (_planeCfg >> "side")) call bis_fnc_sideType;
([_planePos,_dir,_vehicle_class,_planeSide] call bis_fnc_spawnVehicle) params ["_plane", "_planeCrew", "_planeGroup"];
_plane setposasl _planePos;

_plane move (_pos getPos [_dis, _dir]);
_plane disableai "move";
_plane disableai "target";
_plane disableai "autotarget";
_plane setcombatmode "blue";
// make the AI captive if enabled
if (vn_artillery_captive) then {
    {_x setCaptive true} forEach _planeCrew;
};

private _vectorDir = [_planePos,_pos] call bis_fnc_vectorFromXtoY;
private _velocity = [_vectorDir,_speed] call bis_fnc_vectorMultiply;
_plane setvectordir _vectorDir;
[_plane,-90 + atan (_dis / _alt),0] call bis_fnc_setpitchbank;
private _vectorUp = vectorup _plane;

private _allTurrets = [[-1]] + allTurrets _plane;

{
    private _turret = _x;
    private _weapons = _plane weaponsTurret _turret;
    {
        private _weapon = _x;
        if (_magazine findif {_x == _weapon} <= -1) then
        {
            _plane removeWeaponTurret [_weapon, _turret];
        };
    } foreach _weapons;
} foreach _allTurrets;

{
    if !(_foreachindex < count _magazine && {(_magazine#_foreachindex) != ""}) then
    {
        _plane setPylonLoadout [_foreachindex + 1, "", true];
        continue;
    };

    if (isClass (configfile >> "CfgMagazines" >> (_magazine#_foreachindex))) then
    {
        _plane setPylonLoadout [_foreachindex + 1, _magazine#_foreachindex, true, []];
        continue;
    };

    if (isClass (configfile >> "CfgWeapons" >> (_magazine#_foreachindex))) then
    {
        private _magazines = getArray (configfile >> "CfgWeapons" >> (_magazine#_foreachindex) >> "magazines");
        if (count _magazines >= 1) then
        {
            _plane setPylonLoadout [_foreachindex + 1, _magazines#0, true, []];
        }
        else
        {
            _plane setPylonLoadout [_foreachindex + 1, "", true, []];
        };
        continue;
    };

    _plane setPylonLoadout [_foreachindex + 1, "", true, []];
} forEach getPylonMagazines _plane;

{
    // Passed through weapons will be added along with ammo
    if (isClass (configfile >> "cfgWeapons" >> _x)) then
    {
        _plane addWeaponTurret [_x, _allTurrets # 0];
        private _ammo = getArray (configfile >> "cfgWeapons" >> _x >> "magazines");
        if (count _ammo > 0) then
        {
            _plane addMagazineTurret [_ammo#0, _allTurrets # 0];
        };
    };
} foreach _magazine;

// Forces all pylons to fire in parallel
private _pylonPriorities = getAllPylonsInfo _plane apply { 0 };
_plane setPylonsPriority _pylonPriorities;

private _target = createVehicle ["Land_HelipadEmpty_F", _startPos, [], 0, "CAN_COLLIDE"];

//--- Projectile guidance
_plane addEventHandler ["Fired", {
    params ["_plane", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];

    private _player = _plane getVariable ["vgm_l_rto_player", objnull];
    if (isMultiplayer) then {
        [_projectile, [_plane, _player]] remoteExecCall ["setShotParents", 2];
    };

    private _type = (_weapon call bis_fnc_itemType)#1;
    if (["bomblauncher","grenadelauncher"] findif {_x == _type} > -1) then {
        private _targetPos = getPosASL (_plane getVariable "vgm_l_rto_target");
        private _dispersion = _plane getVariable "vgm_l_rto_dispersion";
        [_projectile, _targetPos vectorAdd [random _dispersion, random _dispersion, 0]] call vgm_s_fnc_rto_guideBomb;
    };
}];

//--- Approach
private _fire = scriptNull;
private _fired = false;
private _time = time;
waitUntil {
    private _fireProgress = _plane getvariable ["fireProgress",0];

    //--- Set the plane approach vector
    _plane setVelocityTransformation
    [
        _planePos, [_pos select 0,_pos select 1,(_pos select 2) + _fireProgress * 12],
        _velocity, _velocity,
        _vectorDir,_vectorDir,
        _vectorUp, _vectorUp,
        (time - _time) / _duration
    ];
    _plane setvelocity velocity _plane;

    _plane setVariable ["vgm_l_rto_player", _unit];
    _plane setVariable ["vgm_l_rto_target", _target];
    _plane setVariable ["vgm_l_rto_dispersion", _dispersion];

    private _goalDistance = [600, 50] select (getPosATL _target # 2 > 150);
    private _distanceToTarget = getPosASL _plane distance ATLtoASL _pos;
    private _inRangeOfTarget = _distanceToTarget < _startFiringDistance;

    //--- Fire!
    if (_inRangeOfTarget && !_fired) then
    {
        _fired = true;
        _fire = [_plane, _target, _illumination, _startFiringDistance, _goalDistance, _hasWeapons] spawn
        {
            params ["_plane", "_target", "_illumination", "_startFiringDistance", "_goalDistance", "_hasWeapons"];
            private _initialDistance = _plane distance _target;
            // Reduce the abort distance if the target is far enough above the terrain
            private _nextFlare = time;
            waituntil
            {
                if (_illumination > 0 && _nextFlare < time) then {

                    private _flare = createVehicle ["vn_flare_plane_med_w_ammo", getPosATL _plane, [], 0, "CAN_COLLIDE"];
                    _flare setVelocity [0, 0, -25];
                    _nextFlare = time + 1;
                };

                if (_hasWeapons) then {
                    {
                        private _weapon = getText (configFile >> "CfgMagazines" >> _x >> "pylonWeapon");
                        private _type = (_weapon call bis_fnc_itemType)#1;
                        diag_log format ["Wanting to fire %1 of type %2", _weapon, _type];
                        if (["bomblauncher","rocketlauncher","grenadelauncher","machinegun","cannon","horn"] findif {_x == _type} > -1) then
                        {
                            // Non-aimed weapons use BIS_fnc_fire
                            [_plane, _weapon] call BIS_fnc_fire;
                        }
                        else
                        {
                            // Aimed weapons use fireAtTarget
                            _plane fireAtTarget [_target, _weapon];
                        };
                    } foreach getPylonMagazines _plane;

                    private _allTurrets = [[-1]] + allTurrets _plane;
                    {
                        private _turret = _x;
                        private _weapons = _plane weaponsTurret _turret;
                        {
                            private _type = (_x call bis_fnc_itemType)#1;
                            diag_log format ["Wanting to turret fire %1 of type %2", _x, _type];
                            if (["bomblauncher","rocketlauncher","grenadelauncher","machinegun","cannon","horn"] findif {_x == _type} > -1) then
                            {
                                // Non-aimed weapons use BIS_fnc_fire
                                [_plane, _x, _turret] call BIS_fnc_fire;
                            }
                            else
                            {
                                // Aimed weapons use fireAtTarget
                                _plane selectWeaponTurret [_x, _turret];
                                _plane fireAtTarget [_target, _x];
                            };
                        } foreach _weapons;
                    } foreach _allTurrets;
                };

                private _currentDistance = _plane distance _target;
                private _fireProgress = linearConversion [_initialDistance, _goalDistance, _currentDistance, 0, 1, true];
                _plane setvariable ["fireProgress", _fireProgress];
                sleep 0.1;
                _fireProgress >= 1 || !alive _plane //--- Shoot only for specific period or only one bomb
            };
        };
    };
    sleep 0.01;
    // Abort at 300m so the plane has time to pull out of the dive.
    if (_distanceToTarget < _goalDistance) then {
        _fired = true;
        terminate _fire;
    };
    (_fired && scriptdone _fire) || !alive _plane
};
_plane setvelocity velocity _plane;
_plane flyinheight _alt;

deleteVehicle _target;

//--- Fire CM
for "_u" from 0 to 1 do
{
    driver _plane forceweaponfire ["CMFlareLauncher","Burst"];
    _time = time + 1.1;
    waituntil {time > _time || isnull _plane};
};

// prevent AI from engaging on it's own after the fire mission was completed
_planeGroup setBehaviour "CARELESS";
_plane enableAI "move";
_plane flyInHeight 100;
_plane move (_pos getPos [_dis, _dir]);

private _despawnTime = time + 180;

waituntil {_plane distance _pos > _dis || !alive _plane || time >= _despawnTime};

//--- Delete plane
if (alive _plane) then
{
    private _group = group _plane;
    private _crew = crew _plane;
    deletevehicle _plane;
    {deletevehicle _x} foreach _crew;
    deletegroup _group;
};
