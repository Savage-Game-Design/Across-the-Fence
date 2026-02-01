/*
    File: fn_rto_performStrike.sqf
    Author: Ethan Johnson and Savage Game Design
    Date: 2026-01-31
    Last Update: 2026-02-01
    Public: Yes

    Description:
        Spawns a plane with predetermined settings from the artillery module GUI

    Parameter(s):
        _planeCfg - Plane config [CONFIG]
        _start_pos - Start position for the run  [ARRAY]
        _end_pos - End position for the run [ARRAY]
        _magazine - Array of magazines which will be fired from the vehicle [ARRAY]
        _fireDurationSecs - How long the vehicle should fire for [NUMBER]
        _dispersion - How many metres should the shot vary by. Only applies to guided weapons [NUMBER]
        _unit - Unit that called the artillery [OBJECT]
        _illumination - Is the artillery run an illumination run [NUMBER]

    Returns:
        Function reached the end [BOOL]

    Example(s):
        [configfile >> "cfgvehicles" >> "aircraft_class", "aircraft_class", [0,0,0], [100,100,0], 0, ["rockets"], player, 0] call vgm_fnc_rto_performStrike;
 */

params ["_planeCfg", "_start_pos", "_end_pos", "_magazine", "_fireDurationSecs", "_dispersion" ,"_unit", "_illumination"];

private _vehicle_class = configName _planeCfg;

// Default to a 3 second fire duration if the given duration is invalid.
if (_fireDurationSecs <= 0) then {
    _fireDurationSecs = 3;
};

private _posATL = _start_pos;
private _pos = +_posATL;
_pos set [2,(_pos select 2) + getterrainheightasl _pos];
private _dir = _start_pos getDir _end_pos;
if (_start_pos distance2D _end_pos < 1) then {_dir = 0};

private _dis = 3000;
private _alt = 1000;
private _pitch = atan (_alt / _dis);
private _speed = 400 / 3.6;
private _duration = ([0,0] distance [_dis,_alt]) / _speed;

//--- Create plane
private _planePos = [_pos,_dis,_dir + 180] call bis_fnc_relpos;
_planePos set [2,(_pos select 2) + _alt];
private _planeSide = (getnumber (_planeCfg >> "side")) call bis_fnc_sideType;
([_planePos,_dir,_vehicle_class,_planeSide] call bis_fnc_spawnVehicle) params ["_plane", "_planeCrew", "_planeGroup"];
_plane setposasl _planePos;

_plane move ([_pos,_dis,_dir] call bis_fnc_relpos);
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

private _target = createVehicle ["Land_HelipadEmpty_F", _start_pos, [], 0, "CAN_COLLIDE"];

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
private _fire = [] spawn {waituntil {false}};
private _fireNull = true;
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

    //--- Fire!
    if ((getposasl _plane) distance _pos < 1000 && {_fireNull && {_illumination <= 0}}) then
    {
        _fireNull = false;
        terminate _fire;
        _fire = [_plane, _target, _illumination, _fireDurationSecs] spawn
        {
            params ["_plane", "_target", "_illumination", "_fireDurationSecs"];
            private _time = time + _fireDurationSecs;
            waituntil
            {
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

                _plane setvariable ["fireProgress",(1 - ((_time - time) / _fireDurationSecs)) max 0 min 1];
                sleep 0.1;
                time > _time || isnull _plane //--- Shoot only for specific period or only one bomb
            };
            sleep 1;
        };
    };
    sleep 0.01;
    scriptdone _fire || isnull _plane
};
_plane setvelocity velocity _plane;
_plane flyinheight _alt;

if (_illumination > 0) then
{
    [_plane] spawn
    {
        params ["_plane"];
        private _time = time + 10;
        waituntil {time > _time};
        private _flare = createVehicle ["vn_flare_plane_med_w_ammo", getPosATL _plane, [], 0, "CAN_COLLIDE"];
        _flare setVelocity [0, 0, -25];
    };
};

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

waituntil {_plane distance _pos > _dis || !alive _plane};

//--- Delete plane
if (alive _plane) then
{
    private _group = group _plane;
    private _crew = crew _plane;
    deletevehicle _plane;
    {deletevehicle _x} foreach _crew;
    deletegroup _group;
};
