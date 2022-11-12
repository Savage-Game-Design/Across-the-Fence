/*
    File: fn_behaviour_process_claimed_statics.sqf
    Author:  Savage Game Design
    Public: No

    Description:
        'Mount claimed statics' behaviour. ORders units in the squad to mount any statics we've claimed.
		If we can't man any statics, unclaim them.

    Parameter(s):
        _group - Group to run the behaviour on.

    Returns:
        Function reached the end [BOOL]

    Example(s):
        [_group] call para_g_fnc_behaviour_process_claimed_statics
*/

params ["_group"];

private _unitsAssignedVehicles = _group getVariable ["behaviourUnitsAssignedVehicles", []];
private _freeUnits = units _group - _unitsAssignedVehicles;

private _claimedStatics = _group getVariable ["behaviourAssignedVehicles", []] select {_x isKindOf "StaticWeapon"};

{
    private _static = _x;
    //No gunner.
    if (isNull gunner _static) then {
        //See if we've got anyone assigned. If so, don't need to do anything.
        if (units _group findIf {assignedVehicle _x isEqualTo _static} > -1) exitWith {};
        //If we haven't got anyone assigned, and no spare units, we shouldn't hold onto the static.
        if (_freeUnits isEqualTo []) exitWith {
            [_group, _x] call para_g_fnc_behaviour_vehicle_unassign;
        };
        //Otherwise, we allocate someone to crew it.
        private _crew = selectRandom _freeUnits;
        _crew assignAsGunner _static;
        [_crew] orderGetIn true;
        _freeUnits = _freeUnits - [_crew];
    } else {
        //If there's a gunner from another group in there, release the static, we can't use it!
        if (group gunner _static != _group) exitWith {
            [_group, _static] call para_g_fnc_behaviour_vehicle_unassign;
        };

        if (getNumber (configFile >> "CfgVehicles" >> typeOf _static >> "artilleryScanner") ==  1) then
        {
            //diag_log format ["Detected %1 mounted on mortar", _group];
            private _mortarLastFired = _static getVariable ["artilleryLastFired", 0];
            private _delay = _static getVariable ["fireDelay", 20];
            if (serverTime > _mortarLastFired + _delay && random 1 > 0.3) then
            {
                private _enemyPositionReports = _group getVariable ["behaviourReportedEnemyPositions", []];
                private _targets = [];
                {
                    private _units = allPlayers inAreaArray [_x # 1, 50, 50];
                    if !(_units isEqualTo []) exitWith {
                        _targets = _units;
                    };
                } forEach _enemyPositionReports;

                if (_targets isEqualTo []) exitWith {};
                diag_log "Firing mortar";
                private _targetPos = getPos (selectRandom _targets) vectorAdd [random 180 - 90, random 180 - 90, 0];
                diag_log format ["Firing mortar at %1", _targetPos];
                diag_log "Firing now!";
                _static doArtilleryFire [_targetPos, getArtilleryAmmo [_static] select 0, ceil (1 + random 1)];
                _static setVariable ["artilleryLastFired", serverTime];
            };
        };
    };
} forEach _claimedStatics;
